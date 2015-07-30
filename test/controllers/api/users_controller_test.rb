require 'test_helper'

class Api::UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:one)
  end

  def test_show
    @user.create_auth_token!
    request.headers['Authorization'] = @user.auth_token
    get :show,id:@user.id,format: :json
    assert_response :success
  end
end
