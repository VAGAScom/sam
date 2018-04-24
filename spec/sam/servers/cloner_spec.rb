# frozen_string_literal: true

RSpec.describe Sam::Servers::Cloner do
  subject(:cloner) { described_class.new }
  let(:cmd) { TTY::Command.new(printer: :null) }
  let(:unicorn) { Pathname.new(__FILE__).join('../../../fixtures/server_settings.rb') }
  let(:puma) { Pathname.new(__FILE__).join('../../../fixtures/puma_settings.rb') }

  after do
    cmd.run! "bundle exec sam stop unicorn #{unicorn}"
    cmd.run! "bundle exec sam stop puma #{puma}"
  end

  it 'restarts unicorn' do
    cmd.run! "bundle exec sam start unicorn #{unicorn}"
    expect do
      cloner.call(server: 'unicorn', config: unicorn, timeout: 0.5)
      sleep 0.5
    end.to change { Sam::Unicorn::Identifier.new.call(unicorn) }
  end

  it 'restarts puma' do
    cmd.run! "bundle exec sam start puma #{puma}"
    expect do
      cloner.call(server: 'puma', config: puma, timeout: 0.5)
    end.to change { `pgrep -af puma` }
  end
end
