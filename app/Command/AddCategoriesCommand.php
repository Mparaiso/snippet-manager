<?php

/*
 * @author Mparaiso
 */

namespace Command;

use Doctrine\DBAL\Connection;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console;

/**
 * Class AddCategoriesCommand
 * Add default categories to the database
 * @package Command
 */
class AddCategoriesCommand extends Console\Command\Command
{
    /**
     * @see Console\Command\Command
     */
    protected function configure()
    {
        $this
            ->setName('project:database:category:generate')
            ->setDescription('Add default categories to the database ')
            ->setHelp(<<<EOT
Add default categories to the database
EOT
            );
    }

    /**
     * FR : Crée la base de donnée<br>
     * EN : create database
     * @see Console\Command\Command
     */
    protected function execute(Console\Input\InputInterface $input, Console\Output\OutputInterface $output)
    {
        $conn = $this->getHelper('db')->getConnection();

        /* @var Connection $conn */

        $categories = array('Other', 'Bash', 'C#', 'C', 'C++', 'CSS',
            'Diff', 'HTML', 'HTTP', 'Ini', 'JSON', 'Java', 'Javascript',
            'PHP', 'Perl', 'Python', 'Ruby', 'Scala', 'SQL', "Go",
            "ActionScript", "Haskell", "Erlang", "Apache", "Lisp",
            "Visual Basic", "Haxe");

        natsort($categories);

        $conn->beginTransaction();
        foreach ($categories as $category) {
            $conn->insert("category", array("name" => $category));
        }
        $conn->commit();
        /*
        $schema = $conn->getSchemaManager();
        $category = new Table("category");
        $category->addColumn("id", "integer", array("Autoincrement" => TRUE, "Unique" => TRUE));

        $category->addColumn("name", "string", array("length" => 128, "notnull" => TRUE));
        $category->setPrimaryKey(array("id"));
        $category->addIndex(array("name"));

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

        //if (!$schema->tablesExist(array("category")))
        $schema->dropAndCreateTable($category);
        //if (!$schema->tablesExist(array("snippet")))
        $schema->dropAndCreateTable($snippet);
        */
        $output->writeln("Categories have been added to the database ");

    }
}
