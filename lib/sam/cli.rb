# frozen_string_literal: true

require 'hanami/cli'

module Sam
  module CLI
    module Commands
      extend Hanami::CLI::Registry
    end
  end
end

require_relative 'cli/version'

Sam::CLI::Commands.register 'version', Sam::CLI::Commands::Version
