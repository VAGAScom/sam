# frozen_string_literal: true

module Sam
  module Puma
    class Cloner
      def call(config, timeout: 10)
        @config = config
        pid = Identifier.new.call(@config)
        Process.kill(signal, pid)
      rescue Errno::ESRCH
        raise Errors::ProcessNotFound, "No process with PID #{pid} found"
      end

      private

      def signal
        @configuration ||= (::Puma::Configuration.new({}) { |config| config.load @config.to_s }).load
        @configuration.file_options[:preload_app] ? 'USR1' : 'USR2'
      end
    end
  end
end
