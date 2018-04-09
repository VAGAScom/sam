# frozen_string_literal: true

require 'hanami/cli'

module Sam
  module CLI
    module Commands
      extend Hanami::CLI::Registry

      require_relative 'cli/version'
      require_relative 'cli/unicorn'
      require_relative 'cli/reaper'
      require_relative 'cli/spawner'
      require_relative 'cli/reloader'
      require_relative 'cli/monitor'

      register 'version', Version
      register 'unicorn' do |cmd|
        cmd.register 'start', Unicorn::Spawner
        cmd.register 'stop', Unicorn::Reaper
        cmd.register 'reload', Unicorn::Reloader
        cmd.register 'monitor', Unicorn::Monitor
        cmd.register 'run', Unicorn::Runner
      end
    end
  end
end
