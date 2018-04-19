# frozen_string_literal: true

require_relative 'unicorn/monitor'
require_relative 'unicorn/runner'

# Upstart reload sends SIGHUP to the process
# Systemd expects an ExecReload= that syncronously reloads the confs.
