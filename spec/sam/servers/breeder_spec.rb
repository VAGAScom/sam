# frozen_string_literal: true

RSpec.describe Sam::Servers::Breeder do
  subject(:breeder) { described_class.new }

  let(:unicorn) { Pathname.new(__FILE__).join('../../../fixtures/server_settings.rb') }
  let(:puma) { Pathname.new(__FILE__).join('../../../fixtures/puma_settings.rb') }

  let(:env) { 'development' }
  let(:cmd) { TTY::Command.new(printer: :null) }

  after(:each) do
    cmd.run! "bundle exec sam stop puma #{puma}"
    cmd.run! "bundle exec sam stop unicorn #{unicorn}"
  end

  it 'start an unicorn instance' do
    expect { breeder.call(server: 'puma', env: env, config: puma) }.to_not raise_error
    # check if process is up
    expect(Sam::Puma::Identifier.new.call(puma)).to be_an Integer
  end

  it 'start an unicorn instance' do
    expect { breeder.call(server: 'unicorn', env: env, config: unicorn) }.to_not raise_error
    # check if process is up
    expect(Sam::Unicorn::Identifier.new.call(unicorn)).to be_an Integer
  end
end
