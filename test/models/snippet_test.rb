require 'test_helper'

class SnippetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'when to_elastic_body is called it returns the right hash' do  
snippet =Snippet.new
attributes={id:1,title:'title',content:'content',description:'description',created_at:Time.now,updated_at:Time.now}
snippet.attributes = attributes
assert_equal attributes,snippet.to_elastic_search_body
  end
end
