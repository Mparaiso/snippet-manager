<?php

class App extends \Silex\Application
{
    public function __construct(array $values = array())
    {
        parent::__construct($values);

        $this->register(new Config);
    }

}
