<?php

namespace Service;


use Doctrine\ORM\EntityManager;
use Entity\User;
use Symfony\Component\Security\Core\Encoder\EncoderFactory;
use Mparaiso\CodeGeneration\Service\EntityService;

class AccountService extends EntityService
{

    function __construct(EntityManager $em,EncoderFactory $encoder, $entityClass = '\Entity\Account')
    {
        parent::__construct($em,$entityClass);
        $this->encoder = $encoder;
    }

    function register(\Entity\Account $account){
        $account->setActive(TRUE);
        $account->setCreatedAt(new \DateTime);
        $account->setUpdatedAt(new \Datetime);
        $role = $this->em->getRepository('\Entity\Role')->findOneBy(array("name"=>"ROLE_USER"));
        $user = new User();
        $user->setUsername($account->getEmail());
        $user->setSalt(md5(date("Y-m-d H:i:s")));
        $user->setPassword($this->encoder->getEncoder($user)->encodePassword($account->getPlainPassword(),$user->getSalt()));
        $user->addRole($role);
        $user->setAccount($account);
        $account->setUser($user);
        $account->setPlainPassword(NULL);
        $this->em->persist($user);
        $this->em->persist($account);
        $this->em->flush();
        return $account;
    }
}