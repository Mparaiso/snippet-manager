<?php
use Silex\ServiceProviderInterface;
use Controller\SnippetController;
use Controller\CategoryController;
use Controller\RoleController;
use Silex\Provider\WebProfilerServiceProvider;
use Silex\Application;

class RouteProvider implements ServiceProviderInterface
{


    public function register(Application $app)
    {
        $app->match("/",'\Controller\DefaultController::index');
        $app->register($p = new WebProfilerServiceProvider, array(
            "profiler.cache_dir" => __DIR__ . "/../temp/profiler",
        ));
        $app->mount("/_profiler",$p);
        $app->mount("/admin/",new RoleController);
        $app->mount("/admin",new CategoryController);
        $app->mount("/admin",new SnippetController);

    }

    public function boot(Application $app)
    {
    }
}