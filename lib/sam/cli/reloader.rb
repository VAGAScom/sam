# frozen_string_literal: true

module Sam
  module CLI
    module Commands
      module Unicorn
        class Reloader < Hanami::CLI::Command
          # rubocop:disable Metrics/LineLength
          desc 'Reloads the unicorn configuration'
          option :config, type: :path, desc: 'The path to the server configuration', default: 'config/unicorn/production.rb', aliases: ['-c']

          example [
            '--config=config/server_settings.rb  #Starts the server in production mode using the config/server_settings.rb config file'
          ]
          # rubocop:enable Metrics/LineLength

          def call(config)
            path = Pathname.new(Dir.pwd).join(config)
            # Sam::Unicorn::Cloner.new.call(path)
          end
        end
      end
    end
  end
end
