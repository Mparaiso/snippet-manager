<?php
use Silex\Application;

$autoload = require(__DIR__ . "/../vendor/autoload.php");
$autoload->add("", __DIR__ . "/../app/");
$app           = new SnippetManager(array("debug" => TRUE));
$app["loader"] = $autoload;

$app["http_cache"]->run();
