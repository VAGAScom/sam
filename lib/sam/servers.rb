# frozen_string_literal: true

module Sam
  module Servers
    PUMA_PID = ->(config) { Sam::Puma::Identifier.new.call(config) }
    UNICORN_PID = ->(config) { Sam::Unicorn::Identifier.new.call(config) }
  end
end

begin
  gem 'unicorn'
  require 'unicorn'
  require_relative 'servers/unicorn/identifier'
rescue Gem::LoadError
end

begin
  gem 'puma'
  require 'puma/cli'
  require_relative 'servers/puma/identifier'
rescue Gem::LoadError
end

require_relative 'servers/breeder'
require_relative 'servers/cloner'
require_relative 'servers/predator'
require_relative 'servers/shepherd'
