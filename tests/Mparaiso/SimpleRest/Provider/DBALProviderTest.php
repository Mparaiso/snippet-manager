<?php
/**
 * @author mparaiso <mparaiso@online.fr>
 */

use DataAccessLayer\DBALProvider;
use Model\Snippet;
use Silex\WebTestCase;
use Symfony\Component\HttpKernel\HttpKernel;

class DBALProviderTest extends WebTestCase
{

    /**
     * {@inheritdoc}
     */
    public function createApplication()
    {
        return Bootstrap::getApp();
    }

    function testPersist()
    {
        // FR : un snippet est crée puis inseré
        $provider = $this->app["snippet_provider"];
        /* @var DBALProvider $provider */
        $now = new \DateTime;
        $data = array("title"         => "snippet1",
                      "description"   => "snippet1",
                      "content"       => "content",
                      "prettyContent" => "prettyContent",
                      "category_id"   => 1,
                      "created_at"    => $now->format("r"),
                      "updated_at"    => $now->format("r")
        );
        $snippet = new Snippet($data);
        $id = $provider->create($snippet);
        $this->assertNotNull($id);
        // FR : on cherche un snippet par id
        $fetched = $provider->find($id);
        /* @var \Model\Snippet $fetched */
        $this->assertEquals($data['title'], $fetched->getTitle());
        // FR : on cherche des snippets par nom
        $snippets = $provider->findBy(array("title" => "snippet1"));
        $this->assertCount(1, $snippets);
        $this->assertEquals($fetched, $snippets[0]);
        $this->assertEquals($data["description"], $snippets[0]->getDescription());
        // FR : on compte le nombre de snippets
        $this->assertEquals(1, $provider->count(array("content" => $data["content"])));
        // FR : on met à jour le snippet
        $prettyContent = "this is the pretty content";
        $fetched->setPrettyContent($prettyContent);
        $rowsAffected = $provider->update($fetched, array("id" => $fetched->getId()));
        $this->assertEquals(1, $rowsAffected);
        $updated = $provider->find($fetched->getId());
        $this->assertEquals($fetched, $updated);

    }
}
