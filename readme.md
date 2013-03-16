SNIPPET MANAGER
===============

author : M.Paraiso , contact mparaiso@online.frs

snippet manager help developpers write code snippets , 
with snippet managers developpers no longer have to search between several places to find how to code , 
they have a centralized repository where they can write and query bits of code, update and comment them.
snippet manager is written with the Symfony Framework.


API

    / latest snippets
    /?&orderby={favorites|latest}
    /snippet/{id} GET|POST|PUT|DELETE , format : html,json
    /snippet/{slug} GET , format: html,json
    /category/{id} GET , format: html,json
    /category/{slug} GET , format: html,json
    /user/{id} get user snippets , format: html,json