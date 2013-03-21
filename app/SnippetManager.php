<?php

use Controller\RoleController;
use Silex\Application;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Request;
use Controller\AdminController;
use Controller\SnippetController;
use Controller\CategoryController;
use Controller\AccountController;
use Controller\DefaultController;

class SnippetManager extends Silex\Application
{
    function __construct(array $values = array())
    {
        parent::__construct($values);
        $this->register(new ConfigProvider);
        $this->mount("/", new DefaultController);
        $this->mount("/account", new AccountController);
        $this->mount("/account", new SnippetController);
        $this->mount("/admin",new AdminController);
        $this->mount("/admin", new RoleController);
        $this->mount("/admin", new CategoryController);
        if($this["debug"]==FALSE){
            // force HTTPS on heroku
            $this->after(function(Request $req,Response $resp,Application $app){
                $resp->headers->add(array("Strict-Transport-Security: max-age=31536000; includeSubDomains"));
                return $resp;
            });
        }

    }

}