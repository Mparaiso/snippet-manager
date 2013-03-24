SNIPPET MANAGER
===============

[![Build Status](https://travis-ci.org/Mparaiso/silex-snippetmanager.png?branch=master)](https://travis-ci.org/Mparaiso/silex-snippetmanager)

author : M.Paraiso , contact mparaiso@online.fr

status : **WORK IN PROGRESS**



license: GPL

snippet manager help developpers write code snippets , 
with snippet managers developpers no longer have to search between several places to find how to code , 
they have a centralized repository where they can write and query bits of code, update and comment them.
snippet manager is written with the Symfony Framework.

#### Features

    + Snippet management
        + create ,delete , update , display snippets
    + Category management
        + create ,delete , update, display categories
    + User management
        + signin
        + register new users
    + Role management
        + Admins can admin site
        + Users can create and edit their snippets
    + Syndication
        + feed generation per category or for all snippets


### LIVE DEMO : http://silex-dsnippet.herokuapp.com/

Why ?

+ Helps learn Silex
+ Helps learn Doctrine ORM
+ Helps learn Symfony
+ Helps learn how to integrate Symfony project libs with Silex

tools and tech:

+ Symfony
+ Silex
+ Doctrine ORM
+ Mysql
+ Apache Server

todo :

+ write all the tests
+ fix bugs
+ write docs
+ clean up code

### INSTALLATION

requirements :

+ a web server ( apache , ... )
+ PHP >= 5.3
+ Composer http://getcomposer.org/
+ a database ( MYSQL , ... )

Server variables :
Define these variables at the system level ( use SETX on windows for instance )

+ SNIPPETMANAGER_DBNAME : the name of the database
+ SNIPPETMANAGER_ENV : development (to enable debug mode ) or anything
+ SNIPPETMANAGER_HOST : database host server ( ex : localhost )
+ SNIPPETMANAGER_PASSWORD : database password
+ SNIPPETMANAGER_USER : database username