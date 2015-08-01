class User < ActiveRecord::Base

  has_many :snippets
  has_secure_password

  validates :email, presence: true, length:{minimum:7,maximum:255}
  validates :nickname,presence: true,length:{minimum:5,maximum:255}

  def can_access_complete_credentials_of(user)
    return self.id == user.id 
  end

  # create_auth_token creates an auth_token and save the user model
  def create_auth_token!(expires_at=nil)
    expires_at ||= Time.now + 30.days
    self.auth_token = Base64.encode64(Token.generate(self.id,expires_at))
    self.save
  end

  # delete_auth_token deletes an auth_token
  def delete_auth_token!
    self.auth_token = nil
    self.save
  end

  def has_valid_auth_token?
    begin
      if not self.auth_token.nil?
        token = Base64.decode64(self.auth_token)
        Token.verify(token)
        true
      else
        false
      end
    rescue Token::Error => e
      false
    end
  end

end
