# frozen_string_literal: true

require 'puma/cli'

module Sam
  module Puma
    class Identifier
      def call(config_file)
        setup_configurator(config_file)
        Integer(read_pidfile)
      end

      private

      def configuration
        setup_configurator unless @configurator
        @configurator
      end

      def setup_configurator(config_file)
        @configurator ||= (::Puma::Configuration.new({}) { |config| config.load config_file.to_s }).load
      rescue Errno::ENOENT
        raise Errors::ConfigfileNotFound, "File #{config_file} not found"
      end

      def read_pidfile
        IO.readlines(@configurator.fetch(:pidfile)).join.chomp
      rescue Errno::ENOENT # frozen_string_literal: true
        raise Errors::PidfileNotFound, "PID File #{@configurator.fetch(:pidfile)} not found"
      end
    end
  end
end
