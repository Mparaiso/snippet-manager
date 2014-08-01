###*
# Copyright © 2014 mparaiso <mparaiso@online.fr>. All Rights Reserved.
# Snipped , manage your snippets online
###
module.exports = (container)->
    container.set 'app',container.share (c)->
        {_,q,path,express} = c

        app = express()
        ### static assets ###
        app.disable 'x-powered-by'
        app.use('/css',require('less-middleware')(path.join(__dirname,'..','public','css'),{once:if c.debug then false else true}))
        app.use(express.static(path.join(__dirname,"..","public"),{maxAge:100000}))
        ### logging ###
        ### passport user management ###
        app.use(express.cookieParser(c.secret))
        ### session middleware ###
        app.use(c.sessionMiddleware)
        app.use(c.flash())
        app.use(c.passport.initialize())
        app.use(c.passport.session())
        # forms
        app.use(express.bodyParser())
        app.use(express.methodOverride())
        #
        app.engine('twig',c.swig.renderFile)
        app.set('view engine','twig')

        #app.use require('compression')()
        app.use (req,res,next)->
            # add c.locals to res.locals
            _.defaults res.locals,c.locals
            res.locals.flash = req.flash()
            next()
        ### errors ###
        if c.debug
            app.enable('verbose errors')
            app.use(express.errorHandler())
            app.use(express.logger('dev'))
        else
            app.disable('verbose errors')
            app.disable('view cache')

        app.use (req,res,next)->
            # add user and isAuthenticated to locals if req.isAuthenticated()
            if req.isAuthenticated()
                res.locals.user = req.user
                res.locals.isAuthenticated = true
            else
                res.locals.user= undefined
                res.locals.isAuthenticated = false
            next()
        ### firewall ###
        app.use c.middlewares.firewall(c.acl)

        ### subroute for profile ###
        app.use  '/profile',((r,res,next)->res.locals.route="profile";next())
        app.get  '/profile',c.UserController.profileIndex
        app.all  '/profile/snippet/create',c.UserController.profileSnippetCreate
        app.all  '/profile/snippet/:snippetId/update',c.UserController.profileSnippetUpdate
        app.post '/profile/snippet/:snippetId/delete',c.UserController.profileSnippetDelete
        app.post '/profile/snippet/:snippetId/favorite',c.UserController.profileSnippetFavoriteToggle
        app.get  '/profile/snippet',c.UserController.profileSnippet
        app.get  '/profile/favorite',c.UserController.profileFavorite
        app.get  '/profile/signout', c.UserController.signOut

        ### public routes ###
        app.get '/*',(req,res,next)->
            c.CategoryWithSnippetCount.findAll({limit:12})
            .then (categories)->
                    res.locals.categoriesWithSnippetCount = categories
                    next('route')
            .catch next

        app.get  '/snippet/:snippetId/:snippetTitle?',c.IndexController.readSnippet
        app.get  '/category/:categoryId/:categoryTitle?',c.IndexController.readCategory
        app.get  '/search',c.IndexController.search
        app.all  '/join'  , c.UserController.register
        app.get  '/signin', c.UserController.signIn
        app.post '/signin', c.middlewares.signIn()
        app.get  '/', c.IndexController.index
        app.all  '/*',(req,res,next)-> err  = new Error('not found') ; err.status=404 ; next(err)
        # custom error page
        if not c.debug then  app.use  c.ErrorController['500']




        return app