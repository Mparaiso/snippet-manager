Pimple = require "pimple"
express = require "express"
mysql = require "mysql"
q = require "q"
path = require "path"
swig = require "swig"

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

class SnippetDataAccessObject extends BaseDataAccessObject
    constructor:(options)->
        options.tableName="snippets"
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
container.set('snippetService',container.share -> new SnippetDataAccessObject({connection:container.connection}))

container.set('CategoryService',container.share -> class CategoryService )
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


