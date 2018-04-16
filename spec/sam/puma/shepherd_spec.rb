# frozen_string_literal: true

RSpec.describe Sam::Puma::Shepherd do
  let(:cmd) { TTY::Command.new(printer: :null) }
  let(:config) { Pathname.new(Dir.pwd).join('spec/fixtures/puma_settings.rb') }

  subject(:shepherd) { described_class.new }

  before(:each) { cmd.run! 'bundle exec sam puma start -c spec/fixtures/puma_settings.rb' }
  after(:each) { cmd.run! 'bundle exec sam puma stop -c spec/fixtures/puma_settings.rb' }

  context 'Signal handling' do
    it 'forwards SIGTTOU and SIGTTIN to the puma process'
    it 'when HUP is send, the process is reloaded'
  end

  it 'exits in case the puma process dies' do
    thread = Thread.fork { shepherd.call(config) }
    cmd.run 'bundle exec sam puma stop -c spec/fixtures/puma_settings.rb'
    expect { thread.join }.to raise_error Sam::Errors::ProcessNotFound
  end
end
