<?php

/*
 * This file is part of the Symfony package.
 *
 * (c) Fabien Potencier <fabien@symfony.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Command;

use Symfony\Bundle\FrameworkBundle\Command\ContainerAwareCommand;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Doctrine\DBAL\Schema\SchemaException;

/**
 * Installs the tables required by the ACL system
 *
 * @author Johannes M. Schmitt <schmittjoh@gmail.com>
 * @author M.Paraiso
 */
class InitAclCommand extends ContainerAwareCommand
{
    /**
     * @see Command
     */
    protected function configure()
    {
        $this
            ->setName('init:acl')
            ->setDescription('Mounts ACL tables in the database')
            ->setHelp(<<<EOF
The <info>%command.name%</info> command mounts ACL tables in the database.

<info>php %command.full_name%</info>

ACL will use the connection defined with \Silex\Provider\DoctrineServiceProvider
EOF
            )
        ;
    }

    /**
     * @see Command::execute()
     */
    protected function execute(InputInterface $input, OutputInterface $output)
    {
        /* @var $app \Silex\Application */
        $app = $this->getHelper("app")->getApplication();
        $app->boot();
        $connection = $app['security.acl.dbal.connection'];
        $schema = $app['security.acl.dbal.schema'];

        try {
            $schema->addToSchema($connection->getSchemaManager()->createSchema());
        } catch (SchemaException $e) {
            $output->writeln("Aborting: " . $e->getMessage());

            return 1;
        }

        foreach ($schema->toSql($connection->getDatabasePlatform()) as $sql) {
            $connection->exec($sql);
        }

        $output->writeln('ACL tables have been initialized successfully.');
    }
}
