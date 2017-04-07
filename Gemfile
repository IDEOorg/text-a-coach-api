source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Production webserver
gem 'puma'

# Respond to CORS preflight OPTIONS requests
gem 'rack-cors', '~> 0.4.0'

# Serialize models to JSON consistently
gem 'active_model_serializers', '~> 0.10.2'

# Taggable models
gem 'acts-as-taggable-on', '~> 4.0'

# Searchable models
gem 'pg_search', '~> 1.0.6'

# Paging
gem 'will_paginate', '~> 3.1.0'

# CMS
gem 'activeadmin', github: 'activeadmin'
gem 'devise', '~> 4.2'

# JSON Web Tokens for Smooch
gem 'jwt'
gem 'httparty', '~> 0.14'

# Mixpanel
gem 'mixpanel-ruby', '~> 2.2.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :production do
  # logs directed to stdout and dev/prod parity while delivering assets
  gem 'rails_12factor'
  gem 'exception_notification'
  gem 'slack-notifier'
end
