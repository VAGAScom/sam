# frozen_string_literal: true

module Sam
  module CLI
    module Commands
      module Unicorn
        class Monitor < Hanami::CLI::Command
          # rubocop:disable Metrics/LineLength
          desc 'Monitor an already running unicorn'
          option :config, type: :path, desc: 'The path to the server configuration', default: 'config/unicorn/production.rb', aliases: ['-c']
          option :timeout, type: :integer, desc: 'The number of seconds to wait for starting the unicorn server', aliases: ['-t']
          example [
            '--config=config/server_settings.rb  #Starts the server in production mode using the config/server_settings.rb config file'
          ]
          # rubocop:enable Metrics/LineLength

          def call(config:)
            path = Pathname.new(Dir.pwd).join(config)
            Sam::Unicorn::Shepherd.new.call(path)
          rescue Sam::Unicorn::ProcessNotFound
            puts 'Unicorn exited'
            exit 1
          end
        end
      end
    end
  end
end
