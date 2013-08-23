<?php

namespace Controller;

use Silex\ControllerProviderInterface;
use Silex\Application;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

/**
 * IndexController
 */
class IndexController implements ControllerProviderInterface{

	/**
	 * A snippet page embedded in an iframe
	 */
	function embedded(Application $app,$id){
		$snippet = $app["snippet_service"]->find($id);
		if($snippet==null){
			throw new NotFoundHttpException("Snippet with id $id not found");
		}

		$showTitle = $app["request"]->query->get("showTitle");
		$showDescription = $app["request"]->query->get("showDescription");
		$style = $app["request"]->query->get("style","default");

		return $app["twig"]->render("snippetd/embedded.html.twig",array(
			"snippet"=>$snippet,
			"showTitle"=>$showTitle,
			"style"=>$style,
			"showDescription"=>$showDescription
			)
		);
	}

	/**
	 * The front page 
	 */
	function index() {
		$content = file_get_contents(__DIR__ . '/../../web/static/js/snippetd/partials/index.html');
		return $content;
	}

	function connect(Application $app){
		$controllers = $app["controllers_factory"];
		$controllers->get("/",array($this,"index"));
		$controllers->get("/snippet/embedded/{id}",array($this,"embedded"));
		return $controllers;
	}

}