<?php

use Silex\Provider\ServiceControllerServiceProvider;
use Silex\Provider\DoctrineServiceProvider;
use Mparaiso\Provider\CrudGeneratorServiceProvider;
use Silex\Provider\SecurityServiceProvider;
use Symfony\Bridge\Doctrine\Security\User\EntityUserProvider;
use Mparaiso\Doctrine\ORM\Logger\MonologSQLLogger;
use Symfony\Bridge\Doctrine\Validator\Constraints\UniqueEntityValidator;
use Helper\PimpleConstraintValidatorFactory;
use Helper\EntityManagerRegistry;
use Service\CategoryService;
use ServiceProvider\AclServiceProvider;
use Service\UserService;
use Symfony\Bridge\Doctrine\Form\DoctrineOrmExtension;
use Silex\Provider\SessionServiceProvider;
use Service\SnippetService;
use Silex\Provider\HttpCacheServiceProvider;
use Silex\Provider\MonologServiceProvider;
use Silex\Provider\TranslationServiceProvider;
use Silex\Provider\UrlGeneratorServiceProvider;
use Silex\Provider\ValidatorServiceProvider;
use Silex\Provider\FormServiceProvider;
use Mparaiso\Provider\DoctrineORMServiceProvider;
use Silex\Provider\TwigServiceProvider;
use Silex\Application;
use Silex\ServiceProviderInterface;
use Symfony\Component\Validator\Mapping\Loader\YamlFileLoader;
use Symfony\Component\Validator\Mapping\ClassMetadataFactory;

/**
 * FR : configuration de l'application , appelle différents ServiceProviders pour enregistrer différents
 * services dans le conteneur Pimple.
 * EN : configure application , instanciate different ServiceProviders to populate Pimple with Services.
 */
class ConfigProvider implements ServiceProviderInterface
{
    function register(Application $app)
    {
        define("TEMP_DIR", __DIR__ . "/../temp/");
        $app->register(new TwigServiceProvider(), array(
            "twig.options" => array("cache" => TEMP_DIR),
            "twig.path"    => $app->share(function($app){
                    return array(__DIR__ . "/Resources/templates/")   ;
            })
        ));

        $app->register(new DoctrineServiceProvider(),array(
            "db.options"=> array(
                "dbname"   => getenv("SNIPPETMANAGER_DBNAME"),
                "user"     => getenv("SNIPPETMANAGER_USER"),
                "password" => getenv("SNIPPETMANAGER_PASSWORD"),
                "host"     => getenv("SNIPPETMANAGER_HOST"),
                "driver"   => "pdo_mysql",
        )));
        #@note @silex configuration DoctrineORMServiceProvider
        $app->register(new DoctrineORMServiceProvider, array(
            "em.registry"    => $app->share(function ($app) {
                return new EntityManagerRegistry($app["em"]);
            }),
            "em.proxy_dir"   => __DIR__ . "/Proxy",
            "em.is_dev_mode" => $app->share(function ($app) {
                return $app["debug"];
            }),
            "em.logger"      => $app->share(function ($app) {
                return new MonologSQLLogger($app["logger"]);
            }),
            "em.metadata"    => array("type" => "yaml", "path" => array(__DIR__ . "/Resources/doctrine/"))));
        $app->register(new AclServiceProvider);
        $app->register(new FormServiceProvider);
        $app->register(new SessionServiceProvider);
        $app->register(new ValidatorServiceProvider, array(
                "validator.mapping.file_path"              => __DIR__ . "/Resources/validation/validation.yml",
                "validator.mapping.class_metadata_factory" => $app->share(function ($app) {
                    return new ClassMetadataFactory(new YamlFileLoader($app["validator.mapping.file_path"]));
                }),
                'validator.validator_factory'              => $app->share(function ($app) {
                    /** FR : @note @silex utiliser les contraintes de validation de classe pour Doctrine * */
                    return new PimpleConstraintValidatorFactory($app, array(
                        "validator.unique_entity" => "validator.unique_entity",
                    ));
                }),
                "validator.unique_entity"                  => function ($app) {
                    return new UniqueEntityValidator($app["em.registry"]);
                })
        );
        $app->register(new SecurityServiceProvider, array(
            "security.firewalls" => array(
                "site" => array(
                    "pattern"   => "^/",
                    "anonymous" => array() /* FR : autorise les utilisateurs anonymes ,EN : allow anonymous users */
                )
            ),
            "providers"          => array(
                "main" => $app->share(function ($app) {
                    return $app["user_provider"];
                })
            )
        ));
        $app->register(new ServiceControllerServiceProvider);
        $app->register(new UrlGeneratorServiceProvider);
        $app->register(new TranslationServiceProvider);
        $app->register(new MonologServiceProvider, array("monolog.logfile" =>TEMP_DIR . date('Y-m-d') . ".txt"));
        $app->register(new HttpCacheServiceProvider, array("http_cache.cache_dir" =>TEMP_DIR));
        $app->register(new CrudGeneratorServiceProvider);

        $app["role_service"]     = $app->share(function ($app) {
            return new \Service\RoleService($app['em']);
        });
        $app["snippet_service"]  = $app->share(function ($app) {
            return new SnippetService($app["em"],'\Entity\Snippet');
        });
        $app["category_service"] = $app->share(function ($app) {
            return new CategoryService($app["em"]);
        });
        $app["user_service"]     = $app->share(function ($app) {
            return new UserService($app["em"], $app["security.encoder_factory"]);
        });
        $app["form.extensions"]  = $app->share(
        #@note @silex utiliser les extensions de formulaire de doctrine
            $app->extend("form.extensions", function ($extensions, $app) {
                    $extensions[] = new DoctrineOrmExtension($app["em.registry"]);
                    return $extensions;
                }
            ));
        $app["user_provider"]    = $app->share(function ($app) {
            return new EntityUserProvider($app["em.registry"], "\Entity\User", "email");
        });
    }

    function boot(Application $app)
    {

    }
}
