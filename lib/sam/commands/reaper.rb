# frozen_string_literal: true

module Sam
  module CLI
    module Commands
      class Reaper < Hanami::CLI::Command
        # rubocop:disable Metrics/LineLength
        desc 'Stops the server process'
        argument :server, required: true, values: %w[unicorn puma], desc: 'The application server to be started'
        argument :config, required: true, desc: 'The path to the server configuration file'

        example [
          'puma config/puma/development.rb # Stops the server in production mode using the config/puma/development.rb config file'
        ]
        # rubocop:enable Metrics/LineLength

        def call(server:, config:)
          exit 1 unless server_found(server)
          path = Pathname.new(Dir.pwd).join(config)
          result = Sam::Servers::Predator.new.call(server: server, config: path)
          warn "Hunted one #{server} with pid #{result}"
        rescue Errors::PidfileNotFound
          warn "No running #{server}s found"
          exit 1
        rescue Errors::ConfigfileNotFound => ex
          warn ex.message
          exit 1
        end

        private

        def server_found(server)
          gem server
        rescue Gem::LoadError
          warn "#{server} not found. Make sure it's in your Gemfile"
          false
        end
      end
    end
  end
end
