###
    coffee/controller.coffee
    Copyright © 2014 mparaiso <mparaiso@online.fr>. All Rights Reserved.
###

q = require "q"
_ = require "lodash"
###
    controller service provider
###
module.exports=(c)->
    c.set 'IndexController',c.share (c)->
        {
        index:(req,res,next)->
            offset = if +req.query.offset > 0 then +req.query.offset * c.snippet_per_page else 0
            c.Snippet.listAll(undefined,c.snippet_per_page,offset)
            .then((snippets)->res.render('index',{offset:+req.query.offset||0,snippets,item_per_page:c.snippet_per_page,item_count:snippets.length,route:'home'}))
            .catch((err)->next(err))
        readSnippet:(req,res,next)->
            c.Snippet.findById(req.params.snippetId)
            .then (snippet)-> if snippet then res.render('snippet',{snippet,category:snippet.category}) else res.send(404) if not snippet
            .catch (err)->next(err)
        readCategory:(req,res,next)->
            offset = if +req.query.offset > 0 then ( +req.query.offset * c.snippet_per_page ) else 0
            c.Category.findByIdWithSnippets(req.params.categoryId,c.snippet_per_page,offset)
            .then (category)-> res.render('category',{offset:+req.query.offset||0,item_per_page:c.snippet_per_page,item_count:category.snippets.length, snippets:category.snippets,category})
            .catch (err)-> next(err)
        }
    c.set 'UserController',c.share (c)->
        {
        profileIndex:(req,res,next)->
            q([req.user.countSnippets(),req.user.countFavorites(),req.user.getLatestSnippets()])
            .spread (snippetCount,favoriteCount,latestSnippets)-> res.render('profile',{route:'profile',snippetCount,favoriteCount,latestSnippets})
                .catch (err)-> next(err)
        profileSnippetDelete:(req,res,next)->
            req.user.getSnippets({where:{id:req.params.snippetId}})
            .then (snippets)->
                    snippets[0].destroy()
            .then -> res.redirect('/profile')
                .catch (err)-> next(err)
        profileSnippetUpdate:(req,res,next)->
            c.Category.findAll()
            .then (categories)-> [categories,req.user.getSnippets({where:{id:req.params.snippetId}})]
                .spread (categories,snippets)->
                        snippet=snippets[0]
                        form = c.forms.createSnippetForm(categories).setModel(snippet)
                        if req.method is "POST"
                            form.bind(req.body)
                            if form.validateSync()
                                return c.qevent.emit(c.events.SNIPPET_BEFORE_UPDATE,snippet,req,res,next)
                                .then snippet.save.bind(snippet,null)
                                .then c.qevent.emit.bind(c.qevent,c.events.SNIPPET_AFTER_UPDATE,snippet,req,res,next)
                                .then -> res.redirect('/snippet/'+snippet.id)
                        res.render('profile/snippet-update',{snippet,form})
                .catch (err)-> next(err)
        profileSnippetCreate:(req,res,next)->
            c.Category.findAll()
            .then (categories)->
                    snippet = c.Snippet.new()
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
            if req.method is "POST"
                registrationForm.bind(req.body)
                if registrationForm.validateSync() is true
                    return c.User.register(user)
                    .then (user)-> q.ninvoke req,'logIn',user,{}
                        .then -> res.redirect('/profile')
                            .catch (err)->
                                    res.render('join',{form:registrationForm,err:err.message,route:'join'})
            res.render('join',{route:'join',form:registrationForm})
        }
