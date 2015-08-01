class Api::SessionsController < Api::BaseController

  def create
    user = User.find_by(email:session_params['email'])
    if user && user.authenticate(session_params['password'])
      user.create_auth_token! if not user.has_valid_auth_token?
      @current_user = user
      respond_with :api,user
    else
      respond_with({error:'Forbidden'}, status: 403,location: :api_sessions)
    end
  end

  def destroy
    current_user.delete_auth_token
    head 200
  end

  private
  def session_params
    params.require(:session).permit(:email,:password)
  end
end
