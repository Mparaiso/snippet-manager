class Api::CategoriesController < ApplicationController

  respond_to :json

  def index
    respond_with Category.all
  end

  def show
    respond_with Category.find(params[:id])
  end
end
