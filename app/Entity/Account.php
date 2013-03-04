<?php

namespace Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * Account
 */
class Account
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
    private $email;

    /**
     * @var string
     */
    private $plain_password;

    /**
     * @var boolean
     */
    private $active;

    /**
     * @var \DateTime
     */
    private $created_at;

    /**
     * @var \DateTime
     */
    private $updated_at;

    /**
     * @var \DateTime
     */
    private $last_visit;

    /**
     * @var \Entity\User
     */
    private $user;

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
     * Set username
     *
     * @param string $username
     * @return Account
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
     * Set email
     *
     * @param string $email
     * @return Account
     */
    public function setEmail($email)
    {
        $this->email = $email;
    
        return $this;
    }

    /**
     * Get email
     *
     * @return string 
     */
    public function getEmail()
    {
        return $this->email;
    }

    /**
     * Set plain_password
     *
     * @param string $plainPassword
     * @return Account
     */
    public function setPlainPassword($plainPassword)
    {
        $this->plain_password = $plainPassword;
    
        return $this;
    }

    /**
     * Get plain_password
     *
     * @return string 
     */
    public function getPlainPassword()
    {
        return $this->plain_password;
    }

    /**
     * Set active
     *
     * @param boolean $active
     * @return Account
     */
    public function setActive($active)
    {
        $this->active = $active;
    
        return $this;
    }

    /**
     * Get active
     *
     * @return boolean 
     */
    public function getActive()
    {
        return $this->active;
    }

    /**
     * Set created_at
     *
     * @param \DateTime $createdAt
     * @return Account
     */
    public function setCreatedAt($createdAt)
    {
        $this->created_at = $createdAt;
    
        return $this;
    }

    /**
     * Get created_at
     *
     * @return \DateTime 
     */
    public function getCreatedAt()
    {
        return $this->created_at;
    }

    /**
     * Set updated_at
     *
     * @param \DateTime $updatedAt
     * @return Account
     */
    public function setUpdatedAt($updatedAt)
    {
        $this->updated_at = $updatedAt;
    
        return $this;
    }

    /**
     * Get updated_at
     *
     * @return \DateTime 
     */
    public function getUpdatedAt()
    {
        return $this->updated_at;
    }

    /**
     * Set last_visit
     *
     * @param \DateTime $lastVisit
     * @return Account
     */
    public function setLastVisit($lastVisit)
    {
        $this->last_visit = $lastVisit;
    
        return $this;
    }

    /**
     * Get last_visit
     *
     * @return \DateTime 
     */
    public function getLastVisit()
    {
        return $this->last_visit;
    }

    /**
     * Set user
     *
     * @param \Entity\User $user
     * @return Account
     */
    public function setUser(\Entity\User $user = null)
    {
        $this->user = $user;
    
        return $this;
    }

    /**
     * Get user
     *
     * @return \Entity\User 
     */
    public function getUser()
    {
        return $this->user;
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
}
