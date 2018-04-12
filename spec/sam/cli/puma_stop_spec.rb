# frozen_string_literal: true

require 'tty-command'

RSpec.describe 'sam puma stop', type: :cli do
  let(:config) { 'spec/fixtures/puma_settings.rb' }
  before(:each) { TTY::Command.new(printer: :null).run!("bundle exec sam unicorn stop -c #{config}") }

  describe 'stop' do
    it 'stops the puma server' do
      TTY::Command.new(printer: :null).run("bundle exec sam puma start -c #{config} && sleep 0.5")
      path = Pathname.new(Dir.pwd).join(config)
      output = "Hunted a puma with pid #{Sam::Puma::Identifier.new.call(path)}"
      run_command "sam puma stop -c ../../#{config}", output, exit_status: 0
    end

    it 'works with no puma running' do
      run_command "sam puma stop -c ../../#{config}",
                  Sam::CLI::Commands::Puma::Reaper::NO_MORE_PUMAS,
                  exit_status: 1
    end

    it 'fails if it fails to find the config file' do
      run_command "sam puma stop -c #{config}", exit_status: 1
    end
  end
end
