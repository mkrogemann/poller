if ENV['COVERAGE'] == 'true' && RUBY_VERSION != '1.8.7'
  require 'simplecov'
end

if ENV['TRAVIS'] == 'true' && RUBY_VERSION != '1.8.7'
  require 'coveralls'
  Coveralls.wear!
end

require 'xml_helpers'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.include XMLHelpers
end
