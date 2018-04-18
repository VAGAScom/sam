# frozen_string_literal: true

require 'tty-command'

module Sam
  module Servers
    class Breeder
      UNICORN = 'bundle exec unicorn -D -c ${CONF_PATH} -E ${RACK_ENV}'
      PUMA = 'bundle exec puma -C ${CONF_PATH} -e ${RACK_ENV}'

      def initialize
        @cmd = TTY::Command.new(timeout: 120, printer: :quiet)
      end

      def call(server:, config:, env: 'production')
        cmdline = self.class.const_get(server.upcase)
        @cmd.run(cmdline, env: { CONF_PATH: config, RACK_ENV: env })
      end
    end
  end
end
