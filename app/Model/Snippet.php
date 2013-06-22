<?php


namespace Model;
use Mparaiso\SimpleRest\Model\AbstractModel;

/**
 * Class Snippet
 * @package Model
 */
class Snippet extends AbstractModel 
{
    protected $id;
    protected $title;
    protected $description;
    protected $content;
    protected $prettyContent;
    protected $created_at;
    protected $updated_at;
    protected $category_id;


    public function getTitle()
    {
        return $this->title;
    }

    public function setTitle($title)
    {
        $this->title = $title;
    }

    public function getDescription()
    {
        return $this->description;
    }

    public function setDescription($description)
    {
        $this->description = $description;
    }

    public function getContent()
    {
        return $this->content;
    }

    public function setContent($content)
    {
        $this->content = $content;
    }

    public function getPrettyContent()
    {
        return $this->prettyContent;
    }

    public function setPrettyContent($prettyContent)
    {
        $this->prettyContent = $prettyContent;
    }

    public function getCreatedAt()
    {
        return $this->created_at;
    }

    public function setCreatedAt($created_at)
    {
        $this->created_at = $created_at;
    }

    public function getUpdatedAt()
    {
        return $this->updated_at;
    }

    public function setUpdatedAt($updated_at)
    {
        $this->updated_at = $updated_at;
    }

    public function getCategoryId()
    {
        return $this->category_id;
    }

    public function setCategoryId($category_id)
    {
        $this->category_id = $category_id;
    }

    public function setId($id)
    {
        $this->id = $id;
    }

    public function getId()
    {
        return $this->id;
    }

    function __toString()
    {
        return $this->title;
    }
}