# frozen_string_literal: true

module Sam
  module CLI
    module Commands
      module Unicorn
        class Reaper < Hanami::CLI::Command
          NO_MORE_UNICORNS = 'Unicorns are already extinct'

          # rubocop:disable Metrics/LineLength
          desc 'Stops the unicorn process'
          option :config, type: :path, desc: 'The path to the server configuration', default: 'config/unicorn/production.rb', aliases: ['-c']

          example [
            '-config config/server_settings.rb  Stops the server in production mode using the config/server_settings.rb config file'
          ]
          # rubocop:enable Metrics/LineLength

          def call(config:)
            path = Pathname.new(Dir.pwd).join(config)
            result = Sam::Unicorn::Predator.new.call(path)
            warn "Hunted unicorn with pid #{result}"
          rescue Sam::Unicorn::PidfileNotFound
            puts NO_MORE_UNICORNS
            exit 1
          rescue Sam::Unicorn::ConfigfileNotFound => ex
            puts ex.message
            exit 1
          end
        end
      end
    end
  end
end
