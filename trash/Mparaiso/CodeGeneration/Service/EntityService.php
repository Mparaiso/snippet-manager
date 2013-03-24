<?php

namespace Mparaiso\CodeGeneration\Service;

use Doctrine\ORM\EntityManager;

/**
 * FR : fournit un service basic pour une entitée
 */
class EntityService
{

    function __construct(EntityManager $em, $entityClass)
    {
        $this->em          = $em;
        $this->entityClass = $entityClass;
    }

    function findAll(array $criteria = array(), $order = NULL, $limit = NULL, $offset = NULL)
    {
        return $this->findBy($criteria,$order,$limit,$offset);
    }

    function find($id)
    {
        return $this->em->find($this->entityClass, $id);
    }

    /**
     * FR: Efface une ressource
     * @param $entity
     * @return mixed
     */
    function save($entity)
    {
        $this->checkType($entity);
        $this->em->persist($entity);
        $this->em->flush();
        return $entity;
    }

    function delete($entity)
    {
        $this->checkType($entity);
        $result = $this->em->remove($entity);
        $this->em->flush();
        return $result;
    }

    /**
     * Vérifie le type d'une entitée
     * @param $entity
     * @throws \Exception
     */
    protected function checkType($entity)
    {
        if (!$entity instanceof $this->entityClass)
            throw new \Exception("Entity must be instance of $this->entityClass");
    }

    /**
     * FR : trouver une resource
     * @param array $criteria
     * @return object
     */
    function findOneBy(array $criteria=array()){
        return $this->em->getRepository($this->entityClass)->findOneBy($criteria);
    }
    function findBy(array $criteria = array(), $order = NULL, $limit = NULL, $offset = NULL)
    {
        return $this->em->getRepository($this->entityClass)->findBy($criteria, $order, $limit, $offset);
    }
    function count(array $criteria){

    }
}