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

## Stackprof
### cpu

```
$ bundle exec ruby profile.rb
$ stackprof stackprof.dump
==================================
  Mode: cpu(1)
  Samples: 1850 (0.00% miss rate)
  GC: 115 (6.22%)
==================================
     TOTAL    (pct)     SAMPLES    (pct)     FRAME
       148   (8.0%)         120   (6.5%)     block in <class:Base>
        95   (5.1%)          95   (5.1%)     Rack::Utils::HeaderHash#[]=
       172   (9.3%)          94   (5.1%)     Sinatra::Helpers#content_type
        93   (5.0%)          93   (5.0%)     (sweeping)
        89   (4.8%)          89   (4.8%)     Rack::Request::Env#get_header
        71   (3.8%)          71   (3.8%)     Rack::Utils::HeaderHash#[]
       104   (5.6%)          69   (3.7%)     Rack::Protection::Base#html?
        61   (3.3%)          61   (3.3%)     Rack::Protection::PathTraversal#cleanup
        45   (2.4%)          45   (2.4%)     MonitorMixin#mon_initialize
       212  (11.5%)          40   (2.2%)     Sinatra::Base#process_route
       215  (11.6%)          39   (2.1%)     block in <class:Base>
        51   (2.8%)          39   (2.1%)     Sinatra::Base#filter!
       762  (41.2%)          35   (1.9%)     Sinatra::Base#invoke
        42   (2.3%)          35   (1.9%)     Sinatra::Base#settings
        49   (2.6%)          35   (1.9%)     Rack::Utils::HeaderHash#each
        35   (1.9%)          35   (1.9%)     Sinatra::IndifferentHash#initialize
        33   (1.8%)          33   (1.8%)     block in set
        30   (1.6%)          30   (1.6%)     Mustermann::RegexpBased#match
        36   (1.9%)          29   (1.6%)     Sinatra::Base.compile!
       176   (9.5%)          28   (1.5%)     block in <class:Base>
        27   (1.5%)          27   (1.5%)     Rack::Request::Env#initialize
        67   (3.6%)          26   (1.4%)     Sinatra::Response#finish
        39   (2.1%)          26   (1.4%)     Sinatra::Base#error_block!
        25   (1.4%)          25   (1.4%)     Rack::Protection::Base#safe?
        47   (2.5%)          24   (1.3%)     Sinatra::Base.mime_type
      1735  (93.8%)          23   (1.2%)     block in <main>
        54   (2.9%)          23   (1.2%)     Sinatra::Helpers#body
        23   (1.2%)          23   (1.2%)     #<Module:0x000055ffe5638ef0>.mime_type
        22   (1.2%)          22   (1.2%)     (marking)
        33   (1.8%)          21   (1.1%)     Rack::Response#initialize

$ bundle exec ruby --jit profile.rb
$ stackprof stackprof.dump
==================================
  Mode: cpu(1)
  Samples: 2260 (0.00% miss rate)
  GC: 146 (6.46%)
==================================
     TOTAL    (pct)     SAMPLES    (pct)     FRAME
       169   (7.5%)         139   (6.2%)     block in <class:Base>
       131   (5.8%)         131   (5.8%)     Rack::Utils::HeaderHash#[]=
       121   (5.4%)         121   (5.4%)     (sweeping)
       114   (5.0%)         114   (5.0%)     Rack::Request::Env#get_header
       208   (9.2%)         112   (5.0%)     Sinatra::Helpers#content_type
       281  (12.4%)          82   (3.6%)     block in <class:Base>
        81   (3.6%)          81   (3.6%)     Rack::Protection::PathTraversal#cleanup
        79   (3.5%)          79   (3.5%)     Rack::Utils::HeaderHash#[]
       121   (5.4%)          78   (3.5%)     Rack::Protection::Base#html?
        56   (2.5%)          56   (2.5%)     Sinatra::Base#settings
        66   (2.9%)          54   (2.4%)     Sinatra::Base#filter!
        52   (2.3%)          52   (2.3%)     MonitorMixin#mon_initialize
        50   (2.2%)          50   (2.2%)     Rack::Request::Env#initialize
       907  (40.1%)          49   (2.2%)     Sinatra::Base#invoke
        46   (2.0%)          46   (2.0%)     Mustermann::RegexpBased#match
        45   (2.0%)          45   (2.0%)     Sinatra::IndifferentHash#initialize
        44   (1.9%)          44   (1.9%)     block in set
        62   (2.7%)          43   (1.9%)     Rack::Utils::HeaderHash#each
      2114  (93.5%)          36   (1.6%)     block in <main>
        43   (1.9%)          35   (1.5%)     Sinatra::Base.compile!
        52   (2.3%)          33   (1.5%)     Rack::Response#initialize
        32   (1.4%)          32   (1.4%)     Rack::Protection::Base#safe?
        31   (1.4%)          31   (1.4%)     #<Module:0x00005627101131a8>.mime_type
        69   (3.1%)          31   (1.4%)     Sinatra::Response#finish
       199   (8.8%)          30   (1.3%)     block in <class:Base>
        60   (2.7%)          29   (1.3%)     Sinatra::Base.mime_type
        44   (1.9%)          26   (1.2%)     Rack::Protection::JsonCsrf#has_vector?
       253  (11.2%)          26   (1.2%)     Sinatra::Base#process_route
        25   (1.1%)          25   (1.1%)     (marking)
        43   (1.9%)          24   (1.1%)     Sinatra::Base#error_block!
```

