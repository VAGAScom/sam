# frozen_string_literal: true

module Sam
  module Unicorn
    class PidfileNotFound < StandardError
    end

    class ConfigfileNotFound < StandardError
    end

    class ProcessNotFound < Errno::ESRCH
    end
  end
end

require_relative 'unicorn/identifier'
require_relative 'unicorn/breeder'
require_relative 'unicorn/predator'
require_relative 'unicorn/cloner'
require_relative 'unicorn/shephered'
