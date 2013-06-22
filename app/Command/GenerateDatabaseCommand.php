<?php

/*
 * @author Mparaiso
 */

namespace Command;

use Doctrine\DBAL\Connection;
use Doctrine\DBAL\Schema\Table;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console;

/**
 * Task for executing arbitrary SQL that can come from a file or directly from
 * the command line.
 *
 *
 * @link    www.doctrine-project.org
 * @since   2.0
 * @author  Benjamin Eberlei <kontakt@beberlei.de>
 * @author  Guilherme Blanco <guilhermeblanco@hotmail.com>
 * @author  Jonathan Wage <jonwage@gmail.com>
 * @author  Roman Borschel <roman@code-factory.org>
 */
class GenerateDatabaseCommand extends Console\Command\Command
{
    /**
     * @see Console\Command\Command
     */
    protected function configure()
    {
        $this
            ->setName('project:database:generate')
            ->setDescription('Generate the database for the project ')
            ->setHelp(<<<EOT
Generate the database for the project
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

        $schema = $conn->getSchemaManager();
        $category = new Table("category");
        $category->addColumn("id", "integer", array("Autoincrement" => TRUE,"Unique"=>true));

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
        $output->writeln("The Database has been generated ");

    }
}
