# Sinatra Benchmark

Simple Ruby benchmark using Sinatra.

Inspired by: https://www.rubyguides.com/2018/11/ruby-mjit/

## Run

```
$ bundle exec ruby app.rb
```

```
$ ab -c 20 -t 10 http://localhost:4567/
```

## In-process benchmark

```
$ bundle exec ruby bench.rb
benchmark: 20000/20000
11729.13 rps
```

```
$ WARMUP=1000 REQUESTS=10000 bundle exec ruby bench.rb
warmup: 1000/1000
benchmark: 10000/10000
12513.68 rps
```

## Profiling

```
$ bundle exec ruby profile.rb
$ stackprof stackprof.dump
==================================
  Mode: cpu(1)
  Samples: 1375 (0.00% miss rate)
  GC: 65 (4.73%)
==================================
     TOTAL    (pct)     SAMPLES    (pct)     FRAME
       137  (10.0%)         134   (9.7%)     Rack::CommonLogger#log
       155  (11.3%)          86   (6.3%)     Rack::MockRequest.env_for
        85   (6.2%)          85   (6.2%)     Rack::Utils::HeaderHash#[]=
        88   (6.4%)          71   (5.2%)     block in <class:Base>
        65   (4.7%)          65   (4.7%)     Rack::Utils::HeaderHash#[]
        65   (4.7%)          65   (4.7%)     (garbage collection)
       101   (7.3%)          54   (3.9%)     Sinatra::Helpers#content_type
        46   (3.3%)          46   (3.3%)     Rack::Request::Env#get_header
        43   (3.1%)          43   (3.1%)     Sinatra::Base.settings
        62   (4.5%)          40   (2.9%)     Rack::Protection::Base#html?
        34   (2.5%)          34   (2.5%)     URI::RFC2396_Parser#split
        69   (5.0%)          32   (2.3%)     Rack::Utils::HeaderHash#each
       140  (10.2%)          29   (2.1%)     block in <class:Base>
        26   (1.9%)          26   (1.9%)     Rack::Protection::PathTraversal#cleanup
        26   (1.9%)          26   (1.9%)     MonitorMixin#mon_initialize
        25   (1.8%)          25   (1.8%)     block in set
       111   (8.1%)          23   (1.7%)     block in <class:Base>
        39   (2.8%)          22   (1.6%)     Rack::Utils::HeaderHash.new
        20   (1.5%)          20   (1.5%)     Rack::Request::Env#initialize
        19   (1.4%)          19   (1.4%)     Rack::BodyProxy#respond_to?
        17   (1.2%)          17   (1.2%)     Rack::Utils::HeaderHash#initialize
      1003  (72.9%)          16   (1.2%)     Rack::CommonLogger#call
        16   (1.2%)          16   (1.2%)     Rack::Protection::Base#safe?
        24   (1.7%)          16   (1.2%)     Sinatra::Base.force_encoding
        15   (1.1%)          15   (1.1%)     Mustermann::RegexpBased#match
        15   (1.1%)          15   (1.1%)     Sinatra::IndifferentHash#initialize
        23   (1.7%)          14   (1.0%)     Sinatra::Base#filter!
        14   (1.0%)          14   (1.0%)     Rack::Utils::HeaderHash#names
       384  (27.9%)          13   (0.9%)     Sinatra::Base#invoke
       157  (11.4%)          13   (0.9%)     Rack::Response#initialize
```

