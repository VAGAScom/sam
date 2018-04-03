# frozen_string_literal: true

module Sam
  module CLI
    module Commands
      module Unicorn
        class Hunter < Hanami::CLI::Command
          NO_MORE_UNICORNS = 'Unicorns are already extinct'

          # rubocop:disable Metrics/LineLength
          desc 'Stops the unicorn process'
          option :config, type: :path, desc: 'The path to the server configuration', default: 'config/unicorn/production.rb', aliases: ['-c']

          example [
            '-config config/server_settings.rb  Stops the server in production mode using the config/server_settings.rb config file'
          ]
          # rubocop:enable Metrics/LineLength

          def call(config:)
            result = Sam::Unicorn::Predator.new.call(Pathname.new(Dir.pwd).join(config))
            puts "Hunted unicorn with pid #{result}"
          rescue Sam::Unicorn::PidfileNotFound
            puts NO_MORE_UNICORNS
          end
        end
      end
    end
  end
end
