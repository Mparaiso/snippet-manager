require 'test_helper'

class CategoriesTest < ActionDispatch::IntegrationTest
  fixtures :categories
  def test_list_categories
    get api_categories_url
    assert_response :success
  end

  def test_get_category
    category = categories(:java)
    get api_category_url(category)
    assert_response 200
    puts response.body
    java_cat = JSON.parse(response.body)
    assert_equal java_cat.name,'java'
  end
end