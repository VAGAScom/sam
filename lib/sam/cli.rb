# frozen_string_literal: true

require 'hanami/cli'

module Sam
  module CLI
    module Commands
      extend Hanami::CLI::Registry

      require_relative 'cli/version'
      require_relative 'cli/unicorn'
      require_relative 'cli/hunter'
      require_relative 'cli/spawner'
      require_relative 'cli/reloader'

      register 'version', Version
      register 'unicorn' do |cmd|
        cmd.register 'start', Unicorn::Spawner
        cmd.register 'stop', Unicorn::Hunter
        cmd.register 'reload', Unicorn::Reloader
        cmd.register 'monitor', Unicorn::Monitor
        # cmd.register 'run'
        # cmd.register 'restart'
      end
    end
  end
end
