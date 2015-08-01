require 'test_helper'

class Api::UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:one)
  end

  def test_create
    @new_user={nickname:'samdoe',email:'samdoe@example.com',
               password:'password',password_confirmation:'password'}
    post :create,{user:@new_user,format: :json}
    assert_response :success
  end

  def test_show
    @user.create_auth_token!
    request.headers['Authorization'] = @user.auth_token
    get :show,id:@user.id, format: :json
    assert_response :success
  end
end
