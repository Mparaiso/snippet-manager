<?php
use Command\ListServicesCommand;
use Command\CreateRoleCommand;
use Command\CreateUserCommand;
use Command\InitAclCommand;
use Helper\ApplicationHelper;

/**
 * @author M.Paraiso
 */
use Doctrine\DBAL\Tools\Console\Helper\ConnectionHelper;

use Doctrine\ORM\Tools\Console\Helper\EntityManagerHelper;

use Symfony\Component\Console\Helper\HelperSet;

use Doctrine\ORM\Tools\Console\ConsoleRunner;

use Symfony\Component\Console\Application;
//@note @symfony créer une application console , en lighe de commandes
class Console extends Application {
	function __construct(\Silex\Application $app){
		$this->app = $app;
		parent::__construct("Snippet Manager Console","0.0.1");
		#@note @doctrine utiliser les commandes doctrine dans une application silex
		$this->setHelperSet(new HelperSet(array(
				"app"=>new ApplicationHelper($this->app),
				"em"=> new EntityManagerHelper($this->app["em"]),
				"db"=>new ConnectionHelper($this->app["em"]->getConnection()),
				)
		));
        $this->addCommands(
            array(new ListServicesCommand,new InitAclCommand,new CreateUserCommand,new CreateRoleCommand)
        );
        ConsoleRunner::addCommands($this);

	}
}