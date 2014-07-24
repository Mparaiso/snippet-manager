###*
# Copyright © 2014 mparaiso <mparaiso@online.fr>. All Rights Reserved.
# Snipped , manage your snippets online
###
### IoC container ###
Pimple = require "pimple"
express = require "express"
mysql = require "mysql"
q = require "q"
path = require "path"
swig = require "swig"
slug = require "slug"
_ = require "lodash"
util = require "util"

flash = require "connect-flash"
redis = require 'redis'
RedisStore = require('connect-redis')(express)
container = new Pimple
    debug:if process.env.NODE_ENV is "production" then false else true,
    secret:"Secret sentence"
    ip:process.env.OPENSHIFT_NODEJS_IP||"127.0.0.1",
    port:process.env.OPENSHIFT_NODEJS_PORT || process.env.PORT || 3000,
    google_analytics_id:"",
    db:{
        host:process.env.SNIPPED_DBHOST,
        user:process.env.SNIPPED_DBUSER,
        password:process.env.SNIPPED_DBPASSWORD,
        database:process.env.SNIPPED_DBNAME
    },
    redis:{
        port:process.env.SNIPPED_REDIS_PORT,
        host:process.env.SNIPPED_REDIS_HOST,
        debug_mode:false #if process.env.NODE_ENV is "production" then false else true,
        password:process.env.SNIPPED_REDIS_PASSWORD
    },
    session:{
        ttl:1000*60*60*24
        name:"snipped"
        secret:"my secret session sentence"
    },
    elasticSearch:{
        url:process.env.SNIPPED_ELASTIC_SEARCH_URL
    }
    name:"snipped"
    snippet_per_page:20
    category_per_page:10
container.set '_',-> _
container.set 'q',-> q
container.set 'redisClient',container.share (c)->
    redis.createClient(c.redis.port,c.redis.host,{auth_pass:c.redis.password})
container.set 'locals',
    title:"Snipped",
    subtitle:"manage your snippets online",
    slogan:"manage your snippets online"
container.set 'form',container.share (c)-> require 'mpm.form'
container.set 'sessionMiddleware',container.share (c)->
    session = c.middlewares.redisSession()
    return session
container.set 'acl',container.share (c)->
    Acl = require('virgen-acl').Acl
    acl = new Acl
    ### set up roles ###
    acl.addRole("member")
    acl.addRole('administrator','member')
    # set up resource
    acl.addResource('snippet')
    acl.addResource('route')
    acl.deny()
    acl.allow('administrator')
    acl.allow('member','snippet',['create','update','delete'])
    acl.allow(null,'snippet',['list','read'])
    acl.allow('member','route',['/profile',
        '/profile/snippet',
        '/profile/signout',
        '/profile/favorite',
        '/profile/snippet/create',
        '/profile/snippet/:snippetId/update',
        '/profile/snippet/:snippetId/delete',
        '/profile/snippet/:snippetId/favorite'
    ])
    acl.allow(null,'route',['/','/*','/snippet',
        '/snippet/:snippetId/:snippetTitle?',
        '/category/:categoryId/:categoryTitle?',
        '/join',
        '/signin'
    ])
    acl.deny('member','route',['/signin','/join'])
    acl.pquery = -> q.ninvoke(acl,'query',arguments...)
    return acl
container.set 'swig', container.share ->
    swig.setDefaults(cache:if container.debug then false else "memory")
    swig.setFilter('slug',slug)
    swig
###
    middlewares
###
container.set 'middlewares',container.share (c)->
    aclQueryCallbackForMiddlewares =(req,res,next)->
        (err,isAllowed)->
            if isAllowed is true then next()
            else if err then next(err) else res.send(401)
    ###
        session stored in memory
    ###
    inMemorySession:->
        express.session(secret:c.secret,name:c.name)
    ###
        session stored in redis
    ###
    redisSession:->
         express.session
            ttl:c.session.ttl,
            name:c.session.name,
            secret:c.session.secret,
            store:new RedisStore
                client:c.redisClient
    ###
        query acl for authorization
    ###
    queryAcl:(resource,action)->
        (req,res,next)->
            c.acl.query (req.isAuthenticated() and req.user),resource,action,aclQueryCallbackForMiddleWares(req,res,next)

    ###
        signin user with passport
    ###
    signIn:(successRedirect='/profile',failureRedirect='/signin',failureFlash=true)->
        c.passport.authenticate 'local-login',{
                successRedirect,
                failureRedirect,
                failureFlash
            }
    ###
        creates a middleware that uses virgen-acl , passport, and route resource to decide url access control
    ###
    firewall:(acl,strict=true)->
        routes=undefined
        findRoute = _.memoize((url)->_(routes).find((route)->route.regexp.test(url)))
        return (req,res,next)->
                routes?= _(req.app.routes).values().flatten(true).value()
                route = findRoute(req.url)
                if route 
                    return acl.query(req.isAuthenticated() and req.user?.getRoleId(),'route',route.path,(err,isAllowed)->
                        if err then next(err)
                        else if not isAllowed then res.send(401,"user #{req.user} with role #{req.user?.getRoleId()} is not allowed on route #{route.path}")
                        else next()
                    )
                else if strict then res.send(404,'route not found with strict firewall') else next()
