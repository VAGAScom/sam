# frozen_string_literal: true

module Sam
  module Unicorn
    class Identifier
      def initialize
        @configurator = ::Unicorn::Configurator.new
      end

      def call(config_file)
        @configurator.instance_eval configuration(config_file)
        Integer(read_pidfile)
      end

      private

      def read_pidfile
        IO.readlines(@configurator.set[:pid]).join.chomp
      rescue Errno::ENOENT
        raise Errors::PidfileNotFound, "PID File #{@configurator.set[:pid]} not found"
      end

      def configuration(config_file)
        IO.readlines(config_file).join
      rescue Errno::ENOENT
        raise Errors::ConfigfileNotFound, "File #{config_file} not found"
      end
    end
  end
end
