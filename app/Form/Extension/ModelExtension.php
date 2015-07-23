<?php

namespace Form\Extension;

use Doctrine\DBAL\Connection;
use Symfony\Component\Form\AbstractExtension;

class ModelTypeExtension extends AbstractExtension
{
    protected $connection;

    public function __construct(Connection $connection)
    {
        $this->$connection = $connection;
    }

    protected function loadTypes()
    {
        return array(
            new ModelType($this->connection),
        );
    }

    protected function loadTypeGuesser()
    {
        return new ModelTypeGuesser($this->connection);
    }
}