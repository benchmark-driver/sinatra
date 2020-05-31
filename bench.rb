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
if defined?(RubyVM) && RubyVM.respond_to?(:reset_debug_counters)
  RubyVM.reset_debug_counters
end

# benchmark
if use_perf = ENV.key?('PERF')
  require 'shellwords'
  pid = Process.spawn('perf', *ENV['PERF'].shellsplit, '-p', Process.pid.to_s)
end
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

if defined?(RubyVM) && RubyVM.respond_to?(:reset_debug_counters)
  RubyVM.show_debug_counters
end
if use_perf
  Process.kill(:INT, pid)
  Process.wait(pid)
end

# print result
puts "#{"%.2f" % (requests.to_f / time)} rps"
