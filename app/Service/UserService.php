<?php

namespace Service;

use Symfony\Component\Security\Core\Encoder\EncoderFactory;
use Entity\Account;

use Symfony\Component\Security\Core\User\UserProviderInterface;

use Entity\User;

use Doctrine\ORM\EntityManager;

class UserService{
	protected $em;
	protected $entityClass;
	protected $encoder;
	function __construct(EntityManager $em,EncoderFactory $encoder,$entityClass="\Entity\User"){
		$this->em = $em;
		$this->encoder = $encoder;
		$this->entityClass = $entityClass;
	}

	function findAll(){
		return $this->em->getRepository($this->entityClass)->findAll();
	}
	function find($id){
		return $this->em->find($this->entityClass,$id);
	}

	function save(User $user){
		$this->em->persist($user);
		$this->em->flush();
		return $user;
	}
}