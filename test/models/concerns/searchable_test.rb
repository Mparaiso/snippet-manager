require 'test_helper'

class SearchableTest < ActiveSupport::TestCase
  fixtures :categories,:users
  test 'when a snippet is persisted, it should be indexed by elastic search' do
    @category = categories(:php)
    @user = users(:one)
    snippet = Snippet.new
    snippet.user = @user
    snippet.category =@category
    snippet.title = 'A title'
    snippet.description = 'A description'
    snippet.content = 'Some snippet content'
    assert snippet.save
  end

  teardown do
    Snippet.clean_up_elastic_search
  end
end
