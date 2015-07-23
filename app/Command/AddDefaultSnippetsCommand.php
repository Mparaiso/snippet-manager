<?php

/*
 * @author Mparaiso
 */

namespace Command;

use DateTime;
use Doctrine\DBAL\Connection;
use Model\Snippet;
use Service\SnippetService;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console;

/**
 * Class AddCategoriesCommand
 * Add default categories to the database
 * @package Command
 */
class AddDefaultSnippetsCommand extends Console\Command\Command
{
    /**
     * @see Console\Command\Command
     */
    protected function configure()
    {
        $this
            ->setName('project:database:snippet:generate')
            ->setDescription('Add default snippets to the database ')
            ->setHelp(<<<EOT
Add default snippets to the database
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
        $app = $this->getHelper("app")->getApplication();
        $service = $app["snippet_service"];
        /* @var SnippetService $service */
        $json = file_get_contents(__DIR__ . "/snippets.json");
        $snippets = json_decode($json, TRUE);

        /* @var Connection $conn */

        $conn->beginTransaction();
        $defaultCategory = $app["category_service"]->findOneBy(array("name"=>"other"));
        foreach ($snippets as $snippet) {
            if (isset($snippet['id']))
                unset($snippet["id"]);
            $snippet["created_at"] = $service->makeDate(new DateTime);
            $snippet["updated_at"] = $service->makeDate(new DateTime);
            if(!$snippet["category_id"]){
                $snippet["category_id"] = $defaultCategory->getId();
            }
            $service->create(new Snippet($snippet));
        }
        $conn->commit();

        $output->writeln("Snippets have been added to the database ");

    }
}
