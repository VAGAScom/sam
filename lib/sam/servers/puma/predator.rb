# frozen_string_literal: true

module Sam
  module Puma
    class Predator
      def call(config)
        pid = Sam::Puma::Identifier.new.call(config)
        Process.kill('INT', pid) && pid
      end
    end
  end
end
