# frozen_string_literal: true

RSpec.describe 'sam start', type: :cli do
  let(:config) { 'spec/fixtures/puma_settings.rb' }
  before(:each) { TTY::Command.new(printer: :null).run!("bundle exec sam stop puma #{config}") }

  it 'prints a helpful message' do
    output = <<~OUTPUT
      Command:
        sam start

      Usage:
        sam start SERVER CONFIG

      Description:
        Starts the server

      Arguments:
        SERVER              \t# REQUIRED The application server to be started: (unicorn/puma)
        CONFIG              \t# REQUIRED The path to the server configuration file

      Options:
        --env=VALUE, -e VALUE           \t# RACK_ENV to be used: (production/development/test/staging), default: "production"
        --help, -h                      \t# Print this help

      Examples:
        sam start puma config/server_settings.rb -e test # Starts the server in test mode using the config/server_settings.rb config file
        sam start unicorn config/server_settings.rb      # Starts the server in production mode using the config/server_settings.rb config file
    OUTPUT
    run_command 'sam start --help', output, exit_status: 0
  end

  context 'environment' do
    %w[production development test staging].each do |env|
      it "works with #{env}" do
        run_command "sam start puma ../../#{config} -e #{env}", exit_status: 0
        run_command "sam stop puma ../../#{config}", exit_status: 0
      end
    end

    it 'fails with any other value' do
      run_command "sam start puma #{config} -e potato", 'Invalid param provided', exit_status: 1
    end
  end

  context 'puma' do
    it 'start an puma server' do
      run_command "sam start puma ../../#{config}", exit_status: 0
      expect { Sam::Puma::Identifier.new.call(config) }.to_not raise_error
      pid = Sam::Puma::Identifier.new.call(config)
      expect { Process.kill(0, pid) }.to_not raise_error
    end
  end

  context 'unicorn' do
    let(:config) { 'spec/fixtures/server_settings.rb' }
    after(:each) { TTY::Command.new(printer: :null).run!("bundle exec sam stop puma #{config}") }

    it 'start an unicorn server' do
      run_command "sam start unicorn ../../#{config}", exit_status: 0
      expect { Sam::Unicorn::Identifier.new.call(config) }.to_not raise_error
      pid = Sam::Unicorn::Identifier.new.call(config)
      expect { Process.kill(0, pid) }.to_not raise_error
    end
  end
end
