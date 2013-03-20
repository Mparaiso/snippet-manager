<?php

namespace Mparaiso\CodeGeneration\Service;

class CrudWriterService
{
    function __construct(array $options = array())
    {

    }

    function generate($job)
    {
        $job->init($this);
        $job->execute($this);
    }
}