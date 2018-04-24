# frozen_string_literal: true

module Sam
  module CLI
    module Commands
      class Runner < Hanami::CLI::Command
        desc 'Starts and monitor an already running server'
        # rubocop:disable Metrics/LineLength
        argument :server, required: true, values: %w[unicorn puma], desc: 'The application server to be started'
        argument :config, required: true, desc: 'The path to the server configuration file'

        option :env, values: %w[production development test staging], default: 'production', desc: 'RACK_ENV to be used', aliases: ['-e']
        option :timeout, aliases: ['-t'], default: 10, desc: 'The amount of time waiting for the server  process to fork new workers'


        example [
          'puma config/server_settings.rb -e test # Starts and monitors the server in test mode using the config/server_settings.rb config file',
          'unicorn config/server_settings.rb  #Starts and monitors the server in production mode using the config/server_settings.rb config file'
        ]
        # rubocop:enable Metrics/LineLength

        def call(server:, config:, env:, timeout:)
          Sam::Servers::Breeder.new.call(server: server, config: config, env: env)
          Sam::Servers::Monitor.new.call(server: server, config: config, timeout: timeout)
        rescue Sam::Errors::ProcessNotFound
          warn "#{server} exited"
          exit 1
        end
      end
    end
  end
end
