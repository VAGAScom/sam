# frozen_string_literal: true

RSpec.describe Sam::Servers::Shepherd do
  let(:cmd) { TTY::Command.new(printer: :quiet) }
  subject(:shepherd) { described_class.new }

  context 'puma' do
    let(:config) { Pathname.new(Dir.pwd).join('spec/fixtures/puma_settings.rb') }

    after(:each) { cmd.run! 'bundle exec sam stop puma spec/fixtures/puma_settings.rb' }

    context 'Signal handling' do
      it 'forwards SIGTTOU and SIGTTIN to the puma process'
      it 'when HUP is send, the process is reloaded'
    end

    it 'exits in case the puma process dies' do
      cmd.run 'bundle exec sam start puma spec/fixtures/puma_settings.rb && sleep 0.5'
      thread = Thread.fork { shepherd.call(server: 'puma', config: config) }
      cmd.run 'bundle exec sam stop puma spec/fixtures/puma_settings.rb'
      expect { thread.join }.to raise_error Sam::Errors::ProcessNotFound
    end
  end

  context 'unicorn' do
    let(:config) { Pathname.new(Dir.pwd).join('spec/fixtures/server_settings.rb') }

    before(:each) { cmd.run! 'bundle exec sam start unicorn spec/fixtures/server_settings.rb' }
    after(:each) { cmd.run! 'bundle exec sam stop unicorn spec/fixtures/server_settings.rb' }

    context 'Signal handling' do
      it 'forwards SIGTTOU and SIGTTIN to the unicorn process'

      it 'when HUP is send, the process is reloaded' do
        monit = Process.fork { shepherd.call(server: 'unicorn', config: config, timeout: 0.5) }
        Process.detach(monit)
        expect do
          Process.kill('HUP', monit)
          sleep 5
        end.to change { Sam::Unicorn::Identifier.new.call(config) }
      ensure
        Process.kill('KILL', monit)
      end
    end

    it 'exits in case the unicorn process dies' do
      thread = Thread.fork { shepherd.call(server: 'unicorn', config: config) }
      cmd.run 'bundle exec sam stop unicorn spec/fixtures/server_settings.rb'
      expect { thread.join }.to raise_error Sam::Errors::ProcessNotFound
    end
  end
end
