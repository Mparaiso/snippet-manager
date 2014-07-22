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
bcrypt = require "bcrypt-nodejs"
Sequelize  = require "sequelize"
flash = require "connect-flash"
redis = require 'redis'
RedisStore = require('connect-redis')(express)
container = new Pimple
    debug:false#if process.env.NODE_ENV is "production" then false else true,
    secret:"Secret sentence"
    ip:process.env.OPENSHIFT_NODEJS_IP||"127.0.0.1",
    port:process.env.OPENSHIFT_NODEJS_PORT || process.env.PORT || 3000,
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
container.set 'ExpressionBuilder',-> ExpressionBuilder
container.set 'redisClient',container.share (c)->
    redis.createClient(c.redis.port,c.redis.host,{auth_pass:c.redis.password})
container.set 'locals',
    title:"Snipped",
    subtitle:"manage your snippets online",
    slogan:"manage your snippets online"
container.set 'form',container.share (c)-> require 'mpm.form'
container.set 'sessionMiddleware',container.share (c)->
    c.middlewares.redisSession()
container.set 'sequelize', container.share (container)->
    sequelize = new Sequelize(container.db.database,container.db.user,container.db.password,{
        host:container.db.host
        logging: if container.debug is true then console.log else false
        dialect:"mysql"
        #pool:if not container.debug then {maxConnections:8,maxIdleTime:30}
    })
container.set 'Snippet',container.share (container)->
    Snippet = container.sequelize.define("Snippet",{
        title:Sequelize.STRING,
        description:Sequelize.STRING,
        content:Sequelize.STRING,
        private:Sequelize.BOOLEAN,
        user_id:Sequelize.INTEGER,
        category_id:Sequelize.INTEGER,
        tags:Sequelize.STRING,
    },{
        underscored: true,
        tableName:"snippets",
        instanceMethods:{
            getResourceId:->
                "snippet"
            toString:->
                @title
        }
    })
container.set 'Category',container.share (container)-> 
    Category=container.sequelize.define('Category',{
        title:Sequelize.STRING,
        description:Sequelize.STRING
    },{
        timestamps:false,
        underscored: true,
        tableName:"categories",
        instanceMethods:{
            toString:->
                @title
        }
    })
    Category.hasMany(container.Snippet)
    container.Snippet.belongsTo(Category)
    return Category
### user data access object ###
container.set 'User', container.share (c)->
    User = c.sequelize.define('User',{
        username:Sequelize.STRING(100)
        email:Sequelize.STRING(100)
        password:Sequelize.STRING(100)
        role_id:Sequelize.INTEGER
    },{
        timestamps:false,
        underscored: true,
        tableName:"users",
        instanceMethods:{
            countSnippets:-> this.getSnippets({attributes:['id']}).then((s)->s.length )
            countFavorites:-> this.getFavorites({attributes:['id']}).then((s)->s.length )
            hasFavoriteSync:(favorite)-> this.favorites.some (f)->f.id is favorite.id
            toString:->
                this.username
            getRoleId:->
                this.role.name
        }
    })
    User.hasMany(c.Snippet,{as:"Favorites",through:'favorites'})
    c.Snippet.hasMany(User,{as:"Fans",through:'favorites'})
    c.Role.hasMany(User)
    User.belongsTo(c.Role)
    User.hasMany(c.Snippet)
    c.Snippet.belongsTo(User)
    return User
container.set 'CategoryWithSnippetCount',container.share (c)->
    c.sequelize.define('CategoryWithSnippetCount',{
        title:Sequelize.STRING,
        snippet_count:Sequelize.INTEGER,
    },{
        tableName:'categories_with_snippet_count',
        underscored:true,
        timestamps:false
    })
### user role data access object ###
container.set 'Role',container.share (c)->
    Role = c.sequelize.define('Role',{
        name:Sequelize.STRING
    },{
        timestamps:false,
        underscored:true,
        tableName:'roles',
        instanceMethods:{
            toString:->
                @name
        }
    })
container.set 'SnippetService',container.share (container)->
    {
        new:(data)->
            container.Snippet.build(data)
        persist:(snippet)->
            snippet.save()
        findAll:(where={})->
            container.Snippet.findAll({where,include:[container.Category,container.User]})
        findById:(id)->
            container.Snippet.find({where:{id:id},include:[container.Category,container.User]})
    }
container.set 'CategoryService',container.share (c)->
    {
        findAll:container.Category.findAll.bind(c.Category)
        findById:c.Category.find.bind(c.Category)
        findByIdWithSnippets:(id)->
            c.Category.find({where:{id:id},include:[{model:c.Snippet,include:[c.Category,c.User]}]})
    }
