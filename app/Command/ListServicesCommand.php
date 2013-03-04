<?php

namespace Command ;

use Symfony\Component\Console\Output\OutputInterface;

use Symfony\Component\Console\Input\InputInterface;

use Symfony\Component\Console\Command\Command;

/**
 * FR : affiche la liste de tout les services enregistrés dans le conteneur de service Pimple
 * EN : list all Pimple registered services.
 * @author M.Paraiso
 */
class ListServicesCommand extends Command{

	/**
	 *
	 */
	protected function configure() {
		$this->setName("app:services:list")
			->setDescription("List registered services");
	}


	/**
	 * @param InputInterface $input
	 * @param OutputInterface $output
	 * @throws \LogicException
	 */
	protected function execute(InputInterface $input, OutputInterface $output) {
		$app = $this->getHelper("app")->getApplication();
		$services = $app->keys();
		$app->boot();
		$output->writeln("Application services : ");
		foreach($services as $service){
			try{
				if(is_string($app[$service]) || is_int($app[$service]) || is_bool($app[$service])){
					$className = "[string] ".$app[$service];
				}elseif(is_array($app[$service])){
					$className = "[array] ";
				}else{
					$className ="[ ".get_class($app[$service])." ]";
				}
			}catch(\Exception $e){
				$className = "[Error getting className]";
			}
			$output->writeln("$service : $className");
		}

	}


}

