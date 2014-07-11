Pimple = require "pimple"
express = require "express"
mysql = require "mysql"
q = require "q"
path = require "path"
swig = require "swig"
container = new Pimple({
    ip:process.env.OPENSHIFT_NODEJS_IP||"127.0.0.1",
    port:process.env.OPENSHIFT_NODEJS_PORT || process.env.PORT || 3000
})

container.set('Snippet',container.share -> class Snippet )
container.set('Category',container.share -> class Category )
container.set('SnippetService',container.share -> class SnippetService )
container.set('CategoryService',container.share -> class CategoryService )
container.set('connexion', container.share -> )
container.set('swig', container.share -> 
    swig.setDefaults(cache:false)
    swig  
)
container.set('app',container.share ->
    app = express()
    app.use(express.static(path.join(__dirname,"..","public")))
    app.engine('twig',container.swig.renderFile)
    app.set('view engine','twig')
    app.get('/',(req,res)->
        res.render('index',message:"Hello World!",title:"Snippet")
    )
    return app
)

module.exports = container


