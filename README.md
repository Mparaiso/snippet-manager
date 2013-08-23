SimpleRest Service Provider DEMO
================================

author: Mparaiso <mparaiso@online.fr>

# SET UP

server variables :

+ SIMPLE_REST_ENV: development or production
+ SIMPLE_REST_DBNAME: database name
+ SIMPLE_REST_USER: database user
+ SIMPLE_REST_PASSWORD :database passord
+ SIMPE_REST_HOST : localhost ( optional)
+ SIMPE_REST_DRIVER : pdo driver ( pdo_mysql , etc ... )
+ SIMPLE_REST_PORT: db port

## WEB SERVER CONFIGURATION

### with PHP builtin server :

launch the app that way

in the web folder : 

	php -S localhost:3000 index.php

index.php is the server router so you need to add it to the command line when launching the PHP server.


## DEV ( in french sorry )

SPRINTs

1 Inclure un snippet dans une page tierce.

+ [x] un snippet peut être inclu dans une page tierce via une iframe.
+ [x] le code de l'iframe peut être récupéré dans la page de consultation du snippet.