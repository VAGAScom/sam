# frozen_string_literal: true

require 'hanami/cli'
require_relative 'servers'

module Sam
  module CLI
    module Commands
      extend Hanami::CLI::Registry

      require_relative 'commands/version'
      require_relative 'commands/spawner'
      require_relative 'commands/reaper'
      require_relative 'commands/reloader'
      require_relative 'commands/monitor'

      register 'version', Version
      register 'start', Spawner
      register 'stop', Reaper
      register 'reload', Reloader
      register 'monitor', Monitor
    end
  end
end
