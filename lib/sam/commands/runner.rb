# frozen_string_literal: true

module Sam
  module CLI
    module Commands
      class Runner
        desc 'Monitor an already running server'
        # rubocop:disable Metrics/LineLength
        argument :server, required: true, values: %w[unicorn puma], desc: 'The application server to be started'
        argument :config, required: true, desc: 'The path to the server configuration file'

        example [
          'unicorn config/server_settings.rb  #Starts the server in production mode using the config/server_settings.rb config file'
        ]
        # rubocop:enable Metrics/LineLength

        def call(server:, config:, env:)
          Sam::Servers::Breeder.new.call(server: server, config: config, env: env)
          Sam::Servers::Monitor.new.call(server: server, config: config)
        rescue Sam::Errors::ProcessNotFound
          warn "#{server} exited"
          exit 1
        end
      end
    end
  end
end
