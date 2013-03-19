<?php

namespace Command;

use Symfony\Component\Console\Output\OutputInterface;
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
class CreateUserCommand extends Command
{

    /**
     *
     */
    protected function configure()
    {
        $this->addOption("email", "e", InputOption::VALUE_REQUIRED, "email of the user")
            ->addOption("username", "u", InputOption::VALUE_REQUIRED, "username of the user")
            ->addOption("password", "p",  InputOption::VALUE_REQUIRED, "user password")
            ->addOption("role", "r",  InputOption::VALUE_REQUIRED, "role of the user")
            ->setName("app:user:create")
            ->setDescription("Create a new user")
            ->setHelp("Create a new user -e email -u username -p password -r role .");
    }

    /**
     * @param InputInterface
     * @param OutputInterface
     * @throws \LogicException
     */
    protected
    function execute(InputInterface $input, OutputInterface $output)
    {
        $app     = $this->getHelper("app")->getApplication();
        $account = new Account();
        $account->setPlainPassword($input->getOption(("password")));
        $account->setEmail($input->getOption("email"));
        $account->setUsername($input->getOption(("username")));
        $errors = $app["validator"]->validate($account);
        if (count($errors) > 0) {
            $output->writeln("Errors ! new User not created.");
            foreach ($errors as $error) {
                $output->writeln($error->getPropertyPath()." : ".$error->getMessage());
            }
            return;
        }
        $app["account_service"]->register($account);
        $user   = $account->getUser();
        if ($input->getOption("role")) {
            $role = $app["role_service"]->findOneBy(array("name" => $input->getOption("role")));
            if ($role!==null) {
                $user->addRole($role);
                $app["user_service"]->save($user);
            } else {
                $output->writeln("No role specified , using the default role ROLE_USER");
            }
        }

    }


}

