require_relative 'app'
require 'sinatra'

app = Rack::MockRequest.new(Sinatra::Application)
path = '/'

StackProf.run(mode: ENV.key?('WALL') ? :wall : :cpu, interval: Integer(ENV.fetch('INTERVAL', '100')), out: 'stackprof.dump') do
  i = 0
  while i < 10
    app.get(path)
    i += 1
  end
end
