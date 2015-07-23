<?php
/**
 * author M.PARAISO
 */
namespace Mparaiso\Provider;

use Silex\ServiceProviderInterface;
use Silex\Application;
use Symfony\Component\DependencyInjection\ParameterBag\ParameterBag;
use Symfony\Component\DependencyInjection\Loader\YamlFileLoader;
use Symfony\Component\DependencyInjection\Loader\XmlFileLoader;
use Symfony\Component\DependencyInjection\ContainerBuilder;
use Symfony\Component\Config\FileLocator;
use Symfony\Component\Config\ConfigCache;
use Symfony\Component\DependencyInjection\Dumper\PhpDumper;

/**
 * FR : fournit un service d'injection de dépendances
 *      exemple de configuration : 
 * EN : provides a DI service.
 *      configuration exemple :
 * use Mparaiso\Provider\DependencyInjectionServiceProvider;
 * 
 * $app->register(new DependencyInjectionServiceProvider,array(
 *    "di.cache"=>array("path"=>__DIR__."/../cache/","class"=>"MyCacheClass"),
 *    "di.params"=>array(
 *        "app.root_dir"=>__DIR__,
 *        "app.debug"=>$app["debug"],
 *        "app.host"=>getenv("SYMFONY__SHORTEN__HOST"),
 *        "app.driver"=>"pdo_mysql",
 *        "app.user"=>getenv("SYMFONY__SHORTEN__USER"),
 *        "app.password"=>getenv("SYMFONY__SHORTEN__PASSWORD"),
 *        "app.dbname"=>getenv("SYMFONY__SHORTEN__DBNAME"),
 *        "app.port"=>getenv("SYMFONY__SHORTEN__PORT"),
 *        ),
 *    "di.loader.options"=>array(
 *        "type"=>"yaml",
 *        "path"=>__DIR__."/Shorten/Resources/services/config.yml",
 *        )
 *    ) 
 * );
 *
 */
class DependencyInjectionServiceProvider implements ServiceProviderInterface{

    function boot(Application $app){

    }
    /**
     * FR : methode statique permettant de créer un containerBuilder
     * EN : creates a container builder
     * @return Symfony\Component\DependencyInjection\ContainerBuilder
     */
    static function makeContainer($app){
        $container =  new ContainerBuilder( new ParameterBag($app["di.params"]));
        if($app["di.loader.options"]["type"]==="yaml"){
            $loader = new YamlFileLoader($container,new FileLocator);

        }elseif($app["di.loader.options"]["type"]==="xml"){
            $loader = new XmlFileLoader($container,new FileLocator);
        }
        if(isset($loader)){
            $loader->load($app["di.loader.options"]["path"]);
            $app["di.loader"] = $loader;
        }
        $container->compile();
        return $container;
    }

    function register(Application $app){
        if(!isset($app["di.params"]))
            $app["di.params"]=array();
        if(!isset($app["di.loader.options"]))
            $app["di.loader.options"] = array();
        $app["di"]=$app->share(function($app){
            // FR : si di.cache , activer le cache
            // EN : activate caching
            if(isset($app["di.cache"])){
                $class = $app["di.cache"]["class"];
                $file = $app["di.cache"]["path"]."container_".md5($class).".php";
                if(!file_exists(dirname($file)))
                    mkdir(dirname($file));
                $containerConfigCache = new ConfigCache($file,$app["debug"]);
                if(!$containerConfigCache->isFresh()){
                    $container = self::makeContainer($app);
                    $dumper = new PhpDumper($container);
                    $containerConfigCache->write(
                        $dumper->dump(array("class"=>$class)),
                        $container->getResources()
                        );
                }
                require_once $file;
                $container = new $class;
            }else{
                $container = self::makeContainer($app);
            }
            return $container;
        });

    }

}