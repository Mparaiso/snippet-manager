class Api::SearchController < ApplicationController

  # create creates a new search and display a list of matched snippets
  def create
    @snippets = Snippet.search(search_params[:query])
    @snippets = Snippet.page(params[:page])
    respond_with @snippets,short_form:true,meta:{pagination:app_paginator(@snippets)}
  end

  private 

  def search_params
    params.require(:search).permit(:query)
  end

end
