class User < ActiveRecord::Base

  include Concerns::TokenAuthenticable

  has_many :snippets
  has_secure_password

  validates :email, presence: true, length:{minimum:7,maximum:255}
  validates :nickname,presence: true,length:{minimum:5,maximum:255}

  #TODO write documentation for method
  def can_access_complete_credentials_of(user)
    return self.id == user.id
  end





end
