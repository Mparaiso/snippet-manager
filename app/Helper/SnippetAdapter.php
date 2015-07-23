<?php

namespace Helper;

use Mparaiso\Rss\Adapter\IChannelAdapter;
use Symfony\Component\Routing\Generator\UrlGenerator;
use Exception;

class SnippetAdapter implements IChannelAdapter
{

    protected $generator;

    function __construct(UrlGenerator $generator)
    {
        $this->generator = $generator;
    }

    /**
     * convert a model to an associative array
     * @param $data
     * @return mixed
     */
    function toChannel($data)
    {
        if ($data instanceof \Entity\Category) {
            $channel["title"]       = $data->getTitle();
            $channel["description"] = $data->getDescription();
            $channel["language"]    = "en-en";
            $channel["link"]        = $this->generator->generate("home", array("category" => urlencode($data->getTitle())), TRUE);
            $channel["guid"]        = $channel["link"];
            $channel["language"]    = "en-en";
            foreach ($data->getSnippets() as $snippet) {
                /* @var $snippet \Entity\Snippet */
                $channel["items"][] = array(
                    "title"       => $snippet->getTitle(),
                    "description" => $snippet->getDescription(),
                    "pubDate"     => $snippet->getCreatedAt(),
                    "link"        => $this->generator->generate("snippet", array('title' => urlencode($snippet->getTitle())), TRUE),
                );
            }
            /* trie les snippet dans l'ordre de date décroissant */
            uasort($channel['items'], function ($a, $b) {
                if ($a['pubDate'] == $b['pubDate']) return 0;
                return $a['pubDate'] < $b['pubDate'] ? 1 : -1;
            });
        } elseif (is_array($data)) {
            $channel["title"]       = "Snippet Manager";
            $channel["description"] = "Manage your snippets online";
            $channel["language"]    = "en-en";
            $channel['link']        = $this->generator->generate("home", array(), TRUE);
            $channel['guid']        = $channel['link'];
            foreach ($data as $snippet) {
                /* @var $snippet \Entity\Snippet */
                $channel["items"][] = array(
                    "title"       => $snippet->getTitle(),
                    "description" => $snippet->getDescription(),
                    "pubDate"     => $snippet->getCreatedAt(),
                    "link"        => $this->generator->generate("snippet", array('title' => urlencode($snippet->getTitle())), TRUE),

                );
            }
        } else {
            throw new Exception('Cant parse data, must be a \Entity\Category or an array of snippets');
        }
        return $channel;
    }

    /**
     * convert channel back to a model
     * @param $channel
     * @return mixed
     */
    function toModel($channel)
    {
        // TODO: Implement toModel() method.
    }

    public function getGenerator()
    {
        return $this->generator;
    }

    public function setGenerator($generator)
    {
        $this->generator = $generator;
    }
}