require 'bundler'
Bundler.require

opal = Opal::Server.new { |s|
  s.append_path 'rb'
  s.append_path 'assets'

  s.main = 'main'
}

map '/assets' do
  run opal.sprockets
end

get '/' do
  send_file 'index.html'
end

get '/style.css' do
  send_file 'style.css'
end

run Sinatra::Application