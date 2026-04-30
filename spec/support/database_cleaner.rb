require 'database_cleaner/active_record'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before do |example|
    DatabaseCleaner.strategy = example.metadata[:type] == :system ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.append_after do
    DatabaseCleaner.clean
  end
end
