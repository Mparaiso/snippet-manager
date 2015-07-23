<?php

namespace Service;

use Doctrine\ORM\EntityManager;
use Mparaiso\CodeGeneration\Service\EntityService;

class CategoryService extends EntityService{
    function __construct(EntityManager $em, $entityClass = '\Entity\Category') {
        $this->em          = $em;
        $this->entityClass = $entityClass;
    }

}