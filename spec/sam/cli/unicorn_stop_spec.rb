# frozen_string_literal: true

require 'tty-command'

RSpec.describe 'sam unicorn stop', type: :cli do
  let(:config) { 'spec/fixtures/server_settings.rb' }
  before(:each) { TTY::Command.new(printer: :null).run!("bundle exec sam unicorn stop -c #{config}") }

  describe 'stop' do
    it 'stops the unicorn server' do
      TTY::Command.new(printer: :null).run("bundle exec sam unicorn start -c #{config} && sleep 0.5")
      path = Pathname.new(Dir.pwd).join(config)
      output = "Hunted unicorn with pid #{Sam::Unicorn::Identifier.new.call(path)}"
      run_command "sam unicorn stop -c ../../#{config}", output, exit_status: 0
    end

    it 'works with no unicorn running' do
      run_command "sam unicorn stop -c ../../#{config}",
                  Sam::CLI::Commands::Unicorn::Reaper::NO_MORE_UNICORNS,
                  exit_status: 1
    end

    it 'fails if it fails to find the config file' do
      run_command "sam unicorn stop -c #{config}", exit_status: 1
    end
  end
end
