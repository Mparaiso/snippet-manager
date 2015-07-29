require 'test_helper'

class SnippetsTest < ActionDispatch::IntegrationTest

  fixtures :snippets

  def test_list_snippets
    get api_snippets_url
    assert_response :success
  end

  def test_create_snippets
    post api_snippets_url,snippet:{title:'First Snippet',content:'First Snippet Content'}
    assert_response :success
  end

  def test_create_snippets_failure
    post api_snippets_url,snippet:{title:'Snippet with no content'}
    assert_response 422
  end

  def test_show_snippet
    snippet = snippets(:default_snippet)

    get api_snippet_url(snippet)
    assert_response :success
  end

  def test_update_snippet
    snippet = snippets(:default_snippet)

    patch api_snippet_url(snippet),snippet:{title:'New Title For snippet'}
    assert_response :success
  end

  def test_delete_snippet
    snippet = snippets(:default_snippet)

    delete api_snippet_url(snippet)
    assert_response :success
  end

end
