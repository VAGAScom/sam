# frozen_string_literal: true

module Sam
  module CLI
    module Commands
      module Puma
        class Spawner < Hanami::CLI::Command
          # rubocop:disable Metrics/LineLength
          desc 'Start the unicorn process'

          option :environment, values: %w[production development test staging], default: 'production', desc: 'RACK_ENV to be used', aliases: %w[--env -e]
          option :config, type: :path, desc: 'The path to the server configuration', default: 'config/puma/production.rb', aliases: ['-c']

          example [
            '-e development  #Starts the server in development mode',
            '-e production --config=config/server_settings.rb  #Starts the server in production mode using the config/server_settings.rb config file'
          ]
          # rubocop:enable Metrics/LineLength

          def call(environment:, config:)
            config = Pathname.new(Dir.pwd).join(config)
            Sam::Puma::Breeder.new.call(environment, config)
            warn "Started unicorn for environment #{environment} and configuration file: #{config}"
          end
        end
      end
    end
  end
end
