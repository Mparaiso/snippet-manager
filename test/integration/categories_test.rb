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
    json_category = JSON.parse(response.body)
    assert_equal json_category['title'],'Java'
  end

  def test_get_category_by_title
    @category = categories(:php)
    get api_category_url(@category.title)
    assert_response 200
  end

end
