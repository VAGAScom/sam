# frozen_string_literal: true

require 'bundler/setup'
require 'sam'

require 'simplecov'

SimpleCov.start

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.mock_with :rspec do |m|
    m.verify_partial_doubles = true
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.example_status_persistence_file_path = '.rspec_status'

  config.profile_examples = 2

  config.order = :random
end
