<?php

namespace Controller;

use Exception;
use Mparaiso\SimpleRest\Controller\Controller;
use Silex\Application;
use Silex\ControllerCollection;
use Symfony\Component\HttpFoundation\Request;

class SnippetController extends Controller
{
    function search(Request $req, Application $app, $search)
    {
        try {
            $collection = $this->service->search($search);
            $count = count($collection);
            $response = $this->makeResponse($app,
                array("message"                  => "$count $this->resourcePluralize found.",
                      "statuts"                  => self::SUCCESS,
                      "$this->resourcePluralize" => $collection), self::SUCCESS);
        } catch (Exception $e) {
            $response = $this->makeResponse($app, array("message" => $e->getMessage(), "status" => self::OTHER_ERROR), self::OTHER_ERROR);
        }
        return $response;
    }

    function addCustomRoutes(ControllerCollection $controllers)
    {
        $controllers->get("/$this->resource/search/{search}.{_format}", array($this, "search"))
            ->bind("mp_rest_{$this->resource}_search");
    }
}
