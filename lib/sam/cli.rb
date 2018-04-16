# frozen_string_literal: true

require 'hanami/cli'

module Sam
  module CLI
    module Commands
      extend Hanami::CLI::Registry

      require_relative 'cli/version'
      require_relative 'cli/unicorn'
      require_relative 'cli/puma'

      register 'version', Version
      if gem 'unicorn'
        register 'unicorn' do |cmd|
          cmd.register 'start', Unicorn::Spawner
          cmd.register 'stop', Unicorn::Reaper
          cmd.register 'reload', Unicorn::Reloader
          cmd.register 'monitor', Unicorn::Monitor
          cmd.register 'run', Unicorn::Runner
        end
      end

      if gem 'puma'
        register 'puma' do |cmd|
          cmd.register 'start', Puma::Spawner
          cmd.register 'stop', Puma::Reaper
          # cmd.register 'stop', Puma::Reaper
        end
      end
    end
  end
end
