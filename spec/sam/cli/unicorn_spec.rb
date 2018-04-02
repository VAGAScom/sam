# frozen_string_literal: true

require 'tty-command'

RSpec.describe 'sam unicorn', type: :cli do
  # TODO: Stop unicorn after each test
  describe 'start' do
    it 'prints a helpful message' do
      output = <<~OUTPUT
        Command:
          sam unicorn start

        Usage:
          sam unicorn start

        Description:
          Start the unicorn process

        Options:
          --environment=VALUE, --env=VALUE, -e VALUE\t# RACK_ENV to be used: (production/development/test/staging), default: "production"
          --config=VALUE, -c VALUE        \t# The path to the server configuration, default: "config/unicorn/production.rb"
          --help, -h                      \t# Print this help

        Examples:
          sam unicorn start -e development  #Starts the server in development mode
          sam unicorn start -e production --config=config/server_settings.rb  #Starts the server in production mode using the config/server_settings.rb config file
      OUTPUT
      run_command 'sam unicorn start --help', output, exit_status: 0
    end

    it 'environment must be one of production, development, test or staging' do
      %w[production development test staging].each do |env|
        run_command "sam unicorn start -e #{env}", exit_status: 0
      end
      run_command 'sam unicorn start -e potato', exit_status: 1
    end

    it 'optionally receives a config file argument'
    it 'start an unicorn server'
    it 'exits with an error code it the server can\'t start'
  end

  describe 'stop' do
    it 'stops the unicorn server' do
      cmd = TTY::Command.new
      cmd.run 'cd spec/fixtures && bundle exec unicorn -D -c $PWD/server_settings.rb'
      path = Pathname.new(__FILE__).join('../../../fixtures/server_settings.rb')
      output = "Hunted unicorn with pid #{Sam::Unicorn::Identifier.new.call(path)}"
      run_command "bundle exec sam unicorn stop -c #{path}", output, exit_status: 0
    end

    it 'works with no unicorn running' do
      run_command 'bundle exec sam unicorn stop', Sam::CLI::Commands::Unicorn::Hunter::NO_MORE_UNICORNS, exit_status: 0
    end
  end

  describe 'monitor' do
    it 'traps the INT, HUP, TTIN, TTOU, QUIT and WHINCH signals'
  end
end
