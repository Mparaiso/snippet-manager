class Api::UsersController < Api::BaseController

  before_action :must_be_fully_authenticated,except:[:create]

  def create
    @user = User.new(user_params)
    @user.save
    respond_with :api,@user 
  end

  def show
    @user =User.find(params[:id]) 
    respond_with @user
  end

  private
  def user_params
    params.require(:user).permit(:nickname,:email,:password,:password_confirmation)
  end
end
