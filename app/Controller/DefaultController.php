<?php

namespace Controller;

use Silex\Application;
use Silex\ControllerProviderInterface;

use Symfony\Component\HttpFoundation\Request;

class DefaultController implements ControllerProviderInterface{
	function index(Request $req,Application $app,$category=null,$format="html"){
	    $criteria = array("private"=>FALSE);
	    if($req->get("category")){
	        $criteria["category"]=$app["category_service"]->findOneBy(array("title"=>$req->get("category")));
	    }
		$snippets = $app["snippet_service"]
			->findAll($criteria,
			        $req->query->get("orderBy"),
					$req->query->get("limit"),
					$req->query->get("offset"));
		return $app["twig"]->render("index.$format.twig",array("snippets"=>$snippets));
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
        $controllers->match("/{category}.{format}",array($this,"index"))
            ->value("category","")
            ->value("format","html")
            ->bind("home");



        return $controllers;
    }
}