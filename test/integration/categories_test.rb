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
    assert_equal 'Java',json_category['category']['title']
  end

  def test_get_category_by_title
    @category = categories(:php)
    get api_category_url(@category.slug)
    assert_response 200
  end

end
