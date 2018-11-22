require_relative 'app'

warmup = Integer(ENV.fetch('WARMUP', '0'))
requests = Integer(ENV.fetch('REQUESTS', '20000'))

app = Rack::MockRequest.new(Sinatra::Application)
path = '/'

# warmup
if warmup > 0
  i = 1
  while i <= warmup
    app.get(path)
    print "warmup: #{i}/#{requests}\r"
    i += 1
  end
  puts
end

# benchmark
i = 1
time = 0.0
while i <= requests
  before = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  app.get(path)
  after = Process.clock_gettime(Process::CLOCK_MONOTONIC)

  time += after - before
  print "benchmark: #{i}/#{requests}\r"
  i += 1
end
puts

# print result
puts "#{"%.2f" % (requests.to_f / time)} rps"