```
$ WALL=1 INTERVAL=10 bundle exec ruby profile.rb
$ stackprof stackprof.dump
==================================
  Mode: wall(10)
  Samples: 892436 (0.81% miss rate)
  GC: 31569 (3.54%)
==================================
     TOTAL    (pct)     SAMPLES    (pct)     FRAME
     78829   (8.8%)       75182   (8.4%)     Rack::CommonLogger#log
     67511   (7.6%)       67511   (7.6%)     Rack::Utils::HeaderHash#[]=
     89847  (10.1%)       45687   (5.1%)     Rack::MockRequest.env_for
     54988   (6.2%)       44352   (5.0%)     block in <class:Base>
     42482   (4.8%)       42482   (4.8%)     Rack::Utils::HeaderHash#[]
     33814   (3.8%)       33814   (3.8%)     Rack::Request::Env#get_header
     31569   (3.5%)       31569   (3.5%)     (garbage collection)
     67437   (7.6%)       30086   (3.4%)     Sinatra::Helpers#content_type
     32452   (3.6%)       27081   (3.0%)     Rack::Protection::Base#html?
     26837   (3.0%)       26837   (3.0%)     Rack::Protection::PathTraversal#cleanup
     26730   (3.0%)       26730   (3.0%)     Sinatra::Base.settings
     83654   (9.4%)       19170   (2.1%)     block in <class:Base>
     17436   (2.0%)       17436   (2.0%)     Mustermann::RegexpBased#match
     16546   (1.9%)       16546   (1.9%)     URI::RFC2396_Parser#split
     21696   (2.4%)       16270   (1.8%)     Rack::Utils::HeaderHash.new
     15218   (1.7%)       15218   (1.7%)     block in set
     15101   (1.7%)       15101   (1.7%)     Rack::Utils::HeaderHash#names
     80403   (9.0%)       14535   (1.6%)     Sinatra::Base#process_route
     16085   (1.8%)       12135   (1.4%)     Sinatra::Base#filter!
     11341   (1.3%)       11341   (1.3%)     Rack::Request::Env#initialize
     11100   (1.2%)       11100   (1.2%)     Rack::BodyProxy#respond_to?
    269508  (30.2%)       10990   (1.2%)     Sinatra::Base#invoke
    102349  (11.5%)       10870   (1.2%)     Rack::Response#initialize
     10850   (1.2%)       10850   (1.2%)     Sinatra::IndifferentHash#initialize
     10480   (1.2%)       10480   (1.2%)     #<Module:0x0000563b0fa98990>.mime_type
     10109   (1.1%)       10109   (1.1%)     block in <top (required)>
     30006   (3.4%)       10000   (1.1%)     Rack::Utils::HeaderHash#each
     44160   (4.9%)        9992   (1.1%)     Rack::MockRequest.parse_uri_rfc2396
     64484   (7.2%)        9496   (1.1%)     block in <class:Base>
      9325   (1.0%)        9325   (1.0%)     Logger#level=
```

## Perf

