<?php

namespace Mparaiso\SimpleRest\Controller;

use Bootstrap;
use Silex\WebTestCase;
use Symfony\Component\HttpKernel\HttpKernel;

class ControllerTest extends WebTestCase
{


    /**
     * Creates the application.
     *
     * @return HttpKernel
     */
    public function createApplication()
    {
        return Bootstrap::getApp();
    }

    function provider()
    {
        $now = new \DateTime();
        return array(
            array(
                array("title"         => "snippet1",
                      "description"   => "snippet2",
                      "content"       => "content",
                      "prettyContent" => "prettyContent",
                      "created_at"    => $now->format("r"),
                      "updated_at"    => $now->format("r"),
                      "category_id"   => 1
                )
            )
        );
    }

    /**
     * On test le Controller Rest
     * @dataProvider provider
     */
    function testMethods($snippet)
    {
        // on crée un snippet
        $client = $this->createClient();
        $crawler = $client->request("POST", "/api/snippet", array(), array(),
            array("HTTP_Content-Type" => "application/json"), json_encode($snippet));
        $content = $client->getResponse()->getContent();
        $json = json_decode($content, TRUE);
        $this->assertEquals(array("status" => "ok", "id" => 1), $json);
        $id = $json["id"];
        // or retrouve la liste des snippets
        $client->request("GET", "/api/snippet");
        $content = $client->getResponse()->getContent();
        $json = json_decode($content, TRUE);
        $this->assertCount(1, $json['snippets']);
        $this->assertEquals("snippet1", $json['snippets'][0]["title"]);
        // on met à jour un snippet
        $newTitle = "new title";
        $json['snippets'][0]["title"] = $newTitle;
        $client->request("POST", "/api/snippet/1", array(), array(), array(),
            json_encode($json['snippets'][0]));
        $content = $client->getResponse()->getContent();
        $this->assertTrue($client->getResponse()->isOk());
        $json = json_decode($content, TRUE);
        $this->assertEquals(1, $json['rowsAffected']);
        // on retrouve l'élement mis à jour
        $client->request("GET", "/api/snippet/1");
        $content = $client->getResponse()->getContent();
        $this->assertTrue($client->getResponse()->isOk());
        $json = json_decode($content, TRUE);
        $this->assertEquals($newTitle, $json['snippet']["title"]);
        // on efface un snippet
        $client->request("DELETE", "/api/snippet/1");
        $content = $client->getResponse()->getContent();
        $this->assertTrue($client->getResponse()->isOk());
        $json = json_decode($content, TRUE);
        $this->assertEquals(1, $json["rowsAffected"]);
        // on s'assure que le snippet n'existe plus
        $client->request("GET", "/api/snippet/1");
        $content = $client->getResponse()->getContent();
        $this->assertFalse($client->getResponse()->isOk());
        $this->assertEquals(404, $client->getResponse()->getStatusCode());

    }
}
