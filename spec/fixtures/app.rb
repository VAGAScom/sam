# frozen_string_literal: true

require 'sinatra'

class App < Sinatra::Base
  get '/version' do
    Sam::VERSION
  end
end
