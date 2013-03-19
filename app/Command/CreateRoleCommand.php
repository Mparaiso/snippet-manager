<?php

namespace Command;

use Symfony\Component\Console\Output\OutputInterface;
use Entity\Role;
use Symfony\Component\Console\Input\InputArgument;
use Entity\Account;
use Symfony\Component\Console\Input\InputOption;

use Symfony\Component\Console\Input\InputInterface;

use Symfony\Component\Console\Command\Command;

/**
 * FR : affiche la liste de tout les services enregistrés dans le conteneur de service Pimple
 * EN : list all Pimple registered services.
 * @author M.Paraiso
 */
class CreateRoleCommand extends Command
{

    /**
     *
     */
    protected function configure()
    {
        $this->addOption("role", "r", InputOption::VALUE_REQUIRED, "role name")
            ->setName("app:role:create")
            ->setDescription("Create a new role")
            ->setHelp("Create a new role app:role:create -r rolename .( exemple : ROLE_USER,..) .");
    }

    /**
     * @param InputInterface
     * @param OutputInterface
     * @throws \LogicException
     */
    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $app     = $this->getHelper("app")->getApplication();
        $role = new Role();
        $role->setName($input->getOption('role'));
        $errors = $app["validator"]->validate($role);
        if (count($errors) > 0) {
            $output->writeln("Errors ! new role not created.");
            foreach ($errors as $error) {
                $output->writeln($error->getPropertyPath()." : ".$error->getMessage());
            }
            return;
        }
        $app["role_service"]->save($role);
        $output->writeln("Role {$role->getName()} created!");
    }


}

