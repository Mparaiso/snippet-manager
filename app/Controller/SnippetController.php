<?php

namespace Controller;


use Mparaiso\CodeGeneration\Controller\AbstractCRUD;
use Silex\Application;
use Symfony\Component\HttpFoundation\Request;

class SnippetController extends AbstractCRUD
{
    var $resourceName = "snippet";
    var $serviceName = "snippet_service";
    var $entityClass = '\Entity\Snippet';
    var $formClass = '\Form\SnippetType';
    var $userAware = TRUE;

    function byCategoryTitle(Request $req, Application $app, $title,$format)
    {
        $category = $app["category_service"]->findOne(array('title' => $title));
        if (!$category) {
            return $app->redirect("/");
        }
        $snippets = $app["snippet_service"]->findAll(array("category" => $category), array("created_at" => "DESC"));
        return $app["twig"]->render("index.$format.twig", array(
            "snippets" => $snippets,
        ));
    }

    function connect(Application $app)
    {
        $controllers = parent::connect($app);
        $controllers
            ->match("/snippet-category/{title}.{format}",
                array($this,"byCategoryTitle"))->bind("snippet_by_category_title")
            ->value("format","html")
            ->assert("format",'\w[\w \d]+');
        $controllers->before(function()use($app){
            $app["logger"]->info("blop");
        });

        return $controllers;
    }
}