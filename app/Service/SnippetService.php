<?php

namespace Service;


use Mparaiso\CodeGeneration\Service\EntityService;



class SnippetService extends EntityService{

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
        $this->em->persist($entity);
        $this->em->flush();
        return $entity;
    }


}
