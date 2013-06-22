<?php


/**
 * Class Config<br>
 * FR : Configuration de l'application<br>
 * EN : Application Configuration<br>
 */

use Command\AddCategoriesCommand;
use Command\AddDefaultSnippetsCommand;
use Command\GenerateDatabaseCommand;
use Controller\SnippetController;
use Mparaiso\CodeGeneration\Controller\CRUD;
use Mparaiso\Provider\ConsoleServiceProvider;
use Mparaiso\Provider\CrudServiceProvider;
use Mparaiso\SimpleRest\Controller\Controller;
use Mparaiso\SimpleRest\Provider\DBALProvider;
use Mparaiso\SimpleRest\Service\Service;
use Service\SnippetService;
use Silex\Application;
use Silex\Provider\DoctrineServiceProvider;
use Silex\Provider\FormServiceProvider;
use Silex\Provider\MonologServiceProvider;
use Silex\Provider\SerializerServiceProvider;
use Silex\Provider\TranslationServiceProvider;
use Silex\Provider\TwigServiceProvider;
use Silex\Provider\UrlGeneratorServiceProvider;
use Silex\Provider\ValidatorServiceProvider;
use Symfony\Component\EventDispatcher\GenericEvent;
use Symfony\Component\HttpFoundation\Request;

class Config implements \Silex\ServiceProviderInterface
{

    /**
     * {@inheritdoc}
     */
    public function register(Application $app)
    {
        $app->register(new DoctrineServiceProvider(), array(
            "db.options" => array(
                "driver"   => getenv("SIMPE_REST_DRIVER"),
                "host"     => getenv("SIMPE_REST_HOST"),
                "dbname"   => getenv("SIMPE_REST_DBNAME"),
                "user"     => getenv("SIMPLE_REST_USER"),
                "password" => getenv("SIMPLE_REST_PASSWORD"),
                "port"     => getenv("SIMPLE_REST_PORT")
            )
        ));

        $app->register(new SerializerServiceProvider());
        $app->register(new ConsoleServiceProvider());
        $app->register(new MonologServiceProvider(), array(
            "monolog.logfile" => __DIR__ . "/../temp/" . date("Y-m-d") . ".txt"));


        $app["console"] = $app->share($app->extend("console", function ($console, $app) {
            $console->add(new GenerateDatabaseCommand);
            $console->add(new AddCategoriesCommand);
            $console->add(new AddDefaultSnippetsCommand);
            return $console;
        }));

        $app->register(new TwigServiceProvider, array(
            'twig.path'    => __DIR__ . "/Resources/views",
            "twig.options" => array(
                "cache" => __DIR__ . "/../temp/twig"
            )
        ));

        $app->register(new FormServiceProvider);

        $app->register(new ValidatorServiceProvider);

        $app->register(new TranslationServiceProvider);

        $app->register(new CrudServiceProvider);

        $app->register(new UrlGeneratorServiceProvider);

        $app['snippet_provider'] = $app->share(function ($app) {
            return new DBALProvider($app["db"], array(
                "model" => $app["snippet_model"],
                "name"  => "snippet",
                "id"    => "id"
            ));
        });

        $app["snippet_service"] = $app->share(function ($app) {
            return new SnippetService($app["snippet_provider"]);
        });

        $app["snippet_controller"] = $app->share(function ($app) {
            $controller = new SnippetController(array(
                "resource"          => "snippet",
                "resourcePluralize" => "snippets",
                "model"             => $app["snippet_model"],
                "service"           => $app["snippet_service"]
            ));
            return $controller;
        });

        $app["snippet_crud_controller"] = $app->share(function ($app) {
            return new CRUD(
                array(
                    "resourceName"   => "snippet",
                    "service"        => $app["snippet_service"],
                    "entityClass"    => $app["snippet_model"],
                    "formClass"      => $app["snippet_form"],
                    "propertyList"   => array("title", "description"),
                    "properties"     => array("title", "description", "content"),
                    "templateLayout" => "crud_layout.html.twig"
                ));
        });

        $app['category_provider'] = $app->share(function ($app) {
            return new DBALProvider($app["db"], array(
                "model" => $app["category_model"],
                "name"  => "category",
                "id"    => "id"
            ));
        });

        $app["category_service"] = $app->share(function ($app) {
            return new Service($app["category_provider"]);
        });

        $app["category_controller"] = $app->share(function ($app) {
            $controller = new Controller(array(
                "resource"          => "category",
                "resourcePluralize" => "categories",
                "model"             => $app["category_model"],
                "service"           => $app["category_service"]
            ));
            return $controller;
        });

        $app["category_crud_controller"] = $app->share(function ($app) {
            return new CRUD(
                array(
                    "resourceName"   => "category",
                    "service"        => $app["category_service"],
                    "entityClass"    => $app["category_model"],
                    "formClass"      => $app["category_form"],
                    "templateLayout" => "crud_layout.html.twig"
                ));
        });

        $app["snippet_model"] = '\Model\Snippet';
        $app["snippet_form"] = '\Form\Snippet';

        $app["category_model"] = '\Model\Category';
        $app["category_form"] = '\Form\Category';

        $app["snippet_before_create"] = $app->protect(function (GenericEvent $event) {
            $model = $event->getSubject();
            $now = new DateTime;
            $date = $now->format("Y-m-d H:i:s");
            $model->setCreatedAt($date);
            $model->setUpdatedAt($date);
        });

        $app["snippet_before_update"] = $app->protect(function (GenericEvent $event) {
            $model = $event->getSubject();
            $now = new DateTime;
            $date = $now->format("Y-m-d H:i:s");
            $model->setUpdatedAt($date);
        });


    }

    /**
     * {@inheritdoc}
     */
    public function boot(Application $app)
    {
        $app->get("/", function () {
            $content = file_get_contents(__DIR__ . '/../web/static/js/snippetd/partials/index.html');
            return $content;
        });
        $app->mount("/api/", $app["snippet_controller"]);
        $app->mount("/api/", $app["category_controller"]);

        $app->mount("/admin/", $app["snippet_crud_controller"]);
        $app->mount("/admin/", $app["category_crud_controller"]);

        $app->on("snippet_before_create", $app["snippet_before_create"]);
        $app->on("snippet_before_update", $app["snippet_before_update"]);


    }
}
