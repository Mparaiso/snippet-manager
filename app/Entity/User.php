<?php

namespace Entity;

use Doctrine\ORM\Mapping as ORM;
use Serializable;
use Symfony\Component\Security\Core\User\UserInterface;

/**
 * User
 */
class User implements UserInterface , Serializable
{
    /**
     * @var integer
     */
    private $id;

    /**
     * @var string
     */
    private $username;

    /**
     * @var string
     */
    private $password;

    /**
     * @var string
     */
    private $salt;

    /**
     * @var \Entity\Account
     */
    private $account;

    /**
     * @var \Doctrine\Common\Collections\Collection
     */
    private $snippets;

    /**
     * @var \Doctrine\Common\Collections\Collection
     */
    private $roles;

    /**
     * Constructor
     */
    public function __construct()
    {
        $this->snippets = new \Doctrine\Common\Collections\ArrayCollection();

        $this->roles = new \Doctrine\Common\Collections\ArrayCollection();
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
     * Set username
     *
     * @param string $username
     * @return User
     */
    public function setUsername($username)
    {
        $this->username = $username;
    
        return $this;
    }

    /**
     * Get username
     *
     * @return string 
     */
    public function getUsername()
    {
        return $this->username;
    }

    /**
     * Set password
     *
     * @param string $password
     * @return User
     */
    public function setPassword($password)
    {
        $this->password = $password;
    
        return $this;
    }

    /**
     * Get password
     *
     * @return string 
     */
    public function getPassword()
    {
        return $this->password;
    }

    /**
     * Set salt
     *
     * @param string $salt
     * @return User
     */
    public function setSalt($salt)
    {
        $this->salt = $salt;
    
        return $this;
    }

    /**
     * Get salt
     *
     * @return string 
     */
    public function getSalt()
    {
        return $this->salt;
    }

    /**
     * Set account
     *
     * @param \Entity\Account $account
     * @return User
     */
    public function setAccount(\Entity\Account $account = NULL)
    {
        $this->account = $account;
    
        return $this;
    }

    /**
     * Get account
     *
     * @return \Entity\Account 
     */
    public function getAccount()
    {
        return $this->account;
    }

    /**
     * Add roles
     *
     * @param \Entity\Role $roles
     * @return User
     */
    public function addRole(\Entity\Role $roles)
    {
        $this->roles[] = $roles;
    
        return $this;
    }

    /**
     * Remove roles
     *
     * @param \Entity\Role $roles
     */
    public function removeRole(\Entity\Role $roles)
    {
        $this->roles->removeElement($roles);
    }

    /**
     * Get roles
     *
     * @return \Doctrine\Common\Collections\Collection 
     */
    public function getRoles()
    {
        return $this->roles->toArray();
        //return array("ROLE_USER");
    }
    /**
     * @ORM\PrePersist
     */
    public function eraseCredentials()
    {
        // Add your code here
    }


    /**
     * Add snippets
     *
     * @param \Entity\Snippet $snippets
     * @return Account
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

    /**
     * (PHP 5 &gt;= 5.1.0)<br/>
     * String representation of object
     * @link http://php.net/manual/en/serializable.serialize.php
     * @return string the string representation of the object or null
     */
    public function serialize()
    {
       return serialize(array($this->id));
    }

    /**
     * (PHP 5 &gt;= 5.1.0)<br/>
     * Constructs the object
     * @link http://php.net/manual/en/serializable.unserialize.php
     * @param string $serialized <p>
     * The string representation of the object.
     * </p>
     * @return mixed the original value unserialized.
     */
    public function unserialize($serialized)
    {
        list($this->id,)=unserialize($serialized);
    }
}
