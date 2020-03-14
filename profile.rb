require_relative 'app'
require 'stackprof'

requests = Integer(ENV.fetch('REQUESTS', '100000'))

app = Sinatra::Application
env = Rack::MockRequest.env_for('/', { method: Rack::GET })

# warmup
i = 0
while i < requests
  app.call(env.dup)
  i += 1
end

if defined?(RubyVM::MJIT) && RubyVM::MJIT.enabled?
  RubyVM::MJIT.pause
end

StackProf.run(mode: ENV.fetch('MODE', 'cpu').to_sym, interval: Integer(ENV.fetch('INTERVAL', '1')), out: 'stackprof.dump') do
  i = 0
  while i < requests
    app.call(env.dup)
    i += 1
  end
end
