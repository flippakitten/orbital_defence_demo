source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'rails', '~> 5.2.3'
gem 'active_model_serializers'
gem 'puma', '~> 4.3', '>= 4.3.1'
gem 'jbuilder', '~> 2.5'
gem 'faraday', '~> 0.15.3'
gem 'geokit-rails', git: 'https://github.com/flippakitten/geokit-rails.git', branch: 'add_cockroachdb_connection'
gem 'sidekiq', '~>5.2.3'
# gem 'redis', '~> 4.0'
gem 'sidekiq-scheduler', '~> 3.0.0'
gem 'rack', '>= 2.0.6'
# Use Redis adapter to run Action Cable in production
gem 'redis-rails', '>= 5.0.2'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'pg', '>= 0.18', '< 2.0'
gem 'activerecord-cockroachdb-adapter', '~> 0.2.3'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rspec_junit_formatter'
  gem 'factory_bot_rails', '>= 5.1.1'
  gem 'rspec-rails', '>= 3.9.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
