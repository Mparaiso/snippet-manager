<?php

namespace Controller;

use Silex\ControllerProviderInterface;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Security\Core\SecurityContextInterface;
use Symfony\Component\HttpFoundation\Request;
use Silex\Application;

/**
 * FR : administration globale du site. Accessible uniquement aux admins.
 * EN : global site administration , only accessible to admins
 */
class AdminController implements ControllerProviderInterface{
    function index(Request $req,Application $app){
        return $app["twig"]->render("admin_index.html.twig");
    }
    /**
     * Returns routes to connect to the given application.
     *
     * @param Application $app An Application instance
     *
     * @return ControllerCollection A ControllerCollection instance
     */
    public function connect(Application $app)
    {
        $controllers = $app["controllers_factory"];
        $controllers->match("/",array($this,"index"))->bind("admin_index");
        $controllers->before(array($this,"mustBeAdmin"));
        return $controllers;
    }

    function mustBeAdmin(Request $request,Application $app){
        /* @var $security \Symfony\Component\Security\Core\SecurityContextInterface */
        $security = $app["security"];
        if(! $security->isGranted("ROLE_ADMIN")){
            return new Response("You cant access this resource",403);
        }
    }
}