container.set 'params',container.share (c)->
    snippetId:(req,res,next,id)->
        c.Snippet.findById(id)
        .then (snippet)->
            if snippet
                res.locals.snippet = snippet
                next()
            else throw "snippet with id #{id} not found"
        .catch((err)->next(err))
    categoryId:(req,res,next,id)->
        c.Category.findById(req.params.categoryId)
        .then (category)->
            if category
                res.locals.category = category
                next()
            else throw "category with id #{id} not found"
        .catch((err)-> next(err))
container.set "passport" , container.share (container)->
    passport = require "passport"
    LocalStrategy = require("passport-local").Strategy
    passport.serializeUser (user,done)->done(null,user.id)
    passport.deserializeUser (id,done)->container.User.findById(id).done(done)
    passport.use('local-login',
        new LocalStrategy({usernameField:'email',passwordField:'password',passReqToCallback:true},(req,email,password,done)->
            container.User.findByEmail(email)
            .then (user)->
                switch
                    when user and container.User.validPassword(user.password,password)
                        ### register user in acl ###
                        user
                    else
                        req.flash('danger',"Invalid credentials")
                        return false
            .catch((err)->done(err))
            .then((user)->done(null,user))
    ))
    return passport
container.set "events",container.share (container)->
    {
        ### Promise<snippet> , container , req , res, next ###
        'SNIPPET_AFTER_CREATE'
    }
###
    Express app configuration
###
container.set 'app',container.share (c)->
    app = express()
    ### static assets ###
    app.disable 'x-powered-by'
    app.use('/css',require('less-middleware')(path.join(__dirname,'..','public','css')))
    app.use(express.static(path.join(__dirname,"..","public"),{maxAge:100000}))
    ### logging ###
    ### passport user management ###
    app.use(express.cookieParser(c.secret))
    ### session middleware ###
    app.use(c.sessionMiddleware)
    app.use(flash())
    app.use(c.passport.initialize())
    app.use(c.passport.session())
    # forms
    app.use(express.bodyParser())
    app.use(express.methodOverride())
    #
    app.engine('twig',c.swig.renderFile)
    app.set('view engine','twig')

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
        c.CategoryWithSnippetCount.findAll({limit:10})
        .then (categories)-> 
            res.locals.categoriesWithSnippetCount = categories
            next('route')
        .catch next

    app.get  '/snippet/:snippetId/:snippetTitle?',c.IndexController.readSnippet
    app.get  '/category/:categoryId/:categoryTitle?',c.IndexController.readCategory
    app.all  '/join'  , c.UserController.register
    app.get  '/signin', c.UserController.signIn
    app.post '/signin', c.middlewares.signIn()
    app.get  '/', c.IndexController.index
    app.all  '/*',(req,res,next)-> err  = new Error('not found') ; err.status=404 ; next(err)
    # custom error page
    if not c.debug then  app.use  c.ErrorController['500']




    return app
container.set 'qevent',container.share (c)->
    qevent = new c.EventEmitter(c.q)
    return qevent
container.set 'EventEmitter',container.share (c)->
    class EventEmitter
        constructor:(@_Q,@_eventList=[])->

        on:(event, listener)->
            if typeof event is "string"
                event = { name: event, listener: listener ,priority:0}
            @_eventList.push(event);

        off:(eventName, listener)->
            @_eventList.filter (el)-> if el.name == eventName and listener then el.listener == listener else true
            .forEach (el)=> @_eventList.splice(@_eventList.indexOf(el), 1)
            return this

        emit:(eventName,args...)->
            @_eventList.filter  (e)-> e.name is eventName;
            .sort (a, b)-> b.priority - a.priority;
            .reduce(
                ((q, next)-> q.then(next.listener.bind(next.listener, args...))),
                @_Q()
            )

        once:(eventName, listener)->
            if typeof eventName != "string"
                _evName = eventName.name
            else
                _evName = eventName
            _listener = =>
                @off(eventName, listener)
                listener(arguments...)
            @on(eventName, _listener)

        has:(eventName, listener)->
            @._eventList.some  (event)-> event.name == eventName && event.listener == listener
container.register require('./model')
container.register require('./controller')
container.register require('./event')
container.register require('./form')
module.exports = container

