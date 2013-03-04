<?php

namespace Service;

use Symfony\Component\Security\Core\Encoder\EncoderFactory;

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

	function register(User $user,$role=RoleService::USER){
		$user->setActive(true);
		$user->setCreatedAt(new \DateTime);
		$user->setUpdatedAt(new \DateTime);
		$user->setRole(array($role));
		$user->setSalt(md5(date("Y-m-d H:i:s")));
		$password = $this->encoder->getEncoder(new \Model\User($user))->encodePassword($user->getPasswordHash(), $user->getSalt());
		$user->setPasswordHash($password);
		$this->em->persist($user);
		$this->em->flush();
		return $user;
	}

	function save(User $user){
		if(NULL===$user->getCreatedAt())
			$user->setCreatedAt(new \DateTime);
		$user->setUpdatedAt(new \DateTime);
	}
}