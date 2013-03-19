<?php
use Silex\ServiceProviderInterface;
use Controller\DefaultController;
use Controller\AccountController;
use Controller\SnippetController;
use Controller\CategoryController;
use Controller\RoleController;
use Silex\Provider\WebProfilerServiceProvider;
use Silex\Application;

class RouteProvider implements ServiceProviderInterface
{


    public function register(Application $app)
    {
//        $app->register($p = new WebProfilerServiceProvider, array(
//            "profiler.cache_dir" => __DIR__ . "/../temp/profiler",
//        ));
//        $app->mount("/_profiler",$p);
        $app->mount("/",new DefaultController);
        $app->mount("/account",new AccountController);
        $app->mount("/account",new SnippetController);
        $app->mount("/admin",new RoleController);
        $app->mount("/admin",new CategoryController);

    }

    public function boot(Application $app)
    {
    }
}