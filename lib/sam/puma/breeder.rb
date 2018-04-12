# frozen_string_literal: true

require 'tty-command'

module Sam
  module Puma
    class Breeder
      COMMAND = 'bundle exec puma -C ${CONF_PATH} -e ${RACK_ENV}'

      def call(env, config)
        cmd = TTY::Command.new(timeout: 120)
        cmd.run(COMMAND, env: { CONF_PATH: config, RACK_ENV: env })
      end
    end
  end
end
