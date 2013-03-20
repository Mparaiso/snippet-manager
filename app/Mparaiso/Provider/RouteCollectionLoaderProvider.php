<?php
/**
 *
 * @author MParaiso
 *
 */
namespace Mparaiso\Provider;

use Symfony\Component\Config\FileLocator;
use Symfony\Component\Config\ConfigCache;
use Symfony\Component\Routing\Loader\XmlFileLoader;
use Symfony\Component\Routing\Loader\YamlFileLoader;

use Silex\ServiceProviderInterface;
use Silex\Application;



/**
 *
 * Usage :
 * $app->register( new RouteCollectionLoaderProvider);
 *		$app["mp.route_loader"]->append(array(
 *				array(
 *						"type"=>"yaml",
 *						"path"=>__DIR__."/Resources/routes/routes.yml",
 *						"prefix"=>"/",
 *					),
 *               ...
 *		));
 *
 */
class RouteCollectionLoaderProvider implements ServiceProviderInterface {
	var $registered = false;
	var $app;
	function __construct($namespace="mp"){
		$this->ns = $namespace;
	}
    public function boot(Application $app) {
    }

    public function register(Application $app) {

    	if(TRUE === $this->registered ) return;
    	$self = $this;
    	$this->app = $app;
    	$this->registered = true;
		$app["$this->ns.route_collections"]=array();
		$app["$this->ns.route_loader"]= $app->share(function($app)use($self){

			return $self;
		});

    }

    /**
     * FR : ajoute de multiples configurations de routes aux routes actuelles
     * EN : add multiple route resources to the current routes
     */
	public function append(array $routes=array()){
		foreach($routes as $route){
			$this->add($route["type"],$route["path"],$route["prefix"]);
		}
	}
    /**
     * FR : ajoute une configuration de route aux routes actuelles
     * EN : add a route resource to the application route collection
     */
    public function add($type,$path,$prefix=null){
      if(!is_file($path))throw  new \Exception(" \$path must be a file ,  $path given ");
      $this->app["logger"]->info("blop");
      if(isset( $this->app["$this->ns.route_loader.cache_dir"])){
      	$cacheDir =$this->app["$this->ns.route_loader.cache_dir"];
      	$this->app["logger"]->log("writing cached route collection file, $cacheDir");
      		$className = "RouteCollection_".md5($path);
			$collectionCache = new ConfigCache($file=$cacheDir."/".$className.".php",$this->app["debug"]);
			if(!$collectionCache->isFresh()){
				$collection = $this->loadRouteCollection($type,$path);
				$dumper = new \Symfony\Component\Routing\Matcher\Dumper\PHPMatcheDumper($collection);
				$collectionCache->write(
						$dumper->dump(array("class"=>$className))
				);
			}
      }else{
		$collection = $this->loadRouteCollection($type, $path);
      }
		$this->app["routes"] = $this->app->share(
				$this->app->extend("routes", function($routes,$app)use($collection,$prefix){
					$routes->addCollection($collection,$prefix);
					return $routes;
				})
		);
    }
    /**
     * FR : charge une collection de routew
     * @param string $type file type
     * @param string $path file path
     */
    protected function loadRouteCollection($type/* type de fichier*/,$path/*chemin du fichier*/){
    	$loaderClass =$this->getLoaderClass($type);
    	$loader = new $loaderClass(new FileLocator(dirname($path)));
    	$collection = $loader->load($path);
    }
    
    /* FR : retourne la class du loader */
    protected function getLoaderClass($type){
    	switch ($type){
    		case "yaml":
    			return "\Symfony\Component\Routing\Loader\YamlFileLoader";
    			break;
    		case "xml":
    			return "\Symfony\Component\Routing\Loader\XmlFileLoader";
    			break;
    	}
    	throw new \Exception("loader for type $type not found");
    }

}



