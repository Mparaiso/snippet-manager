<?php

namespace Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * Category
 */
class Category
{
    /**
     * @var integer
     */
    private $id;

    /**
     * @var string
     */
    private $title;

    /**
     * @var string
     */
    private $description;

    /**
     * @var \Doctrine\Common\Collections\Collection
     */
    private $snippets;

    /**
     * Constructor
     */
    public function __construct()
    {
        $this->snippets = new \Doctrine\Common\Collections\ArrayCollection();
    }
    
    /**
     * Get id
     *
     * @return integer 
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Set title
     *
     * @param string $title
     * @return Category
     */
    public function setTitle($title)
    {
        $this->title = $title;
    
        return $this;
    }

    /**
     * Get title
     *
     * @return string 
     */
    public function getTitle()
    {
        return $this->title;
    }

    /**
     * Set description
     *
     * @param string $description
     * @return Category
     */
    public function setDescription($description)
    {
        $this->description = $description;
    
        return $this;
    }

    /**
     * Get description
     *
     * @return string 
     */
    public function getDescription()
    {
        return $this->description;
    }

    /**
     * Add snippets
     *
     * @param \Entity\Snippet $snippets
     * @return Category
     */
    public function addSnippet(\Entity\Snippet $snippets)
    {
        $this->snippets[] = $snippets;
    
        return $this;
    }

    /**
     * Remove snippets
     *
     * @param \Entity\Snippet $snippets
     */
    public function removeSnippet(\Entity\Snippet $snippets)
    {
        $this->snippets->removeElement($snippets);
    }

    /**
     * Get snippets
     *
     * @return \Doctrine\Common\Collections\Collection 
     */
    public function getSnippets()
    {
        return $this->snippets;
    }

    function __toString(){
        return $this->getTitle();
    }
}

