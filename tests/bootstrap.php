<?php
use Silex\Application;

/**
 * Bootstrap file for phpunit
 */
$autoload = require __DIR__ . "/../vendor/autoload.php";
$autoload->add("",__DIR__."/../app");
/**
 * @return Silex\Application
 */
function getApp()
{
    return new SnippetManager();
}


