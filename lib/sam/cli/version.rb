# frozen_string_literal: true

module Sam::CLI::Commands
  class Version < Hanami::CLI::Command
    desc 'Prints the current Sam version'

    def call(*)
      puts Sam::VERSION
    end
  end
end
