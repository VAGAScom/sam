# frozen_string_literal: true

module Sam
  module Servers
    class Cloner
      PUMA_PID = ->(config) { Sam::Puma::Identifier.new.call(config) }
      UNICORN_PID = ->(config) { Sam::Unicorn::Identifier.new.call(config) }

      UNICORN_STRATEGY = lambda do |config|
        pid = UNICORN_PID.call(config)
        Process.kill('USR2', pid)
        sleep 0.5
        newpid = UNICORN_PID.call(config)
        Process.kill('QUIT', pid)
        newpid
      end

      PUMA_STRATEGY = lambda do |config|
        settings = (::Puma::Configuration.new({}) { |conf| conf.load config.to_s }).load
        Process.kill(settings.file_options[:preload_app] ? 'USR1' : 'USR2', PUMA_PID.call(config))
      end

      def call(server:, config:)
        @server = server
        @config = config
        restart_strategy
      end

      private

      def restart_strategy
        self.class.const_get("#{@server.upcase}_STRATEGY").call(@config)
      end
    end
  end
end
