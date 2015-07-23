<?php


namespace Service;

use Mparaiso\Rss\SimpleRss;
use Helper\SnippetAdapter;

class RssService
{

    protected $rssGenerator;

    protected $categoryService;

    protected $snippetService;

    function __construct(SnippetService $snippetService, CategoryService $categoryService, SimpleRss $rssGenerator)
    {
        $this->rssGenerator    = $rssGenerator;
        $this->categoryService = $categoryService;
        $this->snippetService  = $snippetService;
    }

    /**
     * FR : génère un flux RSS à partir d'une categories
     * EN : generate a rss feed according to a category
     * @param string $channel
     */
    function generate($channel = NULL)
    {
        if ($channel != NULL) {
            $data = $this->categoryService
                ->findOneBy(array("title" => $channel));
        } else {
            $data = $this->snippetService
                ->findAll(array(),array("created_at"=>"DESC"));
        }
        $this->rssGenerator->setChannel($data);
        return $this->rssGenerator->generate();
    }

}