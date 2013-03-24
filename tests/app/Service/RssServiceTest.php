<?php

namespace Service;

use PHPUnit_Framework_TestCase;

/**
 * integration test
 */
class RssServiceTest extends PHPUnit_Framework_TestCase
{
    protected $app;
    /**
     * @var \Service\RssService
     */
    protected $rssService;
    public function setUp()
    {
        $this->app = getApp();
        $this->app->boot();
        $this->rssService = $this->app["rss_service"];
    }

    public function testConstruct()
    {
        $this->assertNotNull($this->app["rss_service"]);
        $this->assertInstanceOf('\Service\RssService', $this->app["rss_service"]);
    }

    public function testGenerate()
    {
        $category = "PHP";
        $feed = $this->rssService->generate($category);
        $this->assertInternalType("string",$feed);
        print($feed);
    }
}