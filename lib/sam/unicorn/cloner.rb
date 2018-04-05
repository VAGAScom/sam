# frozen_string_literal: true

module Sam
  module Unicorn
    class Cloner
      def call(config, timeout: 10)
        pid = Identifier.new.call(config)
        Process.kill('USR2', pid)
        sleep timeout
        newpid = Identifier.new.call(config)
        Process.kill('QUIT', pid)
        newpid
        # rescue Errno::ESRCH
        # raise ProcessNotFound
      end
    end
  end
end

# puts "Cloning unicorn tagged #{pid}"
# puts 'Waiting for clone process to conclude...'
# sleep 10
# # File.exist? '/tmp/unicorn.pid.oldbin'
# newpid = Identifier.new.call(@config)
# puts "New unicorn cloned with tag #{newpid}. Reaping it's predecessor..."
# Process.kill('QUIT', pid)
# @pid = newpid
# puts 'No one suspects a thing.'
