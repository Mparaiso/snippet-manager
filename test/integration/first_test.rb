require 'test_helper'

class FirstTest < ActionDispatch::IntegrationTest
  def test_root
    get root_url
    assert_equal 200,status
  end
end
