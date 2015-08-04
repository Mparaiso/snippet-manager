require 'test_helper'

class Api::BaseControllerTest < ActionController::TestCase
  test 'show' do
    get :show,{format: :json}
    assert_response :success
  end
end
