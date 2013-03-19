<?php

use Controller\RoleController;
use Silex\Application;

class SnippetManager extends Silex\Application
{
    function __construct($values = NULL)
    {
        parent::__construct($values);
        $this->register(new ConfigProvider);
        $this->register(new RouteProvider);
    }
    function getSecurity(){
        return $this["security"];
    }
    function getEncoder(){
        return $this["security.encoder_factory"];
    }

    function getEntityManager(){
        return $this["em"];
    }
}