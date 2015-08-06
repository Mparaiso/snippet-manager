module Concerns

  module TokenAuthenticable

    # expects a field called auth_token as string

    # create_auth_token creates an auth_token and save the user model
    def create_auth_token!(expires_at=Time.now+30.days)
      salt = Time.now.to_i
      self.auth_token = Base64.strict_encode64(Token.generate(self.id+salt,expires_at))
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
          token = Base64.strict_decode64(self.auth_token)
          Token.verify(token)
          true
        else
          false
        end
      rescue Exception => e
        false
      end
    end

  end

end