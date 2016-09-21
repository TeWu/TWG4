source 'https://rubygems.org'


gem 'rails', '~> 5.0.0'
gem 'pg', '~> 0.18'


gem 'puma', '~> 3.0' # Use Puma as the app server
gem 'sass-rails', '~> 5.0' # Use SCSS for stylesheets
gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '~> 4.2' # Use CoffeeScript for .coffee assets and views

# gem 'therubyracer', platforms: :ruby   WARNING NOTE: Install node.js instead  # See https://github.com/rails/execjs#readme for more supported runtimes

gem 'jquery-rails' # Use jquery as the JavaScript library
gem 'turbolinks', '~> 5' # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'jbuilder', '~> 2.5' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem


group :development, :test do
  gem 'byebug', platform: :mri # Call 'byebug' anywhere in the code to stop execution and get a debugger console
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'better_errors' # WARNING: this gem MUST stay in :development group
  gem 'binding_of_caller' # For advanced features of better_errors gem
  gem 'pry-rails', '~> 0.3' # Use Pry REPL as Rails console

  gem 'rack-livereload', '>= 0.3.16' # see below
  gem 'guard-livereload', '>= 2.5.2' # Auto-reload browser when file change (no browser extensions needed, thanks to rack-livereload gem). WARNING: Versions before 2.5.2 have security vulnerability.
end

gem 'memoist' # For method memoization

gem 'argon2' # Password hashing with Argon2 - OWASP recommended algorithm and the Password Hashing Competition winner https://github.com/P-H-C/phc-winner-argon2
gem 'cancancan', github: 'TeWu/cancancan', branch: 'develop' # For authorization. Using develop branch for as much Rails 5 support as possible.

# Forms related gems
gem 'simple_form'
gem 'client_side_validations', github: 'TeWu/client_side_validations', branch: 'rails5'
gem 'client_side_validations-simple_form', github: 'TeWu/client_side_validations-simple_form', branch: 'rails5_with_nested_wrappers'

gem 'mini_magick' # For image processing
gem 'carrierwave' # For image upload and processing automation

gem 'stringex' # For pretty url id segments

gem 'kaminari' # For pagination

gem 'autoprefixer-rails' # Adds vendor prefixes to CSS rules, using the Asset Pipeline
gem 'bootstrap-sass' # Bootstrap framework
