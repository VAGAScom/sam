# frozen_string_literal: true

require 'hanami/cli'
require_relative 'servers/breeder'
require_relative 'servers/predator'

module Sam
  module CLI
    module Commands
      extend Hanami::CLI::Registry

      require_relative 'commands/version'
      require_relative 'commands/spawner'
      require_relative 'commands/reaper'

      register 'version', Version
      register 'start', Spawner
      register 'stop', Reaper

      begin
        gem 'unicorn'
        require_relative 'unicorn'
        require_relative 'commands/unicorn'
        register 'unicorn' do |cmd|
          cmd.register 'reload', Unicorn::Reloader
          cmd.register 'monitor', Unicorn::Monitor
          cmd.register 'run', Unicorn::Runner
        end
      rescue Gem::LoadError
        warn 'Unicorn not found. Not loading unicorn commands'
      end

      begin
        gem 'puma'
        require_relative 'puma'
        require_relative 'commands/puma'
        register 'puma' do |cmd|
          cmd.register 'reload', Puma::Reloader
          cmd.register 'monitor', Puma::Monitor
        end
      rescue Gem::LoadError
        warn 'Puma not found. Not loading puma commands'
      end
    end
  end
end
