<?php

use Doctrine\DBAL\Connection;
use Model\Category;
use Symfony\Component\HttpKernel\HttpKernel;

class DatabaseTest extends \Silex\WebTestCase
{
    /**
     * Creates the application.
     *
     * @return HttpKernel
     */
    public function createApplication()
    {
        return Bootstrap::getApp();
    }

    /**
     * FR : test de la création du schéma
     * EN : schema creation test
     */
    function testCreate()
    {
        $db = $this->app['db'];
        $category_name = "Javascript";
        /* @var Connection $db */
        // on crée un catégory , on ajoute la catégorie à la table catégorie
        $category = new Category(array("name" => $category_name));
        $rowsAffected = $db->insert("category", $category->toArray());
        $this->assertEquals(1, $rowsAffected);
        // on selectionne la catégorie crée
        $qb = $db->createQueryBuilder();
        $qb->select("*")->from("CATEGORY", "c")->where(" c.name = :name ");
        $qb->setParameters(array(":name" => $category_name));
        /* @var \PDOStatement $statement */
        $statement = $qb->execute();
        $cat = $statement->fetchObject('\Model\Category');
        /* @var \Model\Category $cat */
        $this->assertEquals($category_name, $cat->getName());


    }
}