Pimple = require "pimple"
express = require "express"
mysql = require "mysql"
q = require "q"
path = require "path"
swig = require "swig"
slug = require "slug"
_ = require "lodash"
###
# Classes
###

class BaseDataAccessObject
    constructor:(connection:@connection,tableName:@tableName,idColumnName:@idColumnName)->
    findAll:->
        q.ninvoke(@connection,'query',"SELECT * from #{@tableName}")
        .spread((results,fields)->results)
    find:(id)->
        q.ninvoke(@connection,'query',"SELECT * from #{@tableName} WHERE #{@idColumnName} = ?",[id])
        .spread((results,fields)->results[0])
    ###
    # given a list of records populate a virtual field owned by the record according to the relative id
    # @return (collection:Array<T>)=>Promise<Array<T>> returns a function
    ###
    populate:(ownedDataAccessObject,idColumnName,ownedIdColumnName,virtualColumnName)->
        (collection)->
            q(collection)
            .then((collection)->[collection,ownedDataAccessObject.findAll()])
            .spread((collection,ownedCollection)->
                _.map(collection,(item)->
                    item[virtualColumnName] = _.find(ownedCollection,(ownedItem)->item[idColumnName]==ownedItem[ownedIdColumnName])
                    item
                )
            )
    ###
    # like populate but for 1 record
    ###
    populateOne:(ownedDataAccessObject,idColumnName,virtualColumnName)->
        (record)->
            q(record)
            .then((record)->[record,ownedDataAccessObject.find(record[idColumnName])])
            .spread((record,ownedRecord)->
                record[virtualColumnName]=ownedRecord
                record
            )


class SnippetDataAccessObject extends BaseDataAccessObject
    constructor:(options,@categoryService)->
        options.tableName="snippets"
        options.idColumnName="id"
        super(options)

    _populateCategories:(snippets)->
        @populate(@categoryService,'category_id',@categoryService.idColumnName,'category')(snippets)

    _populateOneCategory:(snippet)->
        @populateOne(@categoryService,'category_id','category')(snippet)

    findAll:->
        super()
        .then(@_populateCategories.bind(this))

    find:(id)->
        super(id)
        .then(@_populateOneCategory.bind(this))

class CategoryDataAccessObject extends BaseDataAccessObject
    
    constructor:(options)->
        options.tableName="categories"
        options.idColumnName="id"
        super(options)


container = new Pimple({
    ip:process.env.OPENSHIFT_NODEJS_IP||"127.0.0.1",
    port:process.env.OPENSHIFT_NODEJS_PORT || process.env.PORT || 3000
    db:{
        host:process.env.SNIPPED_DBHOST,
        user:process.env.SNIPPED_DBUSER,
        password:process.env.SNIPPED_DBPASSWORD,
        database:process.env.SNIPPED_DBNAME
    }
})

container.set('locals',{
    title:"Snipped"
})
container.set('snippetService',container.share -> new SnippetDataAccessObject({connection:container.connection},container.categoryService))
container.set('categoryService',container.share -> new CategoryDataAccessObject({connection:container.connection}) )
container.set('connection', container.share ->
    connection = mysql.createConnection({
        host: container.db.host
        user: container.db.user
        password: container.db.password
        database: container.db.database
    })
    return connection
)

container.set('swig', container.share ->
    swig.setDefaults(cache:false)
    swig.setFilter('slug',slug)
    swig
)
container.set('app',container.share ->
    app = express()
    app.locals(container.locals)

    app.use(express.static(path.join(__dirname,"..","public")))
    app.engine('twig',container.swig.renderFile)
    app.set('view engine','twig')
    app.get('/',(req,res,next)->
        container.snippetService.findAll()
        .then((snippets)->res.render('index',{snippets}))
        .catch((err)->next(err))
    )
    app.get('/snippet/:snippetId/:snippetTitle?',(req,res,next)->
        container.snippetService.find(req.params.snippetId)
        .then((snippet)->if snippet then res.render('snippet',{snippet}) else throw "snippet with id #{req.params.snippetId} not found")
        .catch((err)->next(err))
    )
    return app
)

module.exports = container


