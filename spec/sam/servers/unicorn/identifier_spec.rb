# frozen_string_literal: true

require 'tty-command'

RSpec.describe Sam::Unicorn::Identifier do
  subject(:identifier) { described_class.new }
  let(:config) { Pathname.new(__FILE__).join('../../../../fixtures/server_settings.rb') }

  after(:each) do
    TTY::Command.new(printer: :null)
                .run!('bundle exec sam unicorn stop -c spec/fixtures/server_settings.rb && sleep 0.5')
  end

  it 'raises an error if no pid_file is found' do
    expect { identifier.call(config) }.to raise_error Sam::Errors::PidfileNotFound
  end

  it 'raises an error if the config file is not found' do
    expect { identifier.call("../#{config}") }.to raise_error Sam::Errors::ConfigfileNotFound
  end

  it 'returns the PID of the unicorn process' do
    cmd = TTY::Command.new(printer: :null)
    cmd.run "bundle exec sam start unicorn #{config}"
    pid = IO.readlines('/tmp/unicorn.pid').join.chomp.to_i
    expect(identifier.call(config)).to eq(pid)
  end
end
