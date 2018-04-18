# frozen_string_literal: true

module Sam
  module CLI
    module Commands
      class Reloader < Hanami::CLI::Command
        desc 'Reloads the code on a running server'

        # rubocop:disable Metrics/LineLength
        argument :server, required: true, values: %w[unicorn puma], desc: 'The application server to be started'
        argument :config, required: true, desc: 'The path to the server configuration file'

        example [
          'puma config/server_settings.rb      # Starts the server in test mode using the config/server_settings.rb config file',
          'unicorn config/server_settings.rb   # Starts the server in production mode using the config/server_settings.rb config file'
        ]
        # rubocop:enable Metrics/LineLength

        def call(server:, config:)
          path = Pathname.new(Dir.pwd).join(config)
          Sam::Servers::Cloner.new.call(server: server, config: path)
        rescue Errors::ProcessNotFound
          warn "No running #{server}s found"
          exit 1
        end
      end
    end
  end
end
