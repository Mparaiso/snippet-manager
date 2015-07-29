class StaticpagesController < ApplicationController
  def index
    render plain: 'snippet-manager'
  end
end
