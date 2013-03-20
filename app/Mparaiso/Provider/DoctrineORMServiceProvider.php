<?php

namespace Mparaiso\Provider;

use Silex\ServiceProviderInterface;
use Silex\Application;
use Doctrine\ORM\Tools\Setup;
use Doctrine\ORM\EntityManager;

class DoctrineORMServiceProvider implements ServiceProviderInterface {

  public function boot(Application $app) {

  }

  public function register(Application $app) {
    $app["em.proxy_dir"] = null;
    $app["em"] = $app->share(function($app) {
      if (!is_array($app["em.metadata"]["path"])) {
        throw new \Exception("\$app['em.metadata']['path'] must be an array of paths");
      }
      if ($app["em.metadata"]["type"] === "annotation") {
        $app["em.config"] = function($app) {
          return Setup::createAnnotationMetadataConfiguration(
            $app["em.metadata"]["path"],
            $app["em.is_dev_mode"],
            $app["em.proxy_dir"]
          );
        };
      } elseif ($app["em.metadata"]["type"] === "xml") {
        $app["em.config"] = function($app) {
          return Setup::createXMLMetadataConfiguration(
            $app["em.metadata"]["path"],
            $app["em.is_dev_mode"],
            $app["em.proxy_dir"]
          );
        };
      } elseif ($app["em.metadata"]["type"] === "yaml") {
        $app["em.config"] = function($app) {
          return Setup::createYAMLMetadataConfiguration(
            $app["em.metadata"]["path"],
            $app["em.is_dev_mode"],
            $app["em.proxy_dir"]);
        };
      }
      $app["em.is_dev_mode"] = $app->share(function($app){
        return $app["debug"];
      });
      // si le service em.options n'est pas déclaré , utiliser le service db de DoctrineServiceProvider
      if(!isset($app["em.options"]) && $app["db"]){
        $app["em.options"] = $app["db"];
      }
      $em = EntityManager::create($app["em.options"], $app["em.config"]);
      if(isset($app["em.logger"])){
        $em->getConfiguration()->setSQLLogger($app["em.logger"]);
      }
      return $em;
    }
  );
  }

}
