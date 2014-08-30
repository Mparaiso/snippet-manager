###
    coffee/controller.coffee
    Copyright © 2014 mparaiso <mparaiso@online.fr>. All Rights Reserved.
###

###
    controller service provider
###
module.exports=(c)->

    c.set 'IndexController',c.share (c)->
        index:(req,res,next)->
            offset = if +req.query.offset > 0 then +req.query.offset * c.snippet_per_page else 0
            c.Snippet.listAll(undefined,c.snippet_per_page,offset)
            .then((snippets)->res.render('index',{offset:+req.query.offset||0,snippets,item_per_page:c.snippet_per_page,item_count:snippets.length,route:'home'}))
            .catch next
        readSnippet:(req,res,next)->
            c.Snippet.findById(req.params.snippetId)
            .then (snippet)-> if snippet then res.render('snippet',{snippet,category:snippet.category}) else res.send(404) if not snippet
            .catch (err)->next(err)
        readCategory:(req,res,next)->
            offset = if +req.query.offset > 0 then ( +req.query.offset * c.snippet_per_page ) else 0
            c.Category.findByIdWithSnippets(req.params.categoryId,c.snippet_per_page,offset)
            .then (category)-> res.render('category',{offset:+req.query.offset||0,item_per_page:c.snippet_per_page,item_count:category.snippets.length, snippets:category.snippets,category})
            .catch next
        search:(req,res,next)->
            query = req.query.q
            offset = if isNaN(+req.query.offset) then 0 else +req.query.offset
            limit = c.snippet_per_page
            c.Search.search(query,null,limit,offset*limit)
            .then (snippets)-> res.render('search',{snippets,q:query,offset,item_per_page:limit,item_count:snippets.length})
            .catch next

    c.set 'UserController',c.share (c)->
        profileIndex:(req,res,next)->
            c.q([req.user.countSnippets(),req.user.countFavorites(),req.user.getLatestSnippets()])
            .spread (snippetCount,favoriteCount,latestSnippets)-> res.render('profile',{route:'profile',snippetCount,favoriteCount,latestSnippets})
            .catch next
        profileSnippetDelete:(req,res,next)->
            req.user.getSnippets({where:{id:req.params.snippetId}})
            .then (snippets)->
                    snippets[0].destroy()
            .then -> res.redirect('/profile')
            .catch next
        profileSnippetUpdate:(req,res,next)->
            c.Category.findAll()
            .then (categories)-> 
                [categories,req.user.getSnippets({include:[c.Category],where:{'snippets.id':req.params.snippetId}})]
            .spread (categories,snippets)->
                snippet=snippets[0]
                form = c.forms.createSnippetForm(categories).setModel(snippet)
                if req.method is "POST" and form.bind(req.body) and form.validateSync()
                    return snippet.save()
                    .then -> res.redirect('/snippet/'+snippet.id)
                res.render('profile/snippet-update',{snippet,form})
            .catch next
            
        # GET /profile/snippet/create
        profileSnippetCreate:(req,res,next)->
            c.Category.findAll()
            .then (categories)->
                snippet = c.Snippet.new()
                form = c.forms.createSnippetForm(categories)
                form.setModel(snippet)
                if req.method is "POST" and form.bind(req.body) and form.validateSync()
                    snippet.user_id=req.user.id
                    return snippet.save()
                    .then (snippet)-> res.redirect('/snippet/'+snippet.id)
                res.render('profile/snippet-create',{form})
            .catch next
        
        # GET /profile/snippet
        profileSnippet:(req,res,next)->
            req.user.getSnippets({order:[['created_at','DESC']],include:[c.Category]})
            .then (snippets)->
                snippets.forEach (s)-> s.user=req.user
                res.render('profile/snippets',{pageTitle:'Your snippets',snippets})
            .catch (err)-> next(err)
            
        # GET /profile/favorite
        profileFavorite:(req,res,next)->
            c.q.all [req.user.getFavorites({order:[['favorites.created_at','DESC']]}),c.Category.findAll()]
            .spread (snippets,categories)->
                snippets.forEach (s)->s.user=req.user;s.category = categories.filter((c)->c.id == s.category_id)[0];
                res.render('profile/favorite',{pageTitle:'Your favorites',snippets})
            .catch (err)-> next(err)
            
        profileSnippetFavoriteToggle:(req,res,next)->
            c.Snippet.findById(req.params.snippetId)
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
            user = c.User.new()
            registrationForm.setModel(user)
            if req.method is "POST" and registrationForm.bind(req.body) and registrationForm.validateSync() is true
                return c.User.register(user)
                .then (user)-> c.q.ninvoke req,'logIn',user,{}
                .then -> res.redirect('/profile')
                .catch (err)->
                    console.log(err)
                    res.render('join',{form:registrationForm,error:err.message,route:'join'})
            res.render('join',{route:'join',form:registrationForm})

    c.set 'ErrorController',c.share (c)->
        '500':(err,req,res,next)->
            errorMessage = switch err.status
                when 404
                    res.status(404)
                    "Page Not Found"
                else
                    res.status(500)
                    "Server error"
            console.log(err)
            res.render('500.twig',{errorMessage})

    c.set 'AdminController',c.share (c)->
        ###
            Admin actions
        ###
