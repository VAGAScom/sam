# frozen_string_literal: true

app_path = File.join(__FILE__, '..')

# Set unicorn options
worker_processes 2
preload_app true
timeout 5
listen 8888

working_directory app_path

pid '/tmp/unicorn.pid'

# before_fork do |_server, _worker|
# end

# after_fork do |server, worker|
# end
