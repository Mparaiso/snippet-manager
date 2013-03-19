<?php
$app = require "web/bootstrap.php";
$app->boot();
$snippets = json_decode(file_get_contents("doc/datas/snippets.json"));


foreach ($snippets as $s):
    $e = new \Entity\Snippet();
    $e->setTitle($s->title);
    $e->setDescription($s->description);
    $e->setCreatedAt(new \DateTime);
    $e->setUpdatedAt(new \DateTime);
    $category = $app["category_service"]->find($s->category_id);
    $e->setCategory($category);
    $e->setContent($s->content);
    $e->setPrivate(false);
    $app["em"]->persist($e);
    echo \Doctrine\Common\Util\Debug::dump($e);
endforeach;
$app["em"]->flush();
echo "done!\n";


