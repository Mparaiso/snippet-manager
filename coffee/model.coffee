###
    coffee/model.coffee
    Copyright © 2014 mparaiso <mparaiso@online.fr>. All Rights Reserved.
###
bcrypt = require 'bcrypt-nodejs'
Sequelize  = require 'sequelize'

module.exports = (c)->
    {_,q} = c

    c.set 'sequelize', c.share (c)->
        sequelize = new Sequelize(c.db.database,c.db.user,c.db.password,{
            host:c.db.host
            logging: if c.debug is true then console.log else false
            dialect:c.db.dialect
            syncOnAssociation:false,
            pool: { maxConnections: 2, maxIdleTime: 30},
        })
    c.set 'Snippet',c.share (c)->
        Snippet = c.sequelize.define("Snippet",{
            title:Sequelize.STRING,
            description:Sequelize.STRING,
            content:Sequelize.STRING,
            private:Sequelize.BOOLEAN,
            user_id:Sequelize.INTEGER,
            category_id:Sequelize.INTEGER,
            tags:Sequelize.STRING,
        },{
            underscored: true,
            tableName:'snippets',
            instanceMethods:{
                getResourceId:->
                    "snippet"
                toString:->
                    @title
            },
            classMethods:{
                new:(data)->
                    this.build(data)
                persist:(snippet)->
                    snippet.save()
                listAll:(options={},limit,offset=0)->
                    c._.defaults(options,{order:[['created_at','DESC']],where:{},include:[c.Category,c.User],attributes:['id','title','description','category_id','user_id','created_at']})
                    options.offset = offset
                    if limit then options.limit=limit
                    this.findAll(options)
                findById:(id)->
                    this.find({where:{id:id},include:[c.Category,c.User]})
            }
        })
    c.set 'Category',c.share (c)->
        Category=c.sequelize.define('Category',{
            title:Sequelize.STRING,
            description:Sequelize.STRING
        },{
            timestamps:false,
            underscored: true,
            tableName:"categories",
            instanceMethods:{
                toString:->
                    @title
            },
            classMethods:{
                findByIdWithSnippets:(id,limit,offset)->
                    this.find({where:{id}})
                    .then (category)-> if not category then throw "category not found" else [category,category.getSnippets({attributes:['id','title','description','created_at'],include:[c.Category,c.User],limit,offset, order:[['created_at','DESC']]})]
                    .spread (category,snippets)-> category.snippets = snippets ; return category
            }
        })
        Category.hasMany(c.Snippet)
        c.Snippet.belongsTo(Category)
        return Category
    ### user data access object ###
    c.set 'User', c.share (c)->
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
                countSnippets:-> @getSnippets({attributes:['id']}).then((s)->s.length )
                countFavorites:-> @getFavorites({attributes:['id']}).then((s)->s.length )
                hasFavoriteSync:(favorite)-> @favorites.some (f)->f.id is favorite.id
                toString:->
                    @username
                getRoleId:->
                    @role.name
                getLatestSnippets:(limit=5)->
                    @getSnippets(
                        limit:limit,order:[['created_at','DESC']],
                        attributes:['id','title','description','created_at'],
                        include:[{model:c.User,attributes:['id','username']},{model:c.Category,attributes:['id','title']}]
                    )
            },
            classMethods:{
                findById:(id)->
                    c.User.find({where:{id},include:[{model:c.Role,attributes:['name','id']},{model:c.Snippet ,attributes:['id']},{model:c.Snippet,as:'Favorites',attributes:['id']}]})
                findByEmail:(email)->
                    c.User.find({where:{email}})
                findByEmailOrUsername:(email,username)->
                    c.User.find({where:Sequelize.or({email},{username})})
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
                                if foundUser.email is user.email then throw new Error("That email is already taken")
                                if foundUser.username is user.username then throw new Error("That username is already taken")
                    .then => user.password = @generateHash(user.password) ; user.save()
            }
        })
        User.hasMany(c.Snippet,{as:"Favorites",through:'favorites'})
        c.Snippet.hasMany(User,{as:"Fans",through:'favorites'})
        c.Role.hasMany(User)
        User.belongsTo(c.Role)
        User.hasMany(c.Snippet)
        c.Snippet.belongsTo(User)
        return User
    c.set 'CategoryWithSnippetCount',c.share (c)->
        c.sequelize.define('CategoryWithSnippetCount',{
            title:Sequelize.STRING,
            snippet_count:Sequelize.INTEGER,
        },{
            tableName:'categories_with_snippet_count',
            underscored:true,
            timestamps:false
        })
    ### user role data access object ###
    c.set 'Role',c.share (c)->
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
    c.set 'Search',c.share (c)->

            indexSnippet:(snippet)-> throw "not implemented yet"

            search:(query,order=[['created_at',"DESC"]],limit= c.snippet_per_page,offset=0)->
                request = {
                    order,limit,offset,
                    where:['snippets.title like ? or snippets.description like ? or snippets.content like ? or category.title LIKE ? ',"%#{query}%","%#{query}%","%#{query}%","%#{query}%"],
                    include:[c.Category]
                }
                c.Snippet.findAll(request)
