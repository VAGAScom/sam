# frozen_string_literal: true

module Sam
  module Unicorn
    class Predator
      def call(config)
        pid = Sam::Unicorn::Identifier.new.call(config)
        Process.kill('QUIT', pid) && pid
      end
    end
  end
end
