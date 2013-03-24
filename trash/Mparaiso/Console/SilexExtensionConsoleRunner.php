<?php
namespace Mparaiso\Console;

use Symfony\Component\Console\Application as Console;
use Silex\Application;

class SilexExtensionConsoleRunner
{
            static function addCommands(Console $cli,Application $app){
                if(NULLL===$cli->getHelperSet())
                    $cli->setHelperSet(new HelperSet);

                $cli->getHelperSet()->addHelper();     #@TODO fix it
                $cli->addCommands(array());
            }
}