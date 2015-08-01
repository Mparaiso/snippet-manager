class Api::UsersController < Api::BaseController

  def create
    @user = User.new(user_params)
    @user.save
    respond_with :api,@user
  end

  def show
    @user= User.find(params[:id])
    respond_with :api,@user
  end

  private
  def user_params
    params.require(:user).permit(:nickname,:email,:password,:password_confirmation)
  end
end
