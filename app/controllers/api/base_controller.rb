class Api::BaseController < ApplicationController 

  # protect_from_forgery with: :null_session

  # override defaut error handler with custom one for StandardErrors
  rescue_from StandardError,with: :rescue_from_standard_error 

  # content negocation for respond_with
  respond_to :json

  include Concerns::Authentication 
  include Concerns::CORS
  include Api::BaseHelper
  
  # handle cors headers on OPTION request method
  before_action :cors
  
  # show handles the api root url
  def show
    respond_with({status:'ok'})
  end

  private 
  # rescue_from_standard_error serialize StandardError when in development and when format is not html 
  def rescue_from_standard_error(error)
    if request.format != Mime::HTML and Rails.env != 'production'
      respond_with({error:500,message:'Internal Server Error',exception:error.message},status:500,location:request.url)
    else 
      raise e
    end
  end

end
