source 'https://rubygems.org'

ruby '2.2.1'

# for spree on heroku
gem 'rails_12factor', group: :production

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use postgresql as the database for Active Record
gem 'pg'

gem 'bootstrap-sass', '~> 3.3.4'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'deface', github: 'spree/deface'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'dotenv-rails', :require => 'dotenv/rails-now'

  gem 'quiet_assets'

  gem 'rspec-rails', '~> 3.0'

end

# for image storage
gem 'aws-sdk', '< 2.0'

gem 'spree', '3.0.1'
gem 'spree_gateway', github: 'spree/spree_gateway', branch: '3-0-stable'
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: '3-0-stable'

gem 'spree_simple_tax_by_zip', :git => "https://github.com/radamnyc/spree_simple_tax_by_zip.git"
gem 'spree_product_packages', :git => "https://github.com/radamnyc/spree_product_packages.git"
gem 'spree_build_your_babe', :git => "https://#{ENV['GIT_AUTH_TOKEN']}:x-oauth-basic@github.com/TheTBar/tbar_build_your_babe.git"
gem 'spree_paypal_express', github: 'spree-contrib/better_spree_paypal_express', branch: '3-0-stable'


#gem 'spree_product_assembly', github: 'radamnyc/spree-product-assembly', branch: '3-0-stable'
