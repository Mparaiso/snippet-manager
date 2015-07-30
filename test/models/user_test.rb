require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users
  def test_create
    assert_difference 'User.count' do
      User.create!(nickname:'johndoe',
                   email:'johndoe@example.com',
                   password:'password',
                   password_confirmation:'password')
    end
  end

  def test_create_raises
    assert_raise(ActiveRecord::RecordInvalid) do
      User.create!()
    end
  end

  def test_create_auth_token
    user = users(:one)
    user.create_auth_token!
    assert_not_nil user.auth_token
  end

  def test_has_valid_auth_token?
    user=users(:one)
    user.create_auth_token!
    user = User.find_by(:auth_token=>user.auth_token)
    assert_not_nil user
    assert_equal user.has_valid_auth_token?,true
  end


end
