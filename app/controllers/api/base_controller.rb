class Api::BaseController < ApplicationController 

  # protect_from_forgery with: :null_session
  #
  # content negocation for respond_with
  respond_to :json

  include Concerns::Authentication 

end
