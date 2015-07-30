require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest

  fixtures :users

  def setup
    @user = users(:one)
  end

  def test_unauthorized_user_cannot_access_user_resource
    get api_user_url(@user)
    assert_response 403
  end

  def test_authorized_user_can_access_user_resource
    @user.create_auth_token!
    get(api_user_url(@user),{},{Authorization: @user.auth_token})
    assert_response :success
  end

  def test_user_with_expired_token_cannot_access_user_resource
    @user.create_auth_token!(Time.now - 2.days)
    get(api_user_url(@user),{},{Authorization: @user.auth_token})
    assert_response 403
  end

end
