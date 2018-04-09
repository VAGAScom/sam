# frozen_string_literal: true

module Sam
  module Unicorn
    class Cloner
      def call(config, timeout: 10)
        pid = Identifier.new.call(config)
        # warn "Cloning unicorn tagged #{pid}"
        Process.kill('USR2', pid)
        # warn "Waiting #{timeout} seconds for clone process to conclude..."
        sleep timeout
        newpid = Identifier.new.call(config)
        # warn "New unicorn cloned with tag #{newpid}. Reaping it's predecessor..."
        Process.kill('QUIT', pid)
        newpid
        # warn 'No one suspects a thing.'
      rescue Errno::ESRCH
        raise ProcessNotFound, "No process with PID #{pid} found"
      end
    end
  end
end
