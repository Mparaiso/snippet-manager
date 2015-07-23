<?php

namespace Controller;

use Mparaiso\CodeGeneration\Controller\AbstractCRUD;

class UserController extends AbstractController {
	public $entityClass = '\Entity\User';
	public $formClass = '\Form\RegistrationType';
	public $serviceName = "user_service";
	public $createMethod = "register";
	public $resourceName = "user";
	public $collectionName;
}
