<?php

namespace Service;

use Doctrine\ORM\EntityManager;
use Mparaiso\CodeGeneration\Service\EntityService;
use Entity\Role;

class RoleService extends  EntityService
{
    function __construct(EntityManager $em, $entityClass='\Entity\Role')
    {
        parent::__construct($em, $entityClass);
    }


}