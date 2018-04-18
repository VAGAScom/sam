# frozen_string_literal: true

module Sam
  module CLI
    module Commands
      class Version < Hanami::CLI::Command
        desc 'Prints the current Sam version'

        def call(*)
          puts Sam::VERSION
        end
      end
    end
  end
end
