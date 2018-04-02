# frozen_string_literal: true

require 'tty-command'

module Sam
  module Unicorn
    class Breeder
      COMMAND = 'bundle exec unicorn -D -c ${CONF_PATH} -E ${RACK_ENV}'

      def call(env, config)
        cmd = TTY::Command.new(timeout: 120)
        cmd.run(COMMAND, env: { CONF_PATH: config, RACK_ENV: env })
      end
    end
  end
end
