source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.8'
gem 'redis', '~> 4.0'
gem 'sidekiq', '~> 7.1', '>= 7.1.4'
gem 'sidekiq-cron', '~> 1.10', '>= 1.10.1'

gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', require: false
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.2'
  gem 'rspec-rails', '~> 6.0', '>= 6.0.3'
  gem 'env', '~> 0.3.0'
end

group :development do
  gem 'rubocop', '~> 1.56', '>= 1.56.4', require: false
end

group :test do
  gem 'shoulda-matchers', '~> 5.3'
end
