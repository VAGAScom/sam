# frozen_string_literal: true

RSpec.describe Sam::Servers::Predator do
  subject(:predator) { described_class.new }
  let(:unicorn) { Pathname.new(__FILE__).join('../../../fixtures/server_settings.rb') }
  let(:puma) { Pathname.new(__FILE__).join('../../../fixtures/puma_settings.rb') }
  let(:cmd) { TTY::Command.new(printer: :null) }

  it 'stop an unicorn instance' do
    cmd.run 'bundle exec sam start unicorn spec/fixtures/server_settings.rb'
    expect { predator.call(config) }.to_not raise_error
    sleep 0.5
    expect { Sam::Unicorn::Identifier.new.call(unicorn) }.to raise_error Sam::Errors::PidfileNotFound
  end

  it 'stop an puma instance' do
    cmd.run 'bundle exec sam start puma spec/fixtures/puma_settings.rb'
    expect { predator.call(config) }.to_not raise_error
    sleep 0.5
    expect { Sam::Puma::Identifier.new.call(puma) }.to raise_error Sam::Errors::PidfileNotFound
  end
end
