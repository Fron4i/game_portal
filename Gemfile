source "https://rubygems.org"

gem "rails", "~> 8.1.3"
gem "sprockets-rails"
gem "dartsass-sprockets"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "image_processing", "~> 1.2"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[windows jruby]

gem "devise"
gem "pundit"
gem "sidekiq"
gem "redis", "~> 5"
gem "friendly_id", "~> 5.5"
gem "pagy", "~> 9.0"
gem "jsonapi-serializer"
gem "activeadmin", "~> 3.5"

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "dotenv-rails"
end

group :development do
  gem "web-console"
  gem "letter_opener"
  gem "bullet"
  gem "brakeman", require: false
  gem "bundler-audit", require: false
  gem "rubocop-rails-omakase", require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webmock"
  gem "shoulda-matchers"
  gem "database_cleaner-active_record"
  gem "pundit-matchers"
end
