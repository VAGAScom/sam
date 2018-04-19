# frozen_string_literal: true

RSpec.describe 'sam unicorn monitor' do
  let(:config) { 'spec/fixtures/server_settings.rb' }
  before(:each) { TTY::Command.new(printer: :null).run!("bundle exec sam stop unicorn #{config}") }

  it 'if the process has stopped it should quit' do
    TTY::Command.new(printer: :null).run("bundle exec sam start unicorn #{config}")
    pid = Process.spawn("bundle exec sam unicorn monitor -c #{config}")
    Process.detach(pid)
    TTY::Command.new(printer: :null).run("bundle exec sam stop unicorn #{config} && sleep 2")
    expect { Process.kill(0, pid) }.to raise_error Errno::ESRCH
  end

  it 'traps the INT, TERM, HUP, TTIN, TTOU, QUIT and WHINCH signals'
end
