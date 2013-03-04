<?php

$autoload = require(__DIR__."/../vendor/autoload.php");

$autoload->add("",__DIR__."/../app/");


$app = new SnippetManager(array("debug"=>true));

$app["http_cache"]->run();
