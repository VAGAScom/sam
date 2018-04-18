# frozen_string_literal: true

module Sam
  module CLI
    module Commands
      module Unicorn
        class Runner < Hanami::CLI::Command
          # rubocop:disable Metrics/LineLength
          desc 'Monitor an already running unicorn'
          option :config, type: :path, desc: 'The path to the server configuration', default: 'config/unicorn/production.rb', aliases: ['-c']
          option :environment, values: %w[production development test staging], default: 'production', desc: 'RACK_ENV to be used', aliases: %w[--env -e]
          option :timeout, type: :integer, desc: 'The number of seconds to wait for starting the unicorn server', default: 5, aliases: ['-t']
          example [
            '--config=config/server_settings.rb  #Starts the server in production mode using the config/server_settings.rb config file',
            '-t 20 # Waits for 20 seconds for the master process to fork',
            '-e production --config=config/server_settings.rb  #Starts the server in production mode using the config/server_settings.rb config file'

          ]
          # rubocop:enable Metrics/LineLength

          def call(config:, environment:, timeout:)
            path = Pathname.new(Dir.pwd).join(config)
            Sam::Unicorn::Breeder.new.call(environment, path)
            Sam::Unicorn::Shepherd.new.call(path, timeout: Integer(timeout))
          rescue Errors::ProcessNotFound
            warn 'Unicorn seems dead.'
            exit 1
          end
        end
      end
    end
  end
end
