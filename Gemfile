source 'https://rubygems.org'

ruby '2.2.1'

gem 'foreman','~> 0.78.0'
gem 'rack','~> 1.6.4'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# Use friendly_id for slugs
gem 'friendly_id', '~> 5.1.0'
# Serialization 
gem 'active_model_serializers', '~> 0.9.3'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# syntax highlighter
gem 'coderay','~> 1.1.0'
# auth tokens
# https://github.com/fnando/tokens
gem 'token','~> 1.2.3'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# respond_to
gem 'responders', '~> 2.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# pagination
gem 'kaminari'

# elastic search
gem 'elasticsearch'

# background jobs
gem 'resque'

group :development, :test do
  gem 'sqlite3'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  # gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :development,:production do
end

group :production do
  gem 'puma', '2.11.1'
  gem 'pg', '~> 0.17'
  gem 'rails_12factor', '~> 0.0'
end