container.set 'UserService',container.share (c)->
    {
        findById:(id)->
            c.User.find({where:{id},include:[c.Role,c.Snippet,{model:c.Snippet,as:'Favorites',attributes:['id']}]})
        findByEmail:(email)->
            c.User.find({where:{email}})
        findByEmailOrUsername:(email,username)->
            c.User.find({where:Sequelize.or({email},{username})})
        create:c.User.create.bind(c.User)
        generateHash:(password)->
            bcrypt.hashSync(password,bcrypt.genSaltSync(8),null)
        validPassword:(encrypted,password)->
            bcrypt.compareSync(password,encrypted)
        new:(userData={})->
            c.User.build(userData)
        persist:(user)->
            user.save()
        register:(user)->
            @findByEmailOrUsername(user.email,user.username)
            .then (foundUser)->
                if foundUser 
                    if foundUser.email is user.email then throw "That email is already taken"
                    if foundUser.username is user.username then throw "That username is already taken"
            .then => user.password = @generateHash(user.password) ; user.save()
    }
container.set 'SearchService',container.share (c)->
    {
        indexSnippet:(snippet)->
        search:(query)->
    }
container.set 'IndexController',container.share (c)->
    {
        index:(req,res,next)->
            c.SnippetService.findAll()
            .then((snippets)->res.render('index',{snippets,route:'home'}))
            .catch((err)->next(err))
        readSnippet:(req,res,next)->
            c.SnippetService.findById(req.params.snippetId)
                .then (snippet)-> if snippet then res.render('snippet',{snippet,category:snippet.category}) else res.send(404) if not snippet
            .catch (err)->next(err)
        readCategory:(req,res,next)->
            c.CategoryService.findByIdWithSnippets(req.params.categoryId)
            .spread (category)-> res.render('category',{snippets:category.snippets,category})
            .catch (err)-> next(err)
    }
container.set 'UserController',container.share (c)->
    {
        profileIndex:(req,res,next)->
            q([req.user.countSnippets(),req.user.countFavorites()])
            .spread (snippetCount,favoriteCount)-> res.render('profile',{route:'profile',snippetCount,favoriteCount})
            .catch (err)-> next(err)
        profileSnippetDelete:(req,res,next)->
            req.user.getSnippets({where:{id:req.params.snippetId}})
            .then (snippets)->
                snippets[0].destroy()
            .then -> res.redirect('/profile')
            .catch (err)-> next(err)
        profileSnippetUpdate:(req,res,next)->
            c.CategoryService.findAll()
            .then (categories)-> [categories,req.user.getSnippets({where:{id:req.params.snippetId}})]
            .spread (categories,snippets)->
                snippet=snippets[0]
                form = c.forms.createSnippetForm(categories).setModel(snippet)
                if req.method is "POST"
                    form.bind(req.body)
                    if form.validateSync()
                        return snippet.save()
                        .then (snippet)-> res.redirect('/snippet/'+snippet.id)
                res.render('profile/snippet-update',{snippet,form})
            .catch (err)-> next(err)
        profileSnippetCreate:(req,res,next)->
            c.CategoryService.findAll()
            .then (categories)->
                snippet = c.SnippetService.new()
                form = c.forms.createSnippetForm(categories)
                form.setModel(snippet)
                if req.method is "POST"
                    form.bind(req.body)
                    if form.validateSync()
                        snippet.user_id=req.user.id
                        return snippet.save()
                        .then (snippet)-> res.redirect('/snippet/'+snippet.id)
                res.render('profile/snippet-create',{form})
            .catch (err)-> next(err)
        profileSnippet:(req,res,next)->
            req.user.getSnippets()
            .then (snippets)-> 
                snippets.forEach (s)-> s.user=req.user 
                res.render('profile/snippet-list',{pageTitle:'Your snippets',snippets})
            .catch (err)-> next(err)
        profileFavorite:(req,res,next)->
            req.user.getFavorites()
            .then (snippets)->
                snippets.forEach (s)->s.user=req.user
                res.render('profile/snippet-list',{pageTitle:'Your favorites',snippets})
            .catch (err)-> next(err)
        profileSnippetFavoriteToggle:(req,res,next)->
            c.SnippetService.findById(req.params.snippetId)
            .then (snippet)->
                if not snippet then res.send(404,"snippet with id #{req.params.snippetId} not found")
                else if req.user.hasFavoriteSync(snippet)
                    req.user.removeFavorite(snippet)
                else
                    req.user.addFavorite(snippet)
            .then ->
                res.redirect('/snippet/'+req.params.snippetId)
            .catch (err)-> next(err)
        signOut:(req,res)->
            req.logout() 
            res.redirect('/')
        signIn:(req,res,next)->
            form=c.forms.createSignInForm()
            res.render('signin',{form,route:'signin'})
        register:(req,res,next)->
            registrationForm = c.forms.createRegistrationForm()
            user = c.UserService.new()
            registrationForm.setModel(user)
            if req.method is "POST"
                registrationForm.bind(req.body)
                if registrationForm.validateSync() is true
                    return c.UserService.register(user)
                    .then (user)-> q.ninvoke req,'logIn',user,{}
                    .then -> res.redirect('/profile')
                    .catch (err)->
                        res.render('join',{form:registrationForm,err:err.message,route:'join'})
            res.render('join',{route:'join',form:registrationForm})
    }
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
container.set 'forms',container.share (c)->
    forms={}
    forms.createRegistrationForm = ->
        c.form.create('registration')
        .add('username','text',{validators:[c.form.validation.Required(),c.form.validation.Length(5,100)],attributes:{class:'form-control',required:true}})
        .add('email','email',{validators:[c.form.validation.Required(),c.form.validation.Length(6,100),c.form.validation.Email()],attributes:{class:'form-control'}})
        .add('password','repeated',{validators:[c.form.validation.Required(),c.form.validation.Length(5,50)],attributes:{type:'password',class:'form-control'}})
    forms.createSignInForm=->
        c.form.create('signin')
        .add('email','email',{attributes:{required:true,class:'form-control'},validators:[c.form.validation.Required()]})
        .add('password','password',{attributes:{required:true,class:'form-control'},validators:[c.form.validation.Required()]})
    forms.createSnippetForm=(categories)->
        c.form.create('snippet')
        .add('title','text',{validators:[c.form.validation.Required()],attributes:{class:'form-control'}})
        .add('description','textarea',{validators:[c.form.validation.Required()],attributes:{maxlength:255,rows:3,class:'form-control'}})
        .add('category_id','select',{label:'Language',choices:categories.map((cat)->{key:cat.title,value:cat.id}),validators:[c.form.validation.Required()],attributes:{class:'form-control'}})
        .add('content','textarea',{validators:[c.form.validation.Required()],attributes:{spellcheck:false,rows:10,class:'form-control'}})
    return forms
