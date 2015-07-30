class Api::UsersController < Api::BaseController

  before_action :must_be_fully_authenticated

  def show
    respond_with User.find(params[:id])
  end
end
