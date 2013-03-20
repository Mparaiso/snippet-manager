<?php

use Controller\RoleController;
use Controller\SnippetController;
use Controller\CategoryController;
use Controller\AccountController;
use Controller\DefaultController;
use Silex\Application;

class SnippetManager extends Silex\Application
{
    function __construct($values = NULL)
    {
        parent::__construct($values);
        $this->register(new ConfigProvider);
        $this->mount("/", new DefaultController);
        $this->mount("/account", new AccountController);
        $this->mount("/account", new SnippetController);
        $this->mount("/admin", new RoleController);
        $this->mount("/admin", new CategoryController);
    }

}