<?php

namespace Model;


use Mparaiso\SimpleRest\Model\AbstractModel;

class Category extends AbstractModel
{


    protected $id;
    protected $name;

    public function getId()
    {
        return $this->id;
    }

    public function setId($id)
    {
        $this->id = $id;
    }

    public function getName()
    {
        return $this->name;
    }

    public function setName($name)
    {
        $this->name = $name;
    }


    function __toString()
    {
        return $this->name;
    }
}