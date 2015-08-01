module Concerns
  module Authentication

  protected
    # current_user gets the current user
    def current_user
      @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
      if @current_user and @current_user.has_valid_auth_token?
        @current_user
      end
    end

    # returns true if current_user
    def is_fully_authenticated?
      not current_user.nil?
    end

    def must_be_fully_authenticated
      if not is_fully_authenticated?
        respond_with({error:'Unauthorized'},status:403,location: request.url)
      end
    end

  end
end
