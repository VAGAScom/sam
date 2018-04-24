# frozen_string_literal: true

module Sam
  module CLI
    module Commands
      class Monitor < Hanami::CLI::Command
        desc 'Monitor an already running server'

        # rubocop:disable Metrics/LineLength
        argument :server, required: true, values: %w[unicorn puma], desc: 'The application server to be started'
        argument :config, required: true, desc: 'The path to the server configuration file'

        option :timeout, aliases: ['-t'], default: 10, desc: 'The amount of time waiting for the server  process to fork new workers'

        example [
          'unicorn config/server_settings.rb  #Starts the server in production mode using the config/server_settings.rb config file'
        ]
        # rubocop:enable Metrics/LineLength

        def call(server:, config:, timeout:)
          path = Pathname.new(Dir.pwd).join(config)
          Sam::Servers::Shepherd.new.call(server: server, config: path, timeout: timeout)
        rescue Errors::ProcessNotFound
          warn "#{server} exited"
          exit 1
        end
      end
    end
  end
end
