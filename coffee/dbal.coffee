###
#
# DBAL : Database Abstraction layer
# coffee/dbal.coffee
# Copyright © 2014 mparaiso <mparaiso@online.fr>. All Rights Reserved.
###

mysql = require "mysql"
q = require "q"
_ = require "lodash"
util = require "util"
# Classes

###*
# Build SQL EXPRESSIONS
###
class ExpressionBuilder
    @nullOperators={$null:"?? IS NULL",$nnull:"?? IS NOT NULL"}
    @operators = {$eq:"?? <=> ?",$ne:"?? != ?",$neq:"?? != ?",$in:'?? IN (?)',$nin:'?? NOT IN (?)',$gt:'?? > ?',$lt:'?? < ?',$gte:'?? >= ?',$lte:'?? <= ?',$like:'?? LIKE ?'}
    @subExpressionOperators = {$or: "%s OR %s" ,$and: "%s AND %s",$nor:"%$ OR NOT %s"}
    @unaryOperators = {$not: "NOT "}

    constructor:(@expression={},@params=[],@subExpressionOperator="$and",@unaryOperator)->
        @string=[]
    ###
    # is operator
    # @return boolean
    ###
    isOperator:(value)->
        not _.isNull(value) and typeof value is "object" and  ExpressionBuilder.operators.hasOwnProperty(Object.keys(value)[0])
    ###
    # is subexp operator ($and,$or...)
    # @return boolean
    ###
    isSubExpressionOperator:(key)->
        ExpressionBuilder.subExpressionOperators.hasOwnProperty(key)
    ### 
    # is unary operator ($not...)
    # @return boolean 
    ###
    isUnaryOperator:(key)->
        ExpressionBuilder.unaryOperators.hasOwnProperty(key)
    ###
    # operator from a key/value pair 
    # @return string
    ###
    operatorFrom:(value)->
        Object.keys(value)[0]
    ###
    # value from a key value pair
    ###
    valueFrom:(value)->
        value[@operatorFrom(value)]
    reset:()->
        @params=[]
        @string=[]
        @expression=[]
        return
    ### build an expression , returns the expression string and the parameter list ###
    build:->
        for key,value of @expression
            switch
                # unary
                when @isUnaryOperator(key)
                    eb = new ExpressionBuilder(value,@params,"$and",key)
                    [val]=eb.build()
                    @string.push(val)
                #subexpression
                when @isSubExpressionOperator(key)
                    eb = new ExpressionBuilder(value,@params,key)
                    [val]=eb.build()
                    @string.push(val)
                #regular operator
                when @isOperator(value)
                    if Object.keys(value).length is 1 
                        # one operator fo a column , eg {a:{$lt:3}}
                        operator = @operatorFrom(value)
                        value = @valueFrom(value)
                        @string.push(ExpressionBuilder.operators[operator])
                        ### @TODO check special cases like IS NULL , IS NOT NULL ...### 
                        @params.push(key,value)
                    else
                        # multipe operators for the same column , eg {a:{$lt:0,$gt10,$neq:5}}
                        criteria={}
                        operators = Object.keys(value)
                        params = _.values(value).reduce((array,val)->
                            array.push(key,val);
                            return array
                        ,[])
                        @params= @params.concat(params)
                        string = []
                        string.push(operators.map((op)->ExpressionBuilder.operators[op])...)
                        @string.push(" ( " + string.reduce((result,operator)-> util.format(ExpressionBuilder.subExpressionOperators['$and'],result,operator)) + " ) " )

                else
                    # eg {b:5}
                    operator = "$eq"
                    @string.push(ExpressionBuilder.operators[operator])
                    @params.push(key,value)
        return [@toString(),@params]
    ### render the build expression , to be called after build ###
    toString:->
        switch @string.length
            when 0
                ""
            else
                " #{if @unaryOperator then ExpressionBuilder.unaryOperators[@unaryOperator] else ""}(#{@string.reduce((c,n)=> util.format(ExpressionBuilder.subExpressionOperators[@subExpressionOperator],c,n) )}) "

