###*
# Copyright © 2014 mparaiso <mparaiso@online.fr>. All Rights Reserved.
# Snipped , manage your snippets online
###
module.exports = (c)->
    ###
         EVENT HANDLERS
    ###
    c.set 'events',c.share (c)->
        events = {
            'SNIPPET_EDIT'
            'SNIPPET_BEFORE_UPDATE',
            'SNIPPET_AFTER_UPDATE',
        }
        ### testing a few events ###
        c.qevent.on events.SNIPPET_BEFORE_UPDATE,(snippet,req,res)->
            console.log('snippet before update %s with id %s',snippet,snippet.id)
        c.qevent.on events.SNIPPET_AFTER_UPDATE,(snippet)->
            console.log('snippet after update %s with id %s',snippet,snippet.id)
        return events

