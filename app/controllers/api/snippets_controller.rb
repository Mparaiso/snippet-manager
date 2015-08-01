class Api::SnippetsController < Api::BaseController

  respond_to :json

  before_action :must_be_fully_authenticated, except:[:index,:show]

  def index
    if params[:user_id]
      @snippets = User.find(params[:user_id]).snippets.all
    elsif params[:category_id]
      @snippets = Category.find_by_id_or_by_title(params[:category_id]).snippets.all
    else
      @snippets = Snippet.all
    end
    respond_with @snippets
  end

  def create
    if params[:category_id]
      @snippet = Category.find_by_id_or_by_title(params[:category_id]).snippets.build(snippet_params)
      @snippet.user = current_user
    else
      @snippet = current_user.snippets.build(snippet_params)
    end
    if @snippet.save
      HighlightSnippetContentJob.perform_later @snippet
    end
    respond_with :api,@snippet
  end

  def show
    if params[:user_id]
      @snippet =User.find(params[:user_id]).snippets.find(params[:id])
    elsif params[:category_id]
      @snippet = Category.find_by_id_or_by_title(params[:category_id]).snippets.find(params[:id])
    else
      @snippet = Snippet.find(params[:id])
    end
    respond_with @snippet
  end

  def update
    @snippet= current_user.snippets.find(params[:id])
    @snippet.update(snippet_params)
    HighlightSnippetContentJob.perform_later @snippet
    respond_with status: 204
  end

  def destroy
    current_user.snippets.find(params[:id]).destroy
    respond_with status:204
  end

  private
  def snippet_params
    params.require(:snippet).permit(:title,:content,:category_id)
  end

end
