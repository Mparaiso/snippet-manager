require 'test_helper'

class FirstTest < ActionDispatch::IntegrationTest

  fixtures :users

  def setup
    @user = users(:one)
  end

  def test_root
    get root_url
    assert_equal 200,status
  end

  def test_create_session
    # assert_equal @user.auth_token,nil
    post api_sessions_url,{session:{email:@user.email,password:'secret'}}
    assert_response :success
    assert_equal JSON.parse(response.body)['email'],@user.email
    # puts response.body
  end

  def test_create_session_with_wrong_credentials
    post api_sessions_url,{session:{email:@user.email,password:'wrong-password'}}
    assert_response 403
  end
end
