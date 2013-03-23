<?php

namespace Controller;

use Silex\ControllerProviderInterface;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Request;
use Silex\Application;

class RssController implements ControllerProviderInterface
{
    /**
     * FR : génère un flux rss à partir de la BDD
     * @param \Symfony\Component\HttpFoundation\Request $req
     * @param $title
     * @param \Silex\Application $app
     * @return mixed
     */
    function index(Request $req, $title,Application $app)
    {
        $content = $app["rss_service"]->generate($title);
        return $content;
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
        $controllers->match("/rss/{title}", array($this, "index"))
            ->value("title", "")
            ->bind("rss")
            ->after(function(Request $req,Response $res,Application $app){
                $res->headers->add(
                    array("Content-type"=>"application/rss+xml"));
                return $res;
            });



        return $controllers;
    }
}