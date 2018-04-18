# frozen_string_literal: true

require 'hanami/cli'

module Sam
  module CLI
    module Commands
      class Spawner < Hanami::CLI::Command
        desc 'Starts the server'

        # rubocop:disable Metrics/LineLength
        argument :server, required: true, values: %w[unicorn puma], desc: 'The application server to be started'
        argument :config, required: true, desc: 'The path to the server configuration file'

        option :env, values: %w[production development test staging], default: 'production', desc: 'RACK_ENV to be used', aliases: ['-e']

        example [
          'puma config/server_settings.rb -e test # Starts the server in test mode using the config/server_settings.rb config file',
          'unicorn config/server_settings.rb      # Starts the server in production mode using the config/server_settings.rb config file'
        ]
        # rubocop:enable Metrics/LineLength

        def call(server:, config:, env:)
          path_to_config = Pathname.new(Dir.pwd).join(config)
          Sam::Servers::Breeder.new.call(server: server, config: path_to_config, env: env)
        end
      end
    end
  end
end
