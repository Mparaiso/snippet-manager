<?php

namespace Controller;

use Mparaiso\CodeGeneration\Controller\AbstractCRUD;

class RoleController extends AbstractCRUD
{
    var $entityClass = "\Entity\Role";
    var $formClass = '\Form\RoleType';
    var $serviceName = "role_service";
    var $resourceName = "role";
}