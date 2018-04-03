# frozen_string_literal: true

module Sam
  module Unicorn
    class PidfileNotFound < Errno::ENOENT
    end

    class ConfigfileNotFound < Errno::ENOENT
    end

    class ProcessNotFound < Errno::ESRCH
    end
  end
end

require_relative 'unicorn/identifier'
require_relative 'unicorn/breeder'
require_relative 'unicorn/predator'
require_relative 'unicorn/shephered'
