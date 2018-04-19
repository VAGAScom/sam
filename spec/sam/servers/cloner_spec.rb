# frozen_string_literal: true

RSpec.describe Sam::Servers::Cloner do
  subject(:cloner) { described_class.new }
  let(:cmd) { TTY::Command.new(printer: :null) }
  let(:unicorn) { Pathname.new(__FILE__).join('../../../fixtures/server_settings.rb') }

  after { cmd.run! "bundle exec sam stop unicorn #{unicorn}" }

  it 'restarts unicorn' do
    cmd.run! "bundle exec sam start unicorn #{unicorn}"
    expect do
      cloner.call(server: 'unicorn', config: unicorn)
      sleep 0.5
    end.to change { Sam::Unicorn::Identifier.new.call(unicorn) }
  end
end
