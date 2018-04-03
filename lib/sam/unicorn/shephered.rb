# frozen_string_literal: true

module Sam
  module Unicorn
    class Shephered
      def call(config)
        pid = Sam::Unicorn::Identifier.new.call(Pathname.new(Dir.pwd).join(config))
        loop do
          alive? pid
        end
      end

      private

      def alive?(pid)
        Process.kill(0, pid)
      rescue Errno::ESRCH
        exit!
      end
    end
  end
end
