# frozen_string_literal: true

module Sam
  module Unicorn
    class Shephered
      def initialize
        setup_signal_handlers
      end

      def call(path)
        @config ||= Pathname.new(Dir.pwd).join(path)
        loop do
          alive?
        end
      end

      private

      def pid
        @pid ||= Identifier.new.call(@config)
      end

      def setup_signal_handlers
        trap('HUP') { restart_unicorn }
        trap('QUIT') { forward_signal('QUIT') }
        trap('USR2') { forward_signal('USR2') }
        trap('TTOU') { forward_signal('TTOU') }
        trap('TTIN') { forward_signal('TTIN') }
        trap('TERM') { forward_signal('QUIT') }
      end

      def forward_signal(signal)
        puts "Sending #{signal} to unicorn #{pid}"
        Process.kill(signal, pid)
      end

      def restart_unicorn
        puts "Cloning unicorn tagged #{pid}"
        Process.kill('USR2', pid)
        puts 'Waiting for clone process to conclude...'
        sleep 10
        # File.exist? '/tmp/unicorn.pid.oldbin'
        newpid = Identifier.new.call(@config)
        puts "New unicorn cloned with tag #{newpid}. Reaping it's predecessor..."
        Process.kill('QUIT', pid)
        @pid = newpid
        puts 'No one suspects a thing.'
      end

      def alive?
        Process.kill(0, pid)
      rescue Errno::ESRCH
        raise ProcessNotFound
      end
    end
  end
end
