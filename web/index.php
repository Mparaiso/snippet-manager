<?php
/**
 * SimpleRest Demo application
 * @author Mparaiso <mparaiso@online.fr>
 */

$filename = __DIR__ . preg_replace('#(\?.*)$#', '', $_SERVER['REQUEST_URI']);
if (php_sapi_name() === 'cli-server' && is_file($filename)) {
    return FALSE;
}

$autoload = require __DIR__ . "/../vendor/autoload.php";

$autoload->add("", __DIR__ . "/../app");
$autoload->add("", __DIR__ . "/../../lib");

$debug = getenv("SIMPE_REST_ENV") == "development" ? TRUE : FALSE;
$app = new App(array("debug" => $debug));

$app->run();