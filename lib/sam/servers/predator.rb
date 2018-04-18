# frozen_string_literal: true

module Sam
  module Servers
    class Predator
      PUMA_PID = ->(config) { Sam::Puma::Identifier.new.call(config) }
      UNICORN_PID = ->(config) { Sam::Unicorn::Identifier.new.call(config) }

      def call(server:, config:)
        @server = server
        @config = config
        Process.kill(signal, pid) && pid
      end

      private

      def signal
        @server == 'unicorn' ? 'QUIT' : 'INT'
      end

      def pid
        @pid ||= self.class.const_get("#{@server.upcase}_PID").call(@config)
      end
    end
  end
end
