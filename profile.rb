require_relative 'app'
require 'stackprof'

app = Rack::MockRequest.new(Sinatra::Application)
path = '/'

StackProf.run(mode: ENV.key?('WALL') ? :wall : :cpu, interval: Integer(ENV.fetch('INTERVAL', '1')), out: 'stackprof.dump') do
  i = 0
  while i < 50000
    app.get(path)
    i += 1
  end
end