```
$ sudo perf record -c 10000 ~/.rbenv/versions/ruby/bin/ruby -v bench.rb
ruby 2.6.0dev (2018-11-22 trunk 65928) [x86_64-linux]
benchmark: 20000/20000
7351.28 rps
[ perf record: Woken up 18 times to write data ]
[ perf record: Captured and wrote 4.453 MB perf.data (142591 samples) ]

$ sudo perf report
Samples: 142K of event 'cycles:ppp', Event count (approx.): 1425910000
Overhead  Command  Shared Object       Symbol
  20.03%  ruby     ruby                [.] vm_exec_core
   4.10%  ruby     ruby                [.] vm_call_cfunc
   2.41%  ruby     ruby                [.] st_lookup
   2.28%  ruby     ruby                [.] gc_sweep_step
   1.98%  ruby     ruby                [.] method_entry_get
   1.94%  ruby     ruby                [.] vm_call_iseq_setup
   1.94%  ruby     libc-2.27.so        [.] _int_malloc
   1.57%  ruby     ruby                [.] rb_memhash
   1.32%  ruby     ruby                [.] vm_call_iseq_setup_normal_0start_0params_0locals
   1.31%  ruby     ruby                [.] rb_class_of
   1.05%  ruby     ruby                [.] setup_parameters_complex
   1.02%  ruby     ruby                [.] rb_wb_protected_newobj_of
   0.99%  ruby     ruby                [.] rb_enc_get
   0.93%  ruby     libc-2.27.so        [.] cfree@GLIBC_2.2.5
   0.89%  ruby     ruby                [.] match_at
   0.87%  ruby     ruby                [.] vm_call_iseq_setup_normal_0start_1params_1locals
   0.82%  ruby     libc-2.27.so        [.] malloc
   0.79%  ruby     ruby                [.] rb_vm_exec
   0.69%  ruby     ruby                [.] find_entry
   0.68%  ruby     ruby                [.] vm_call0_body.constprop.403
   0.63%  ruby     libc-2.27.so        [.] malloc_consolidate
   0.62%  ruby     ruby                [.] ruby_yyparse
   0.62%  ruby     ruby                [.] st_update
   0.60%  ruby     ruby                [.] objspace_malloc_increase.isra.74
   0.58%  ruby     ruby                [.] vm_call_method_each_type
   0.56%  ruby     ruby                [.] rb_enc_mbclen
   0.56%  ruby     libc-2.27.so        [.] __malloc_usable_size
   0.54%  ruby     ruby                [.] vm_call_ivar
   0.54%  ruby     ruby                [.] BSD_vfprintf
   0.54%  ruby     ruby                [.] prepare_callable_method_entry
   0.53%  ruby     ruby                [.] rb_hash_aref
```

```
$ sudo perf stat ~/.rbenv/versions/ruby/bin/ruby -v bench.rb
ruby 2.6.0dev (2018-11-22 trunk 65928) [x86_64-linux]
benchmark: 20000/20000
8167.81 rps

 Performance counter stats for '/home/k0kubun/.rbenv/versions/ruby/bin/ruby -v bench.rb':

       2640.596954      task-clock (msec)         #    1.000 CPUs utilized
                43      context-switches          #    0.016 K/sec
                 0      cpu-migrations            #    0.000 K/sec
             4,005      page-faults               #    0.002 M/sec
    10,970,470,396      cycles                    #    4.155 GHz
    10,886,137,530      instructions              #    0.99  insn per cycle
     2,217,839,446      branches                  #  839.901 M/sec
        93,942,940      branch-misses             #    4.24% of all branches

       2.641235929 seconds time elapsed

```

