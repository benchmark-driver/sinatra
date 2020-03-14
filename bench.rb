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
    print "warmup: #{i}/#{warmup}\r"
    i += 1
  end
  puts
end

if defined?(RubyVM::MJIT) && RubyVM::MJIT.enabled?
  RubyVM::MJIT.pause
end

# benchmark
if use_perf = ENV.key?('PERF')
  pid = Process.spawn('perf', 'stat', '-p', Process.pid.to_s, '-e', 'task-clock,cycles,instructions,branches,branch-misses,cache-misses,cache-references,l1d_pend_miss.pending_cycles,l1d_pend_miss.pending_cycles_any,l2_rqsts.all_code_rd,l2_rqsts.code_rd_hit,dsb2mite_switches.penalty_cycles,icache.hit,icache.ifdata_stall,icache.ifetch_stall,icache.misses,idq.all_dsb_cycles_4_uops,idq.all_dsb_cycles_any_uops,idq.all_mite_cycles_4_uops,idq.all_mite_cycles_any_uops,idq.dsb_cycles,idq.dsb_uops,l2_rqsts.code_rd_hit,l2_rqsts.code_rd_miss')
end
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
if use_perf
  Process.kill(:INT, pid)
  Process.wait(pid)
end

# print result
puts "#{"%.2f" % (requests.to_f / time)} rps"