###*
# Build SQL QUERIES
###
class QueryBuilder
    constructor:(connection:@connection,tableName:@tableName,idColumnName:@idColumnName)->
        @model={}
    delete:()->
        @type = "DELETE"
        return this
    update:(@model={})->
        @type = "UPDATE"
        return this
    select:(@select="*")->
        @type  = "SELECT"
        return this
    from:(@tableName)->
        return this
    insert:(@model={})->
        @type = "INSERT"
        return this
    where:(@criteria)->
        return this
    limit:(@_limit,@offset=0)->
        return this
    orderBy:(@_orderBy)->
        return this
    build:(model={})->
        _.extend(@model,model)
        params = []
        switch @type
            when "DELETE"
                if @criteria is undefined then throw "BaseDataAccessObject#update requires an id or a criteria as second parameter"
                if typeof @criteria isnt "object" then temp = {} ; temp[@idColumnName] =@criteria; @criteria=temp
                params.push(@tableName)
                [whereString,p]=(new ExpressionBuilder(@criteria)).build()
                params=params.concat(p)
                if @_orderBy then params.push(@_orderBy)
                if @_limit then params.push(@_limit)
                ["DELETE FROM ?? #{if whereString then "WHERE #{whereString}" else '' } #{if @_orderBy then 'ORDER BY ?' else '' } #{if @_limit then 'LIMIT ? 'else '' }".trimRight(),params]
            when "UPDATE"
                if @criteria is undefined then throw "QueryBuilder#update requires an id or a criteria as second parameter"
                if typeof @criteria isnt "object" then temp = {} ; temp[@idColumnName] =@criteria; @criteria=temp
                params.push(@tableName)
                params.push(@model)
                [whereString,p]=(new ExpressionBuilder(@criteria)).build()
                params=params.concat(p)
                if @_orderBy then params.push(@_orderBy)
                if @_limit then params.push(@_limit)
                ["UPDATE ?? SET (?) #{if whereString then "WHERE #{whereString}" else '' } #{if @_orderBy then 'ORDER BY ?' else '' } #{if @_limit then 'LIMIT ? 'else '' }".trimRight(),params]
            when "SELECT"
                [whereString,p] = (new ExpressionBuilder(@criteria)).build()
                if @select isnt "*" then params.push(@select)
                params.push(@tableName)
                params = params.concat(p)
                if @_orderBy isnt undefined then params.push(@_orderBy)
                if @_limit isnt undefined then params.push([@offset,@_limit])
                ["SELECT #{if @select isnt "*" then "??" else "*" } FROM ?? #{if whereString then "WHERE #{whereString}" else "" } #{if @_orderBy then 'ORDER BY ?' else '' } #{if @_limit then 'LIMIT ?' else '' }".trimRight(), params]
            when "INSERT"
                params.push(@tableName)
                params.push(@model)
                ["INSERT INTO ?? SET (?)",params]
    
###
# Base class for data access objects
###
class BaseDataAccessObject
    constructor:(connection:@connection,tableName:@tableName,idColumnName:@idColumnName)->
    findAll:->
        @query(@createQueryBuilder().select().build()...)
    findBy:(criteria={},orderBy,limit,offset=0)->
        @query(@createQueryBuilder().select().where(criteria).orderBy(orderBy).limit(limit,offset).build()...)
    findOneBy:(criteria,orderBy)->
        @findBy(criteria,orderBy,1)
        .then((results)->results[0])
    find:(id)->
        criteria = {} ; criteria[@idColumnName]=id
        @findOneBy(criteria)
    insert:(model)->
        @query(@createQueryBuilder().insert(model).build()...)
    update:(model,criteria,orderBy,limit=1)->
        @query(@createQueryBuilder().update(model).where(criteria).orderBy(orderBy).limit(limit).build()...)
    delete:(criteria,orderBy,limit=1)->
        @query(@createQueryBuilder().delete().where(criteria).orderBy(orderBy).limit(limit).build()...)
    createQueryBuilder:()->
        new QueryBuilder(tableName:@tableName,connection:@connection,idColumnName:@idColumnName)
    
    query:(query,params,options)->
        q.ninvoke(@connection,'query',query,params)
        .spread((results,fields)=>results)
    ###
    # given a list of records populate a virtual field owned by the record according to the relative id
    # @return (collection:Array<T>)=>Promise<Array<T>> returns a function
    ###
    populate:(ownedDataAccessObject,idColumnName,ownedIdColumnName,virtualColumnName)->
        (collection)->
            q(collection)
            .then((collection)-> criteria = {} ; criteria[ownedIdColumnName] = {$in:_(collection).pluck(idColumnName).uniq().value()} ; [collection,ownedDataAccessObject.findBy(criteria)] )
            .spread((collection,ownedCollection)->
                _.map(collection,(item)->
                    item[virtualColumnName] = _.find(ownedCollection,(ownedItem)->item[idColumnName]==ownedItem[ownedIdColumnName])
                    item
                )
            )
    ###
    # like populate but for 1 record
    # @return (record:T)=>Promise<T>
    ###
    populateOne:(ownedDataAccessObject,idColumnName,virtualColumnName)->
        (record)->
            q(record)
                .then((record)->[record,ownedDataAccessObject.find(if record then record[idColumnName] else null)])
            .spread((record,ownedRecord)->
                if record then record[virtualColumnName]=ownedRecord
                record
            )

module.exports = {ExpressionBuilder,QueryBuilder,BaseDataAccessObject}
