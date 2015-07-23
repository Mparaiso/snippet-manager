<?php
namespace Console\Helper;

use Silex\Application;

use Symfony\Component\Console\Helper\Helper;

class ApplicationHelper extends Helper{
	/**
	 * @return Application
	 */
	function getApplication(){
		return $this->app;
	}
	function __construct(Application $app){
		$this->app = $app;
	}
	public function getName() {
		return "app";

	}

}