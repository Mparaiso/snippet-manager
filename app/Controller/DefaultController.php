<?php

namespace Controller;

use Silex\Application;

use Symfony\Component\HttpFoundation\Request;

class DefaultController{
	function index(Request $req,Application $app,$format="html"){
		$snippets = $app["snippet_service"]
			->findAll($req->query->get("orderBy"),
					$req->query->get("limit"),
					$req->query->get("offset"));
		return $app["twig"]->render("index.$format.twig",array("snippets"=>$snippets));
	}
}