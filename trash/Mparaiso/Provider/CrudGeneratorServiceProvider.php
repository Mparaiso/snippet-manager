<?php

namespace Mparaiso\Provider;

use Silex\Application;
use Silex\ServiceProviderInterface;

/**
 * FR : fournit des outils pour la génération de crud
 * EN : provide tools for crud generation
 */
class CrudGeneratorServiceProvider implements ServiceProviderInterface
{

    function __construct($namespace = "mp")
    {
        $this->ns = $namespace;
    }

    public function register(Application $app)
    {
        // FR : ajouter un chemin de templates à twig.path
        if (is_Array($app["twig.path"])) {
            $twigpath         = $app["twig.path"];
            $twigpath[]       = __DIR__ . "/../CodeGeneration/Resources/templates/";
            $app["twig.path"] = $twigpath;
        } else {
            $app["twig.path"] = $app->share(
                $app->extend("twig.path", function ($path, $app) {
                    $path[] = __DIR__ . "/../CodeGeneration/Resources/templates/";
                    return $path;
                }));
        }
    }

    public function boot(Application $app)
    {
    }
}