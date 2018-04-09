# frozen_string_literal: true

module Sam
  module Unicorn
    class Shepherd
      def initialize
        setup_signal_handlers
        @restarting = false
      end

      def call(path, timeout: 10)
        @timeout = timeout
        @config ||= Pathname.new(Dir.pwd).join(path)
        loop do
          alive?
          sleep 1
        end
      end

      private

      def pid
        @pid ||= Identifier.new.call(@config)
      end

      def setup_signal_handlers
        trap('HUP') { reload_unicorn }
        trap('QUIT') { forward_signal('QUIT') }
        trap('USR2') { forward_signal('USR2') }
        trap('TTOU') { forward_signal('TTOU') }
        trap('TTIN') { forward_signal('TTIN') }
        trap('TERM') { forward_signal('QUIT') }
      end

      def reload_unicorn
        @restarting = true
        @pid = Cloner.new.call(@config, timeout: @timeout)
        @restarting = false
      end

      def forward_signal(signal)
        warn "Sending #{signal} to unicorn #{pid}"
        Process.kill(signal, pid)
      end

      def alive?
        return if @restarting
        Process.kill(0, pid)
      rescue Errno::ESRCH
        raise ProcessNotFound
      end
    end
  end
end
