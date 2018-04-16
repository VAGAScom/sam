# frozen_string_literal: true

require 'hanami/cli'

module Sam
  module CLI
    module Commands
      extend Hanami::CLI::Registry

      require_relative 'cli/version'

      register 'version', Version
      begin
        gem 'unicorn'
        require_relative 'unicorn'
        require_relative 'cli/unicorn'
        register 'unicorn' do |cmd|
          cmd.register 'start', Unicorn::Spawner
          cmd.register 'stop', Unicorn::Reaper
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
        require_relative 'cli/puma'
        register 'puma' do |cmd|
          cmd.register 'start', Puma::Spawner
          cmd.register 'stop', Puma::Reaper
          # cmd.register 'stop', Puma::Reaper
        end
      rescue Gem::LoadError
        warn 'Puma not found. Not loading puma commands'
      end
    end
  end
end
