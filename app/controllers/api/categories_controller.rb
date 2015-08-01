class Api::CategoriesController < Api::BaseController

  respond_to :json

  def index
    respond_with Category.all
  end

  # find category by id or title
  def show
    @category = Category.find_by_id_or_by_title(params[:id])
    respond_with @category
  end
end
