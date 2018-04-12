# frozen_string_literal: true

RSpec.describe Sam::Puma::Breeder do
  subject(:breeder) { described_class.new }
  let(:config) { Pathname.new(__FILE__).join('../../../fixtures/puma_settings.rb') }
  let(:env) { 'development' }
  let(:cmd) { TTY::Command.new(printer: :null) }

  after(:each) do
    cmd.run "bundle exec sam puma stop -c #{config}"
  end

  it 'start an unicorn instance' do
    expect { breeder.call(env, config) }.to_not raise_error
    # check if process is up
    expect(Sam::Puma::Identifier.new.call(config)).to be_an Integer
  end
end