container.set 'middlewares',container.share (c)->
    aclQueryCallbackForMiddlewares =(req,res,next)->
        (err,isAllowed)->
            if isAllowed is true then next()
            else if err then next(err) else res.send(401)

    inMemorySession:->
        express.session(secret:c.secret,name:c.name)

    redisSession:->
         express.session
            ttl:c.session.ttl,
            name:c.session.name,
            secret:c.session.secret,
            store:new RedisStore
                client:c.redisClient

    queryAcl:(resource,action)->
        (req,res,next)->
            c.acl.query (req.isAuthenticated() and req.user),resource,action,aclQueryCallbackForMiddleWares(req,res,next)

    ### signin user ###
    signIn:(successRedirect='/profile',failureRedirect='/signin',failureFlash=true)->
        c.passport.authenticate 'local-login',
            successRedirect,
            failureRedirect,
            failureFlash

    ### creates a middleware that uses virgen-acl , passport, and route resource to decide url access control ###
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
        c.SnippetService.findById(id)
        .then (snippet)->
            if snippet
                res.locals.snippet = snippet
                next()
            else throw "snippet with id #{id} not found"
        .catch((err)->next(err))
    categoryId:(req,res,next,id)->
        c.CategoryService.findById(req.params.categoryId)
        .then (category)->
            if category
                res.locals.category = category
                next()
            else throw "category with id #{id} not found"
        .catch((err)-> next(err))
container.set "passport" , container.share (container)->
    passport = require "passport"
    LocalStrategy = require("passport-local").Strategy
    UserService = container.UserService 
    passport.serializeUser (user,done)->done(null,user.id)
    passport.deserializeUser (id,done)->UserService.findById(id).done(done)
    passport.use('local-login',
        new LocalStrategy({usernameField:'email',passwordField:'password',passReqToCallback:true},(req,email,password,done)->
            UserService.findByEmail(email)
            .then (user)->
                switch
                    when user and UserService.validPassword(user.password,password)
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
        SNIPPET_AFTER_CREATE:'SNIPPET_AFTER_CREATE'
    }
container.set 'app',container.share (c)->
    app = express()
    ### static assets ###
    app.use(require('less-middleware')(path.join(__dirname,'..','public')))
    app.use(express.static(path.join(__dirname,"..","public"),{maxAge:100000}))
    ### logging ###
    app.use(express.logger('dev'))
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
    app.configure('developpment',->
        app.use(express.errorHandler())
    )
    app.engine('twig',c.swig.renderFile)
    app.set('view engine','twig')
    
    app.use (req,res,next)->
        # add c.locals to res.locals
        _.defaults res.locals,c.locals
        res.locals.flash = req.flash()
        next()

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
        #console.log('categoriesWithSnippetCount')
        c.CategoryWithSnippetCount.findAll({limit:10})
        .then (categories)-> 
            #console.log("\ncategories\n",categories)
            res.locals.categoriesWithSnippetCount = categories
            next()
        .catch (err)-> next(err)

    app.get  '/snippet/:snippetId/:snippetTitle?',c.IndexController.readSnippet
    app.get  '/category/:categoryId/:categoryTitle?',c.IndexController.readCategory
    app.all  '/join'  , c.UserController.register
    app.get  '/signin', c.UserController.signIn
    app.post '/signin', c.middlewares.signIn()
    app.get  '/', c.IndexController.index
    return app
container.set 'events',container.share (c)->
    {
        'BEFORE_SNIPPET_CREATE',
        'AFTER_SNIPPET_CREATE',
    }
container.set 'qevent',container.share (c)->
    new c.EventEmitter(q)

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
                @_Q.when(true)
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
module.exports = container