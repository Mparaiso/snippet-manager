<?php

namespace Controller;


use Mparaiso\CodeGeneration\Controller\AbstractCRUD;

class SnippetController extends AbstractCRUD
{
    var $resourceName = "snippet";
    var $serviceName = "snippet_service";
    var $entityClass = '\Entity\Snippet';
    var $formClass = "\Form\SnippetType";
}