### wall
```
$ MODE=wall INTERVAL=10 bundle exec ruby profile.rb
$ stackprof stackprof.dump
==================================
  Mode: wall(10)
  Samples: 1236566 (0.04% miss rate)
  GC: 71882 (5.81%)
==================================
     TOTAL    (pct)     SAMPLES    (pct)     FRAME
    107959   (8.7%)       81778   (6.6%)     block in <class:Base>
     74406   (6.0%)       74406   (6.0%)     Rack::Utils::HeaderHash#[]=
     66856   (5.4%)       66856   (5.4%)     Rack::Request::Env#get_header
     61631   (5.0%)       61631   (5.0%)     (sweeping)
    121048   (9.8%)       58112   (4.7%)     Sinatra::Helpers#content_type
     47943   (3.9%)       47943   (3.9%)     Rack::Utils::HeaderHash#[]
     45388   (3.7%)       45388   (3.7%)     Rack::Protection::PathTraversal#cleanup
    165691  (13.4%)       36163   (2.9%)     block in <class:Base>
     33204   (2.7%)       33204   (2.7%)     block in set
     54588   (4.4%)       32346   (2.6%)     Rack::Protection::Base#html?
     37261   (3.0%)       29737   (2.4%)     Sinatra::Base#filter!
     32472   (2.6%)       28807   (2.3%)     Sinatra::Base#settings
     26972   (2.2%)       26972   (2.2%)     MonitorMixin#mon_initialize
    146950  (11.9%)       25160   (2.0%)     Sinatra::Base#process_route
     24888   (2.0%)       24888   (2.0%)     Mustermann::RegexpBased#match
     22501   (1.8%)       22501   (1.8%)     Rack::Request::Env#initialize
     29028   (2.3%)       22242   (1.8%)     Rack::Utils::HeaderHash#each
    525011  (42.5%)       21835   (1.8%)     Sinatra::Base#invoke
    129528  (10.5%)       21569   (1.7%)     block in <class:Base>
     33767   (2.7%)       21368   (1.7%)     Rack::Response#initialize
     34591   (2.8%)       20910   (1.7%)     Sinatra::Base.mime_type
     18836   (1.5%)       18836   (1.5%)     Sinatra::IndifferentHash#initialize
   1164684  (94.2%)       17125   (1.4%)     block in <main>
     49443   (4.0%)       16739   (1.4%)     Sinatra::Response#finish
     20203   (1.6%)       16428   (1.3%)     Sinatra::Base.compile!
     26485   (2.1%)       15343   (1.2%)     Rack::Protection::JsonCsrf#has_vector?
     14591   (1.2%)       14591   (1.2%)     Rack::BodyProxy#initialize
     13681   (1.1%)       13681   (1.1%)     #<Module:0x000055e2d65dbbc8>.mime_type
     19742   (1.6%)       11714   (0.9%)     Sinatra::Base#error_block!
     20041   (1.6%)       11655   (0.9%)     Rack::Utils::HeaderHash.[]

$ MODE=wall INTERVAL=10 bundle exec ruby --jit profile.rb
$ stackprof stackprof.dump
==================================
  Mode: wall(10)
  Samples: 1522274 (0.11% miss rate)
  GC: 75341 (4.95%)
==================================
     TOTAL    (pct)     SAMPLES    (pct)     FRAME
     92639   (6.1%)       92639   (6.1%)     Rack::Request::Env#get_header
    117903   (7.7%)       89299   (5.9%)     block in <class:Base>
     85101   (5.6%)       85101   (5.6%)     Rack::Utils::HeaderHash#[]=
    138437   (9.1%)       83158   (5.5%)     Sinatra::Helpers#content_type
     64404   (4.2%)       64404   (4.2%)     (sweeping)
     64283   (4.2%)       64283   (4.2%)     Rack::Utils::HeaderHash#[]
     78886   (5.2%)       45858   (3.0%)     Rack::Protection::Base#html?
     40846   (2.7%)       40846   (2.7%)     Rack::Request::Env#initialize
     40572   (2.7%)       40572   (2.7%)     Rack::Protection::PathTraversal#cleanup
     45974   (3.0%)       39728   (2.6%)     Sinatra::Base#filter!
     39643   (2.6%)       39643   (2.6%)     block in set
     36380   (2.4%)       36380   (2.4%)     Sinatra::Base#settings
    178555  (11.7%)       36114   (2.4%)     block in <class:Base>
    195408  (12.8%)       33304   (2.2%)     Sinatra::Base#process_route
     43715   (2.9%)       33028   (2.2%)     Rack::Utils::HeaderHash#each
     32391   (2.1%)       32391   (2.1%)     Sinatra::IndifferentHash#initialize
    654296  (43.0%)       25936   (1.7%)     Sinatra::Base#invoke
     25862   (1.7%)       25862   (1.7%)     Mustermann::RegexpBased#match
    142441   (9.4%)       24538   (1.6%)     block in <class:Base>
     23592   (1.5%)       23592   (1.5%)     MonitorMixin#mon_initialize
     36047   (2.4%)       22500   (1.5%)     Rack::Response#initialize
     32840   (2.2%)       22443   (1.5%)     Sinatra::Base.force_encoding
     28994   (1.9%)       20618   (1.4%)     Sinatra::Base#error_block!
   1446933  (95.1%)       20603   (1.4%)     block in <main>
     25699   (1.7%)       20097   (1.3%)     Sinatra::Base.compile!
     19882   (1.3%)       19882   (1.3%)     Rack::Protection::Base#safe?
     32869   (2.2%)       19512   (1.3%)     Sinatra::Base.mime_type
     32243   (2.1%)       18842   (1.2%)     Rack::Protection::JsonCsrf#has_vector?
     18094   (1.2%)       18094   (1.2%)     Logger#level=
     17473   (1.1%)       17473   (1.1%)     Sinatra::IndifferentHash#merge!
```

## Perf
### report

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

### stat
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

### stat (more)
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

## debug\_counter

TODO

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
