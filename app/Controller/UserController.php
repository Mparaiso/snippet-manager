<?php

namespace Controller;

class UserController extends AbstractController {
	public $entityClass = "\Entity\User";
	public $formClass = "\Form\RegistrationType";
	public $serviceName = "user_service";
	public $createMethod = "register";
	public $resourceName = "user";
	public $collectionName;
}
