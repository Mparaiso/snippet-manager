<?php

namespace Service;

use Doctrine\ORM\EntityManager;
use Entity\Role;

class RoleService{
	function __construct(EntityManager $em,$entityClass='\Entity\Role'){
        $this->em = $em;
        $this->entityClass=$entityClass;
    }
    function findAll(){
        return $this->findBy();
    }
    function find($id){
        return $this->em->find($this->entityClass,$id);
    }
    function save(Role $role){
        $this->em->persist($role);
        $this->em->flush();
        return $role;
    }
    function delete($role){
        $result =  $this->em->remove($role);
        $this->em->flush();
        return $result;
    }
    private function findBy(array $criteria = array(),$order=null,$limit=null,$offset=null)
    {
        return $this->em->getRepository($this->entityClass)->findBy($criteria,$order,$limit,$offset);
    }
}