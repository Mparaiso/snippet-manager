require 'test_helper'

class SnippetsTest < ActionDispatch::IntegrationTest

  fixtures :snippets,:users,:categories

  def setup
    @user = users(:one)
    @user.create_auth_token!
    @category = categories(:php)
  end

  def test_list_snippets
    get api_snippets_url
    assert_response :success
    @snippets = JSON.parse(response.body)
    assert_equal 'Hello PHP',@snippets[0]['title']
  end

  def test_authenticated_user_creates_snippets
    post(api_snippets_url,{snippet:{title:'First Snippet',
                                    category_id:@category.id,
                                   content:'First Snippet Content'}},
                                   {Authorization:@user.auth_token})
    assert_response :success
  end

  def test_create_snippets_failure
    post api_snippets_url,{snippet:{title:'Snippet with no content'}},
      {Authorization:@user.auth_token}
    assert_response 422
  end

  def test_show_snippet
    snippet = snippets(:hello_ruby)

    get api_snippet_url(snippet)
    assert_response :success
  end

  def test_update_snippet
    snippet = snippets(:hello_ruby)
    snippet.user= @user
    snippet.save
    patch api_snippet_url(snippet),{snippet:{title:'New Title For snippet'}},
      {Authorization:@user.auth_token}

    assert_response :success
  end

  def test_delete_snippet
    snippet = snippets(:hello_ruby)
    snippet.user = @user
    snippet.save
    delete api_snippet_url(snippet),{},{Authorization:@user.auth_token}
    assert_response :success
  end

end
