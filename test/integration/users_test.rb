require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest

  fixtures :users

  def setup
    @user = users(:one)
  end

  def test_create_user_successfully
    assert_difference 'User.count' do
      post api_users_url(format: :json),user:{email:'bobdoe@example.com',
                                              nickname:'bobdoe',
                                              password:'password',
                                              password_confirmation:'password'}
      assert_response :success
    end
  end

  test "when user without token gets /api/users/id , it doesn't display credentials" do
    get api_user_url(@user)
    assert_response :success
  end

  test "when user with token gets /api/users/:id , it displays credentials" do 
    @user.create_auth_token!
    get(api_user_url(@user),{},{Authorization: @user.auth_token})
    assert_response :success
    assert_not_nil deserialized_response['user']['auth_token']
  end

  test "when user with expired token gets /api/users/:id , it doesn't display credentials" do
    @user.create_auth_token!(Time.now - 2.days)
    get(api_user_url(@user),{},{Authorization: @user.auth_token})
    assert_response :success
    assert_nil deserialized_response['user']['auth_token']
  end

end
