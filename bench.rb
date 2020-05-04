require_relative 'app'

warmup = Integer(ENV.fetch('WARMUP', '0'))
requests = Integer(ENV.fetch('REQUESTS', '20000'))

app = Sinatra::Application
env = Rack::MockRequest.env_for('/', { method: Rack::GET })

# warmup
if warmup > 0
  i = 1
  while i <= warmup
    app.call(env.dup)
    print "warmup: #{i}/#{warmup}\r"
    i += 1
  end
  puts
end

if defined?(RubyVM::MJIT) && RubyVM::MJIT.enabled?
  RubyVM::MJIT.pause
  app.call(env.dup) # issue recompile
  RubyVM::MJIT.resume
  RubyVM::MJIT.pause # finish recompile
  app.call(env.dup) # issue recompile
  RubyVM::MJIT.resume
  RubyVM::MJIT.pause # finish recompile
end

# benchmark
Process.spawn(
  '/home/k0kubun/intel/vtune_profiler/bin64/vtune', '-collect',

  #'hotspots', '-run-pass-thru=--no-altstack',
  #'hotspots', '-knob', 'sampling-mode=hw',
  'uarch-exploration', '-knob', 'sampling-interval=0.5',
  #'memory-access',

  "-user-data-dir=/home/k0kubun/intel/vtune/projects/sinatra-#{RubyVM::MJIT.enabled? ? 'jit' : 'vm'}",
  "-target-pid=#{Process.pid}",
)
i = 1
time = 0.0
while i <= requests
  dup_env = env.dup
  before = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  app.call(dup_env)
  after = Process.clock_gettime(Process::CLOCK_MONOTONIC)

  time += after - before
  print "benchmark: #{i}/#{requests}\r"
  i += 1
end
puts

# print result
puts "#{"%.2f" % (requests.to_f / time)} rps"
