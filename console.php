<?php
/**
 * FR : Console <br/>
 * @author Mparaiso <mparaiso@online.fr>
 */
$autoload = require __DIR__."/vendor/autoload.php";
$autoload->add("",__DIR__."/app");
$autoload->add("",__DIR__."/../lib");
$app = new App(array("debug"=>TRUE));
$app->boot(); // !!!! important boot the app before using the console
$console = $app["console"];
$console->run();