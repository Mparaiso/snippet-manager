<?php


namespace Service;

use DateTime;
use Doctrine\DBAL\Connection;
use Model\Snippet;
use Mparaiso\SimpleRest\Model\AbstractModel;
use Mparaiso\SimpleRest\Service\Service;

class SnippetService extends Service
{
    function makeDate(DateTime $datetime)
    {
        return $datetime->format("Y-m-d H:i:s");
    }

    function create(AbstractModel $model)
    {
        /* @var Snippet $model */
        if ($model->getId() != NULL) {
            $model->setId(NULL);
        }
        $model->setCreatedAt($this->makeDate(new DateTime));
        $model->setUpdatedAt($this->makeDate(new DateTime));
        return parent::create($model);
    }

    /**
     * FR : recherche dans les snippets selon une expression
     * @see http://docs.doctrine-project.org/en/latest/reference/query-builder.html
     * @param $search
     * @return array
     */
    function search($search)
    {
        $connection = $this->provider->getConnection();
        /** @var Connection $connection */
        $qb = $connection->createQueryBuilder();
        $qb->select("*")->from("{$this->provider->getName()}", "s")->join("s","category","c","c.id = s.category_id");
        $qb->where("s.title LIKE :search ")
            ->orWhere("s.description LIKE :search ")
            ->orWhere("s.content LIKE :search")
            ->orWhere("c.name LIKE :search");
        $qb->setParameter("search", "%$search%");
        $stmt = $qb->execute();
        @   $result = array();
        while ($model = $stmt->fetchObject($this->provider->getModel())) {
            array_push($result, $model);
        }
        return $result;
    }


}