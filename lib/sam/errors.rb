# frozen_string_literal: true

module Sam
  module Errors
    class PidfileNotFound < StandardError
    end

    class ConfigfileNotFound < StandardError
    end

    class ProcessNotFound < Errno::ESRCH
    end
  end
end
