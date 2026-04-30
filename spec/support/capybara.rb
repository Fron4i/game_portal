require 'capybara/rails'
require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.javascript_driver = :selenium_chrome_headless
Capybara.default_max_wait_time = 5
