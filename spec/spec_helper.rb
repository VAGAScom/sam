# frozen_string_literal: true

require 'bundler/setup'
require 'simplecov'

SimpleCov.start do
  add_filter { |source| source.lines_of_code <= 4 }
  add_filter { |source| source.filename =~ /spec/ }

  add_group 'CLI Commands', 'lib/sam/commands'
  add_group 'Server Support', 'lib/sam/servers'
end

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

  config.order = :random
end

require_relative 'support/cli'
require 'tty-command'
require 'sam'
