<?php
namespace ServiceProvider;
use Silex\ServiceProviderInterface;
use Symfony\Component\Security\Acl\Permission\BasicPermissionMap;
use Symfony\Component\Security\Acl\Dbal\Schema;
use Symfony\Component\Security\Acl\Dbal\AclProvider;
use Symfony\Component\Security\Acl\Voter\AclVoter;
use Symfony\Component\Security\Acl\Domain\PermissionGrantingStrategy;
use Symfony\Component\Security\Acl\Domain\SecurityIdentityRetrievalStrategy;
use Symfony\Component\Security\Acl\Domain\ObjectIdentityRetrievalStrategy;
#use Symfony\Component\Security\Acl\Domain\AclCollectionCache;
use Symfony\Component\Security\Acl\Domain\DoctrineAclCache;
use Silex\Application;

/**
 * @author M.Paraiso
 * @contact mparaiso@online.fr
 */
class AclServiceProvider implements ServiceProviderInterface
{
    /**
     * Registers services on the given app.
     *
     * @param Application $app An Application instance
     */
    public function register(Application $app)
    {
        $app["security.acl.dbal.provider.options"] = array(
            "class_table_name"         => "acl_classes",
            "entry_table_name"         => "acl_entries",
            "oid_table_name"           => "acl_object_identities",
            "oid_ancestors_table_name" => "acl_object_identity_ancestors",
            "sid_table_name"           => "acl_security_identities"
        );
        $app["security.acl.object_identity_retrieval_strategy"] = $app->share(function ($app) {
            return new ObjectIdentityRetrievalStrategy();
        });
        $app["security.acl.security_identity_retrieval_strategy"] = $app->share(function ($app) {
            return new SecurityIdentityRetrievalStrategy($app["security.role_hierarchy"], $app["security.authentication.trust_resolver"]);
        });
        $app["security.acl.permission_granting_strategy"] = $app->share(function ($app) {
            $service = new PermissionGrantingStrategy();
            $service->setAuditLogger($app["security.acl.audit_logger"]);
            return $service;
        });
        $app["security.acl.permission.map"] = $app->share(function ($app) {
            return new AclVoter($app["security.acl.provider"], $app["security.acl.object_identity_retrieval_strategy"], $app['security.acl.security_identity_retrieval_strategy'], $app['security.acl.permission.map'], $app["logger"]);
        });

        $app["security.acl.dbal.connection"] = $app->share(function ($app) {
            return $app["db"];
        });
        $app["security.acl.dbal.provider"]  = $app->share(function ($app) {
            return new AclProvider($app["security.acl.dbal.connection"], $app["security.acl.permission_granting_strategy"], $app["security.acl.dbal.provider.options"], $app["security.acl.cache"]);
        });
        $app['security.acl.dbal.schema']  = $app->share(function ($app) {
            return new Schema($app["security.acl.dbal.provider.options"], $app["security.acl.dbal.connection"]);
        });
        $app["security.acl.dbal.schema_listener"] = $app->share(function ($app) {
            return new AclSchemaListener($app);
        });

        $app["security.acl.provider"] = $app->share(function($app){
        return $app["security.acl.dbal.provider"];
        });

        $app["security.acl.cache.doctrine"] = $app->share(function($app){
            return new DoctrineAclCache($app['security.acl.cache.doctrine.cache_impl'],$app['security.acl.permission_granting_strategy']);
        });

        $app["security.acl.cache.doctrine.cache_impl"]=$app->share(function($app){
        return $app['"doctrine.orm.default_result_cache"'];
        });
        $app["security.acl.permission.map"] = $app->share(function($app){
        return new BasicPermissionMap();
        });
    }

    /**
     * Bootstraps the application.
     *
     * This method is called after all services are registers
     * and should be used for "dynamic" configuration (whenever
     * a service must be requested).
     */
    public function boot(Application $app)
    {
        // TODO: Implement boot() method.
    }
}