```
$ sudo perf stat -e "task-clock,cycles,instructions,branches,branch-misses,cache-misses,cache-references,l1d_pend_miss.pending_cycles,l1d_pend_miss.pending_cycles_any,l2_rqsts.all_code_rd,l2_rqsts.code_rd_hit,dsb2mite_switches.penalty_cycles,icache.hit,icache.ifdata_stall,icache.ifetch_stall,icache.misses,idq.all_dsb_cycles_4_uops,idq.all_dsb_cycles_any_uops,idq.all_mite_cycles_4_uops,idq.all_mite_cycles_any_uops,idq.dsb_cycles,idq.dsb_uops,l2_rqsts.code_rd_hit,l2_rqsts.code_rd_miss" ~/.rbenv/versions/ruby/bin/ruby -v bench.rb
ruby 2.6.0dev (2018-11-22 trunk 65928) [x86_64-linux]
benchmark: 20000/20000
7682.00 rps

 Performance counter stats for '/home/k0kubun/.rbenv/versions/ruby/bin/ruby -v bench.rb':

       2808.706787      task-clock (msec)         #    1.000 CPUs utilized
    11,556,658,543      cycles                    #    4.115 GHz                      (17.19%)
    11,010,674,914      instructions              #    0.95  insn per cycle           (21.60%)
     2,255,839,653      branches                  #  803.160 M/sec                    (21.74%)
        97,469,385      branch-misses             #    4.32% of all branches          (21.89%)
         2,092,016      cache-misses              #    0.627 % of all cache refs      (22.03%)
       333,919,915      cache-references          #  118.887 M/sec                    (22.07%)
     3,430,040,847      l1d_pend_miss.pending_cycles # 1221.217 M/sec                    (17.66%)
     3,803,438,804      l1d_pend_miss.pending_cycles_any # 1354.160 M/sec                    (4.41%)
       452,630,394      l2_rqsts.all_code_rd      #  161.153 M/sec                    (8.83%)
       272,212,616      l2_rqsts.code_rd_hit      #   96.917 M/sec                    (13.24%)
       265,403,509      dsb2mite_switches.penalty_cycles #   94.493 M/sec                    (17.65%)
     5,552,988,901      icache.hit                # 1977.063 M/sec                    (17.66%)
     1,592,466,152      icache.ifdata_stall       #  566.975 M/sec                    (17.60%)
     1,583,678,408      icache.ifetch_stall       #  563.846 M/sec                    (17.46%)
       189,897,687      icache.misses             #   67.610 M/sec                    (17.31%)
     1,122,898,168      idq.all_dsb_cycles_4_uops #  399.792 M/sec                    (17.17%)
     1,921,014,743      idq.all_dsb_cycles_any_uops #  683.950 M/sec                    (17.09%)
     1,043,781,103      idq.all_mite_cycles_4_uops #  371.623 M/sec                    (17.09%)
     3,895,863,017      idq.all_mite_cycles_any_uops # 1387.066 M/sec                    (17.09%)
     1,898,632,792      idq.dsb_cycles            #  675.981 M/sec                    (17.09%)
     6,110,250,945      idq.dsb_uops              # 2175.468 M/sec                    (17.09%)
       273,362,834      l2_rqsts.code_rd_hit      #   97.327 M/sec                    (17.09%)
       177,740,813      l2_rqsts.code_rd_miss     #   63.282 M/sec                    (17.09%)

       2.809407458 seconds time elapsed

```

## benchmark-driver

```
$ benchmark-driver driver.yml --rbenv 'ruby;ruby+jit::ruby --jit;jruby-9.2.11.0;jruby-9.2.11.0+indy::jruby-9.2.11.0 -Xcompile.invokedynamic=true;truffleruby-20.0.0' -v
ruby: ruby 2.8.0dev (2020-03-14T09:17:17Z mjit-optcarrot-com.. 666194559f) [x86_64-linux]
ruby+jit: ruby 2.8.0dev (2020-03-14T09:17:17Z mjit-optcarrot-com.. 666194559f) +JIT [x86_64-linux]
jruby-9.2.11.0: jruby 9.2.11.0 (2.5.7) 2020-03-02 612d7a05a6 Java HotSpot(TM) 64-Bit Server VM 25.211-b12 on 1.8.0_211-b12 +jit [linux-x86_64]
jruby-9.2.11.0+indy: jruby 9.2.11.0 (2.5.7) 2020-03-02 612d7a05a6 Java HotSpot(TM) 64-Bit Server VM 25.211-b12 on 1.8.0_211-b12 +indy +jit [linux-x86_64]
truffleruby-20.0.0: truffleruby 20.0.0, like ruby 2.6.5, GraalVM CE Native [x86_64-linux]
Calculating -------------------------------------
                           ruby    ruby+jit  jruby-9.2.11.0  jruby-9.2.11.0+indy  truffleruby-20.0.0
             sinatra    15.532k     13.889k         13.510k              17.720k             22.081k i/s -    100.000k times in 6.438121s 7.200001s 7.401869s 5.643458s 4.528695s

Comparison:
                          sinatra
  truffleruby-20.0.0:     22081.4 i/s
 jruby-9.2.11.0+indy:     17719.6 i/s - 1.25x  slower
                ruby:     15532.5 i/s - 1.42x  slower
            ruby+jit:     13888.9 i/s - 1.59x  slower
      jruby-9.2.11.0:     13510.1 i/s - 1.63x  slower
```

## License

MIT License
