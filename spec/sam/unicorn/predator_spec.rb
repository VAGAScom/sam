# frozen_string_literal: true

RSpec.describe Sam::Unicorn::Predator do
  subject(:predator) { described_class.new }
  let(:config) { Pathname.new(__FILE__).join('../../../fixtures/server_settings.rb') }
  let(:cmd) { TTY::Command.new(printer: :null) }

  it 'stop an unicorn instance' do
    cmd.run 'bundle exec sam unicorn start -c spec/fixtures/server_settings.rb'
    expect { predator.call(config) }.to_not raise_error
    sleep 0.5
    expect { Sam::Unicorn::Identifier.new.call(config) }.to raise_error Sam::Unicorn::PidfileNotFound
  end
end
