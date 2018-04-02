# frozen_string_literal: true

require 'hanami/cli'

module Sam
  module CLI
    module Commands
      extend Hanami::CLI::Registry

      require_relative 'cli/version'
      require_relative 'cli/unicorn'
      require_relative 'cli/hunter'

      register 'version', Version
      register 'unicorn' do |cmd|
        cmd.register 'start', Unicorn::Spawner
        cmd.register 'stop', Unicorn::Hunter
        # cmd.register 'run'
        # cmd.register 'monitor', Unicorn::Monitor
        # cmd.register 'restart'
        # cmd.register 'reload'
      end
    end
  end
end
