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
}