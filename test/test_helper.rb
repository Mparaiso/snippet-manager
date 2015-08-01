ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def api_authorization_header(token)
    request.headers['Authorization'] =  token
  end
end

class ActionDispatch::IntegrationTest

  def deserialized_response
    if request.format == :json
      JSON.parse(response.body)
    end 
  end

end
