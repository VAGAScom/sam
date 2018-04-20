# frozen_string_literal: true

module Sam
  module Servers
    class Shepherd
      def initialize
        trap_signals
      end

      def call(server:, config:)
        @config = config
        @server = server
        loop do
          Process.kill(0, pid)
        end
      rescue Errno::ESRCH
        raise Errors::ProcessNotFound
      end

      private

      def pid
        @pid ||= self.class.const_get("Sam::Servers::#{@server.upcase}_PID").call(@config)
      end

      def trap_signals
        trap('HUP') { reload_server }
        trap('QUIT') { forward_signal('QUIT') }
        trap('USR2') { forward_signal('USR2') }
        trap('TTOU') { forward_signal('TTOU') }
        trap('TTIN') { forward_signal('TTIN') }
        trap('TERM') { forward_signal('QUIT') }
        trap('INT') { forward_signal('INT') }
      end

      def reload_server
        @pid = Cloner.new.call(server: @server, config: @config)
      end

      def forward_signal(signal)
        Process.kill(signal, pid)
      end

      def heartbeat; end
    end
  end
end
