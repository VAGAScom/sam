# frozen_string_literal: true

RSpec.describe Sam::Puma::Identifier do
  subject(:identifier) { described_class.new }
  let(:config) { Pathname.new(__FILE__).join('../../../fixtures/puma_settings.rb') }

  it 'raises an error if no pid_file is found' do
    expect { identifier.call(config) }.to raise_error Sam::Errors::PidfileNotFound
  end

  it 'raises an error if the config file is not found' do
    expect { identifier.call("../#{config}") }.to raise_error Sam::Errors::ConfigfileNotFound
  end

  xit 'returns the PID of the unicorn process' do
    cmd = TTY::Command.new(printer: :null)
    cmd.run "bundle exec sam puma start -c #{config}"
    pid = IO.readlines('/tmp/puma.pid').join.chomp.to_i
    expect(identifier.call(config)).to eq(pid)
  ensure
    TTY::Command.new(printer: :null)
                .run!('bundle exec sam puma stop -c spec/fixtures/server_settings.rb && sleep 0.5')
  end
end
