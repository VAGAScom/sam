# frozen_string_literal: true

module Sam
  module CLI
    module Commands
      module Puma
        class Reaper < Hanami::CLI::Command
          NO_MORE_PUMAS = 'Pumas are extinct =('

          # rubocop:disable Metrics/LineLength
          desc 'Stops the puma process'
          option :config, type: :path, desc: 'The path to the server configuration', default: 'config/unicorn/production.rb', aliases: ['-c']

          example [
            '-config config/server_settings.rb  Stops the server in production mode using the config/server_settings.rb config file'
          ]
          # rubocop:enable Metrics/LineLength

          def call(config:)
            path = Pathname.new(Dir.pwd).join(config)
            result = Sam::Puma::Predator.new.call(path)
            warn "Hunted a puma with pid #{result}"
          rescue Errors::PidfileNotFound
            warn NO_MORE_PUMAS
            exit 1
          rescue Errors::ConfigfileNotFound => ex
            warn ex.message
            exit 1
          end
        end
      end
    end
  end
end
