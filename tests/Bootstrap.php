<?php

use Doctrine\DBAL\Connection;
use Doctrine\DBAL\Schema\Table;

$autoload = require __DIR__ . "/../vendor/autoload.php";

$autoload->add("", __DIR__ . "/../app/");
$autoload->add("", __DIR__ . "/../../lib");


class Bootstrap
{
    /**
     * FR : créer l'application<br>
     * EN : create application
     * @return App
     */
    static function getApp()
    {
        $app = new App(array("debug" => TRUE));
        $app["db.options"] = array(
            "driver" => "pdo_sqlite",
            "memory" => TRUE,
        );
        $app["exception_handler"]->disable();
        $app["session.test"] = TRUE;
        $app->boot();
        self::createDatabase($app["db"]);
        return $app;
    }

    /**
     * FR : crée le schéma de la base de donnée<br/>
     * EN : create db schema
     * @param Connection $conn
     */
    static function createDatabase(Connection $conn)
    {
        $schema = $conn->getSchemaManager();

        $category = new Table("category");
        $category->addColumn("id", "integer", array("Autoincrement" => TRUE));
        $category->addColumn("name", "string", array("length" => 128, "notnull" => TRUE));
        $category->setPrimaryKey(array("id"));

        $snippet = new Table("snippet");
        $snippet->addColumn("id", "integer", array("Autoincrement" => TRUE));
        $snippet->addColumn("title", "string", array(
            "length" => 256, "notnull" => TRUE));
        $snippet->addColumn("description", "string", array(
            "length" => 256, "notnull" => TRUE
        ));
        $snippet->addColumn("content", "text", array("Notnull" => TRUE));
        $snippet->addColumn("prettyContent", "text", array("Notnull" => TRUE));
        $snippet->addColumn("category_id", "integer", array("Notnull" => TRUE));
        $snippet->addColumn("created_at", "datetime", array("Notnull" => TRUE));
        $snippet->addColumn("updated_at", "datetime", array("Notnull" => TRUE));
        $snippet->setPrimaryKey(array("id"));
        $snippet->addForeignKeyConstraint($category, array("category_id"), array("id"));
        $schema->dropAndCreateTable($category);
        $schema->dropAndCreateTable($snippet);

    }
}

Bootstrap::getApp();