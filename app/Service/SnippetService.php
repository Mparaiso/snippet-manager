<?php

namespace Service;


use Mparaiso\CodeGeneration\Service\EntityService;
use Symfony\Component\Security\Core\SecurityContext;
use Symfony\Component\Security\Acl\Dbal\AclProvider;
use Doctrine\ORM\EntityManager;


class SnippetService extends EntityService{
    /**
     * @var \Symfony\Component\Security\Acl\Dbal\AclProvider
     */
    var $aclProvider;
    /**
     * @var \Symfony\Component\Security\Core\SecurityContext
     */
    var $securityContext;
    /**
     * @param \Doctrine\ORM\EntityManager $em
     * @param $entityClass
     * @param \Symfony\Component\Security\Acl\Dbal\AclProvider $aclProvider
     */
    function __construct(EntityManager $em, $entityClass/*,AclProvider $aclProvider*/,SecurityContext $securityContext){
        parent::__construct($em,$entityClass);
//        $this->aclProvider = $aclProvider;
        $this->securityContext = $securityContext;
    }
    /**
     * FR : sauve un snippet
     * @param $entity
     * @return mixed
     */
    function save($entity)
    {
        if(NULL===$entity->getCreatedAt())
            $entity->setCreatedAt(new \DateTime);
        $entity->setUpdatedAt(new \DateTime);
        $entity->setUser($this->securityContext->getToken()->getUser());
        $this->em->persist($entity);
        $this->em->flush();
        /*$objectIdentity = ObjectIdentity::fromDomainObject($entity);
        $acl = $this->aclProvider->createAcl($objectIdentity);
        $user = $this->securityContext->getToken()->getUser();
        $securityIdentity = UserSecurityIdentity::fromAccoun($user);
        $acl->insertObjectAce($securityIdentity,MaskBuilder::MASK_OWNER);
        $this->aclProvider->updateAcl($acl);*/
        return $entity;
    }

}
