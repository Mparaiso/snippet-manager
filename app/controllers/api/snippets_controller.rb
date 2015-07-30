class Api::SnippetsController < Api::BaseController

  def index
    respond_with Snippet.all
  end

  def create
    snippet = Snippet.new(snippet_params)
    snippet.save
    respond_with :api,snippet
  end

  def show
    respond_with Snippet.find(params[:id])
  end

  def update
    snippet= Snippet.find(params[:id])
    snippet.update(snippet_params)
    respond_with status: 204
  end

  def destroy
    Snippet.find(params[:id]).destroy
    respond_with status:204
  end

  private
  def snippet_params
    params.require(:snippet).permit(:title,:content)
  end

end
