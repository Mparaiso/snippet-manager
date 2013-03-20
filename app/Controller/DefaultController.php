<?php

namespace Controller;

use Silex\Application;
use Silex\ControllerProviderInterface;

use Symfony\Component\HttpFoundation\Request;

/**
 * @author M.PARAISO
 * EN : Home controller
 * FR : Controleur racine du site
 */
class DefaultController implements ControllerProviderInterface
{
    /**
     * FR : affiche une liset de snippets <br/>
     * @param \Symfony\Component\HttpFoundation\Request $req
     * @param \Silex\Application $app
     * @param null $category
     * @param string $format
     * @return mixed
     */
    function index(Request $req, Application $app, $category = NULL, $format = "html")
    {
	        $orderBy = $req->query->get("orderBy");
			$limit  = 20;
		    $offset = (int)$req->query->get("offset",0)*$limit;
	    $criteria = array("private" => FALSE);
	    if ($req->get("category")) {
            $criteria["category"] = $app["category_service"]->findOneBy(array("title" => $req->get("category")));
        }
		$snippets = $app["snippet_service"]
            ->findAll($criteria,
            $req->query->get("orderBy"),
            $limit,
           $offset);
           $resource_count = count($snippets);
           $resource_limit = $limit;
           $resource_offset = $req->query->get("offset");
		return $app["twig"]->render("index.$format.twig",
		 array("snippets" => $snippets,"resource_limit"=>$resource_limit,
		 "resource_offset"=>$resource_offset,"resource_count"=>$resource_count));
	}

    /**
     * FR : affiche le contenu d'un snippet <br/>
     * @param \Symfony\Component\HttpFoundation\Request $req
     * @param \Silex\Application $app
     * @param $title
     * @return mixed
     */
    function snippet(Request $req, Application $app, $title)
    {
        $snippet = $app["snippet_service"]->findOneBy(array("title" => urldecode($title)));
        return $app["twig"]->render("detail.html.twig", array("snippet" => $snippet, "query" => $title));
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
        /* @var $controllers \Silex\ControllerCollection */
        $controllers = $app["controllers_factory"];
        $controllers->match("/snippet/{title}.{format}", array($this, "snippet"))
            ->value("format", "html")
            ->bind("snippet");
        $controllers->match("/{category}.{format}", array($this, "index"))
            ->value("category", "")
        //->asset("category",'\S+')
            ->value("format", "html")
            ->bind("home");


        return $controllers;
    }
}