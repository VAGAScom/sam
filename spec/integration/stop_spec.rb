# frozen_string_literal: true

RSpec.describe 'sam stop', type: :cli do
  describe 'puma' do
    let(:config) { 'spec/fixtures/puma_settings.rb' }
    before(:each) { TTY::Command.new(printer: :null).run!("bundle exec sam stop puma #{config}") }

    it 'stops the puma server' do
      TTY::Command.new(printer: :null).run("bundle exec sam start puma #{config} && sleep 0.5")
      path = Pathname.new(Dir.pwd).join(config)
      output = "Hunted one puma with pid #{Sam::Puma::Identifier.new.call(path)}"
      run_command "sam stop puma ../../#{config}", output, exit_status: 0
    end

    it 'works with no puma running' do
      run_command "sam stop puma ../../#{config}", 'No running pumas found', exit_status: 1
    end

    it 'fails if it fails to find the config file' do
      run_command "sam stop puma #{config}", exit_status: 1
    end
  end

  describe 'unicorn' do
    let(:config) { 'spec/fixtures/server_settings.rb' }
    before(:each) { TTY::Command.new(printer: :null).run!("bundle exec sam stop unicorn #{config}") }

    it 'stops the unicorn server' do
      TTY::Command.new(printer: :null).run("bundle exec sam start unicorn #{config} && sleep 0.5")
      path = Pathname.new(Dir.pwd).join(config)
      output = "Hunted one unicorn with pid #{Sam::Unicorn::Identifier.new.call(path)}"
      run_command "sam stop unicorn ../../#{config}", output, exit_status: 0
    end

    it 'works with no unicorn running' do
      run_command "sam stop unicorn ../../#{config}", 'No running unicorns found', exit_status: 1
    end

    it 'fails if it fails to find the config file' do
      run_command "sam stop unicorn #{config}", exit_status: 1
    end
  end
end
