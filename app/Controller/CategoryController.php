<?php

namespace Controller;

use Silex\ControllerProviderInterface;
use Mparaiso\CodeGeneration\Controller\AbstractCRUD;

class CategoryController extends AbstractCRUD
{
    var $resourceName = "category";
    var $entityClass = '\Entity\Category';
    var $formClass = '\Form\CategoryType';
    var $serviceName = "category_service";
}