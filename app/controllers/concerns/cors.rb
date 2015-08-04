module Concerns
  # handle CORS requestions in a basic fashion
  module CORS
    def cors
      origin = request.headers['Origin']
      if ALLOWED_HOSTS.any? { |r| r.match(origin) }
        headers["Access-Control-Allow-Origin"] = origin
        headers["Access-Control-Allow-Methods"] = %w{GET POST PUT DELETE}.join(",")
        headers["Access-Control-Allow-Headers"] =
          %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token Authorization}.join(",")
      end
      head(:ok) if request.request_method == "OPTIONS"
      # or, render text: ''
      # if that's more your style
    end

    private

    ALLOWED_HOSTS = [/^https\:\/\/\w+\.github.io\/?$/,/^http\:\/\/localhost(\:\d+)?\/?$/]

  end
end
