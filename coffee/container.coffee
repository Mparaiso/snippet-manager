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
bcrypt = require "bcrypt-nodejs" 
Sequelize  = require "sequelize"
flash = require "connect-flash"
redis = require 'redis'
RedisStore = require('connect-redis')(express)
container = new Pimple
    debug:if process.env.NODE_ENV is "production" then false else true,
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
        debug_mode:if process.env.NODE_ENV is "production" then false else true,
        password:process.env.SNIPPED_REDIS_PASSWORD
    },
    session:{
        ttl:1000*60*60*24
        name:"snipped"
        secret:"my secret session sentence"
    }
    name:"snipped"
container.set 'ExpressionBuilder',-> ExpressionBuilder
container.set 'redisClient',container.share (c)->
    redis.debug_mode=c.debug
    redis.createClient(c.redis.port,c.redis.host,{auth_pass:c.redis.password})
container.set 'locals',
    title:"Snipped",
    subtitle:"manage your snippets online",
    slogan:"manage your snippets online"
container.set 'form',container.share (c)-> require 'mpm.form'
container.set 'session-middleware',container.share (c)->
    if c.redis.host and c.redis.port
        return express.session
            ttl:c.session.ttl,
            name:c.session.name,
            secret:c.session.secret,
            store:new RedisStore
                client:c.redisClient
    else
        express.session(secret:c.secret,name:c.name)
container.set 'sequelize', container.share (container)->
    sequelize = new Sequelize(container.db.database,container.db.user,container.db.password,{
        host:container.db.host
        logging: if container.debug is true then console.log else false
        dialect:"mysql"
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
        tableName:"snippets"
    })
container.set 'Category',container.share (container)-> 
    Category=container.sequelize.define('Category',{
        title:Sequelize.STRING,
        description:Sequelize.STRING
    },{
        timestamps:false,
        underscored: true,
        tableName:"categories"
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
        }
    })
    User.hasMany(c.Snippet,{as:"Favorites",through:'favorites'})
    c.Snippet.hasMany(User,{as:"Fans",through:'favorites'})
    User.hasMany(c.Role,{through:'users_roles'})
    c.Role.hasMany(User,{through:'users_roles'})
    User.hasMany(c.Snippet)
    c.Snippet.belongsTo(User)

    User.hasMany(c.UserPermission)
    c.UserPermission.belongsTo(User)
    return User
### user role data access object ###
container.set 'Role',container.share (c)->
    Role = c.sequelize.define('Role',{
        name:Sequelize.STRING,
        label:Sequelize.STRING(50)
    },{
        timestamps:false,
        underscored:true,
        tableName:'roles'
    })
    Role.hasMany(c.RolePermission)
    c.RolePermission.belongsTo(Role)
    return Role
### role permissions DAO ###
container.set 'RolePermission',container.share (c)->
    RolePermission = c.sequelize.define('RolePermission',{
        permission_name:Sequelize.STRING(100)
        permission_type:Sequelize.INTEGER(1)
    },{
        timestamps:false,
        underscored:true,
        tableName:'role_permissions'
    })
### user permissions DAO ###
container.set 'UserPermission',container.share (c)->
    UserPermission = c.sequelize.define('UserPermisson',{
        permission_name:Sequelize.STRING(100)
        permission_type:Sequelize.INTEGER(1)
        user_id:Sequelize.INTEGER
    },{
        timestamps:false,
        underscored:true,
        tableName:'user_permissions'
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
container.set 'IndexController',container.share (c)->
    {
        index:(req,res,next)->
            c.SnippetService.findAll()
            .then((snippets)->res.render('index',{snippets,route:'home'}))
            .catch((err)->next(err))
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
                form = c.forms.createSnippetForm(categories)
                form.setModel(snippet)
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
            snippet=res.locals.snippet
            q().then -> 
                if req.user.hasFavoriteSync(snippet)
                    req.user.removeFavorite(snippet)
                else
                    req.user.addFavorite(snippet)
            .then ->
                res.redirect('/snippet/'+snippet.id)
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
    roles =
        user:2,
        administrator:1
    Acl = require 'acl'
    acl = new Acl(new Acl.redisBackend(c.redisClient,"acl"))
    {
        get:->
            acl.allow([roles.user],'snippet',['create','read','update','delete'])
            .then -> acl
    }
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
    mustBeAuthenticated:class mustBeAuthenticated
        constructor:(req,res,next)->
            if req.isAuthenticated() 
                next()
            else res.redirect('/signin')
    mustBeAnonymous:class mustBeAnonymous
        constructor:(req,res,next)->
            if req.isAuthenticated()
                res.redirect('/profile')
            else next()
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
    app.use(c['session-middleware'])
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
        if req.isAuthenticated()
            res.locals.user = req.user
            res.locals.isAuthenticated = true
        for key,value of c.locals
            res.locals[key]=value
        res.locals.flash = req.flash()
        next()

    ### parametric middlewares ###
    app.param "snippetId",c.params.snippetId
    app.param "categoryId",c.params.categoryId

    app.get '/snippet/:snippetId/:snippetTitle?',(req,res,next)->
        res.render('snippet')

    app.get '/category/:categoryId/:categoryTitle?',(req,res,next)->
        res.locals.category.getSnippets()
        .then (snippets)-> res.render('category',{snippets})
        .catch (err)-> next(err)

    app.all  '/join',c.UserController.register
    app.get  '/signin',[c.middlewares.mustBeAnonymous,c.UserController.signIn]
    app.post '/signin', c.passport.authenticate('local-login',{
             successRedirect:'/profile',
             failureRedirect:'/signin',
             failureFlash:true
        })

    ### subroute for profile ###
    app.use  '/profile',c.middlewares.mustBeAuthenticated
    app.use  '/profile',((r,res,next)->res.locals.route="profile";next())
    app.get  '/profile',c.UserController.profileIndex
    app.all  '/profile/snippet/create',c.UserController.profileSnippetCreate
    app.all  '/profile/snippet/:snippetId/update',c.UserController.profileSnippetUpdate
    app.post '/profile/snippet/:snippetId/delete',c.UserController.profileSnippetDelete
    app.post '/profile/snippet/:snippetId/favorite',c.UserController.profileSnippetFavoriteToggle
    app.get  '/profile/snippet',c.UserController.profileSnippet
    app.get  '/profile/favorite',c.UserController.profileFavorite
    app.get  '/profile/signout', c.UserController.signOut
    app.all  '/',c.IndexController.index
    
    return app
   
module.exports = container


