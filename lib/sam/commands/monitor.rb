# frozen_string_literal: true

module Sam
  module CLI
    module Commands
      class Monitor < Hanami::CLI::Command
        desc 'Monitor an already running server'

        argument :server, required: true, values: %w[unicorn puma], desc: 'The application server to be started'
        argument :config, required: true, desc: 'The path to the server configuration file'

        example [
          'unicorn config/server_settings.rb  #Starts the server in production mode using the config/server_settings.rb config file'
        ]

        def call(server:, config:)
          path = Pathname.new(Dir.pwd).join(config)
          Sam::Servers::Shepherd.new.call(server: server, config: path)
        rescue Errors::ProcessNotFound
          warn 'Unicorn exited'
          exit 1
        end
      end
    end
  end
end
