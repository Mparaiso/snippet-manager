<?php
#@note @silex FR : créer un ManagerRegistry pour utiliser les extensions de formulaire
# de doctrine

namespace Helper;

use  \Doctrine\Common\Persistence\ManagerRegistry;

class EntityManagerRegistry implements ManagerRegistry
{

    /**
     * @var \Doctrine\ORM\EntityManager
     */
    protected $em;
    function __construct(\Doctrine\ORM\EntityManager $em)
    {
        $this->em = $em;
    }

    /**
     * Gets the default connection name.
     *
     * @return string The default connection name
     */
    function getDefaultConnectionName()
    {
        return "default";
    }

    /**
     * Gets the named connection.
     *
     * @param string $name The connection name (null for the default one)
     *
     * @return object
     */
    function getConnection($name = null)
    {
        return $this->em->getConnection();
    }

    /**
     * Gets an array of all registered connections
     *
     * @return array An array of Connection instances
     */
    function getConnections()
    {
        return array("default"=>$this->em->getConnection());
    }

    /**
     * Gets all connection names.
     *
     * @return array An array of connection names
     */
    function getConnectionNames()
    {
        return array("default");
    }

    /**
     * Gets the default object manager name.
     *
     * @return string The default object manager name
     */
    function getDefaultManagerName()
    {
        return "default";
    }

    /**
     * Gets a named object manager.
     *
     * @param string $name The object manager name (null for the default one)
     *
     * @return \Doctrine\Common\Persistence\ObjectManager
     */
    function getManager($name = null)
    {
        return $this->em;
    }

    /**
     * Gets an array of all registered object managers
     *
     * @return \Doctrine\Common\Persistence\ObjectManager[] An array of ObjectManager instances
     */
    function getManagers()
    {
        return array("default"=>$this->em);
    }

    /**
     * Resets a named object manager.
     *
     * This method is useful when an object manager has been closed
     * because of a rollbacked transaction AND when you think that
     * it makes sense to get a new one to replace the closed one.
     *
     * Be warned that you will get a brand new object manager as
     * the existing one is not useable anymore. This means that any
     * other object with a dependency on this object manager will
     * hold an obsolete reference. You can inject the registry instead
     * to avoid this problem.
     *
     * @param string $name The object manager name (null for the default one)
     *
     * @return \Doctrine\Common\Persistence\ObjectManager
     */
    function resetManager($name = null)
    {
        $this->em;
    }

    /**
     * Resolves a registered namespace alias to the full namespace.
     *
     * This method looks for the alias in all registered object managers.
     *
     * @param string $alias The alias
     *
     * @return string The full namespace
     */
    function getAliasNamespace($alias)
    {
       return $alias;
    }

    /**
     * Gets all connection names.
     *
     * @return array An array of connection names
     */
    function getManagerNames()
    {
        return array("default");
    }

    /**
     * Gets the ObjectRepository for an persistent object.
     *
     * @param string $persistentObject        The name of the persistent object.
     * @param string $persistentManagerName The object manager name (null for the default one)
     *
     * @return \Doctrine\Common\Persistence\ObjectRepository
     */
    function getRepository($persistentObject, $persistentManagerName = null)
    {
        return $this->em->getRepository($persistentObject);
    }

    /**
     * Gets the object manager associated with a given class.
     *
     * @param string $class A persistent object class name
     *
     * @return \Doctrine\Common\Persistence\ObjectManager|null
     */
    function getManagerForClass($class)
    {
      if(NULL!=$this->em->getClassMetadata($class))
          return $this->em;
    }
}