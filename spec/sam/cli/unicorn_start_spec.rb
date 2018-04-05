# frozen_string_literal: true

RSpec.describe 'sam unicorn start', type: :cli do
  let(:config) { 'spec/fixtures/server_settings.rb' }
  before(:each) { TTY::Command.new(printer: :null).run!("bundle exec sam unicorn stop -c #{config}") }

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

  context 'environment' do
    %w[production development test staging].each do |env|
      it "works with #{env}" do
        run_command "sam unicorn start -e #{env} -c ../../#{config}", exit_status: 0
        run_command "sam unicorn stop -c ../../#{config}", exit_status: 0
      end
    end

    it 'fails with any other value' do
      run_command "sam unicorn start -e potato -c #{config}", 'Invalid param provided', exit_status: 1
    end
  end

  it 'fails if the config file is not found' do
    run_command 'sam unicorn start', exit_status: 1
  end

  it 'start an unicorn server' do
    run_command "sam unicorn start -c ../../#{config}", exit_status: 0
    expect { Sam::Unicorn::Identifier.new.call(config) }.to_not raise_error
    pid = Sam::Unicorn::Identifier.new.call(config)
    expect { Process.kill(0, pid) }.to_not raise_error
  end
end
