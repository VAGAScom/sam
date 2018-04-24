# frozen_string_literal: true

module Sam
  module Servers
    class Cloner
      PUMA_PID = ->(config) { Sam::Puma::Identifier.new.call(config) }
      UNICORN_PID = ->(config) { Sam::Unicorn::Identifier.new.call(config) }

      UNICORN_STRATEGY = lambda do |config, timeout = 10|
        pid = UNICORN_PID.call(config)
        Process.kill('USR2', pid)
        sleep timeout
        newpid = UNICORN_PID.call(config)
        Process.kill('QUIT', pid)
        newpid
      end

      PUMA_STRATEGY = lambda do |config, _timeout|
        settings = (::Puma::Configuration.new({}) { |conf| conf.load config.to_s }).load
        Process.kill(settings.file_options[:preload_app] ? 'USR1' : 'USR2', PUMA_PID.call(config))
      end

      def call(server:, config:, timeout: 10)
        restart_strategy(server, config, timeout)
      end

      private

      def restart_strategy(server, config, timeout)
        self.class.const_get("#{server.upcase}_STRATEGY").call(config, timeout)
      end
    end
  end
end
