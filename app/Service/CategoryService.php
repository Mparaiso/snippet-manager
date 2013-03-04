<?php

namespace Service;

use Doctrine\ORM\EntityManager;

class CategoryService {
	protected $entityClass;
	protected $em;
    function __construct(EntityManager $em, $entityClass = "\Entity\Category") {
        $this->em          = $em;
        $this->entityClass = $entityClass;
    }
	function find($id){
		return $this->em->find($this->entityClass, $id);
	}
    function findOne($critera){
        return $this->em->getRepository($this->entityClass)->findOneBy($critera);
    }

    function save(\Entity\Category $category) {
        $this->em->persist($category);
        $this->em->flush();
    }

    function findAll() {
        return $this->em->getRepository($this->entityClass)->findAll();
    }


}