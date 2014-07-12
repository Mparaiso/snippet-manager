###*
# Copyright © 2014 mparaiso <mparaiso@online.fr>. All Rights Reserved.
# Snipped , manage your snippets online
###
Pimple = require "pimple"
express = require "express"
mysql = require "mysql"
q = require "q"
path = require "path"
swig = require "swig"
slug = require "slug"
_ = require "lodash"
util = require "util"
{ExpressionBuilder,QueryBuilder,BaseDataAccessObject} = require "./dbal"

class UserRoleDataAccessObject extends BaseDataAccessObject
    constructor:(options)->
        options.tableName="user_roles"
        options.idColumnName="id"
        super(options)

class RoleDataAccessObject extends BaseDataAccessObject
    constructor:(options)->
        options.tableName="roles"
        options.idColumnName="id"
        super(options)

class UserDataAccessObject extends BaseDataAccessObject
    constructor:(options)->
        options.tableName="users"
        options.idColumnName="id"
        super(options)

class SnippetDataAccessObject extends BaseDataAccessObject
    constructor:(options,@categoryService,@userService)->
        options.tableName="snippets"
        options.idColumnName="id"
        super(options)

    _populateCategories:(snippets)->
        @populate(@categoryService,'category_id',@categoryService.idColumnName,'category')(snippets)

    _populateOneCategory:(snippet)->
        @populateOne(@categoryService,'category_id','category')(snippet)

    _populateUsers:(snippets)->
        @populate(@userService,'user_id',@userService.idColumnName,'user')(snippets)

    _populateOneUser:(snippet)->
        @populateOne(@userService,'user_id','user')(snippet)

    findAll:->
        super()
        .then(@_populateCategories.bind(this))
        .then(@_populateUsers.bind(this))

    find:(id)->
        super(id)
        .then(@_populateOneCategory.bind(this))
        .then(@_populateOneUser.bind(this))

class CategoryDataAccessObject extends BaseDataAccessObject
    
    constructor:(options)->
        options.tableName="categories"
        options.idColumnName="id"
        super(options)


container = new Pimple({
    debug:if process.env.NODE_ENV is "production" then false else true,
    ip:process.env.OPENSHIFT_NODEJS_IP||"127.0.0.1",
    port:process.env.OPENSHIFT_NODEJS_PORT || process.env.PORT || 3000,
    db:{
        host:process.env.SNIPPED_DBHOST,
        user:process.env.SNIPPED_DBUSER,
        password:process.env.SNIPPED_DBPASSWORD,
        database:process.env.SNIPPED_DBNAME
    }
})
container.set('ExpressionBuilder',-> ExpressionBuilder )
container.set('locals',{
    title:"Snipped"
})
container.set('snippetService',container.share -> new SnippetDataAccessObject(connection:container.connection,container.categoryService,container.userService))
container.set('categoryService',container.share -> new CategoryDataAccessObject(connection:container.connection) )
container.set('userService',container.share -> new UserDataAccessObject(connection:container.connection))
container.set('connection', container.share ->
    connection = mysql.createConnection({
        host: container.db.host
        user: container.db.user
        password: container.db.password
        database: container.db.database
        debug:if container.debug then true else false
    })
    return connection
)

container.set('swig', container.share ->
    swig.setDefaults(cache:if container.debug then false else "memory")
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
    app.get('/category/:categoryId/:categoryTitle?',(req,res,next)->
        container.categoryService.find(req.params.categoryId)
        .then((category)->[category,container.snippetService.findBy({category_id:category.id})])
        .spread((category,snippets)-> res.render('category',{category,snippets}))
        .catch((err)-> next(err))
    )
    return app
)

module.exports = container


