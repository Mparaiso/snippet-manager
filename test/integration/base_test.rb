require 'test_helper'

class BaseTest < ActionDispatch::IntegrationTest

  def when_an_options_request_is_sent_with_an_allowed_origin_respond_with_CORS_headers 
    origin = 'http://localhost/'
    process  :options,api_url,{format: :json},{'Origin' => origin}  
    assert_response :success
    assert_equal origin,response.headers['Access-Control-Allow-Origin']
  end

  def when_an_options_request_is_sent_with_an_unallowed_origin_do_not_respond_with_CORS_headers 
    origin = 'http://localhost/'
    process  :options,api_url,{format: :json},{'Origin' => origin}  
    assert_response :success
    assert_nil response.headers['Access-Control-Allow-Origin']
  end

end
