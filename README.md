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

```bash
$ bundle exec ruby -v bench.rb
ruby 2.8.0dev (2020-03-14T09:17:17Z master 666194559f) [x86_64-linux]
benchmark: 20000/20000
13089.20 rps

# WARMUP=0 has no meaning for --jit
```

```
$ WARMUP=20000 REQUESTS=20000 bundle exec ruby -v bench.rb
ruby 2.8.0dev (2020-03-14T09:17:17Z master 666194559f) [x86_64-linux]
warmup: 20000/20000
benchmark: 20000/20000
12988.64 rps

$ WARMUP=20000 REQUESTS=20000 bundle exec ruby -v --jit bench.rb
ruby 2.8.0dev (2020-03-14T09:17:17Z master 666194559f) +JIT [x86_64-linux]
warmup: 20000/20000
benchmark: 20000/20000
11602.35 rps
```

## Stackprof
### cpu

```
$ bundle exec ruby -v profile.rb
ruby 2.8.0dev (2020-03-14T09:17:17Z master 666194559f) [x86_64-linux]
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

$ bundle exec ruby -v --jit profile.rb
ruby 2.8.0dev (2020-03-14T09:17:17Z master 666194559f) +JIT [x86_64-linux]
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
$ MODE=wall INTERVAL=10 bundle exec ruby -v profile.rb
ruby 2.8.0dev (2020-03-14T09:17:17Z master 666194559f) [x86_64-linux]
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

$ MODE=wall INTERVAL=10 bundle exec ruby -v --jit profile.rb
ruby 2.8.0dev (2020-03-14T09:17:17Z master 666194559f) +JIT [x86_64-linux]
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
$ PERF="record -c 10000" WARMUP=20000 REQUESTS=20000 sudo -E ~/.rbenv/versions/ruby/bin/ruby -v bench.rb
ruby 2.8.0dev (2020-03-14T09:17:17Z master 666194559f) [x86_64-linux]
warmup: 20000/20000
benchmark: 20000/20000
[ perf record: Woken up 10 times to write data ]
[ perf record: Captured and wrote 2.442 MB perf.data (78226 samples) ]
11761.22 rps

$ sudo perf report
Samples: 78K of event 'cycles:ppp', Event count (approx.): 782260000
Overhead  Command  Shared Object       Symbol
  20.17%  ruby     ruby                [.] vm_exec_core
   4.70%  ruby     ruby                [.] vm_call_cfunc
   2.81%  ruby     ruby                [.] rb_id_table_lookup
   2.38%  ruby     ruby                [.] gc_sweep_step
   1.88%  ruby     ruby                [.] rb_memhash
   1.78%  ruby     ruby                [.] rb_st_lookup
   1.63%  ruby     ruby                [.] CALLER_SETUP_ARG
   1.57%  ruby     ruby                [.] rb_class_of
   1.49%  ruby     ruby                [.] vm_call_iseq_setup_normal_0start_0params_0locals
   1.39%  ruby     ruby                [.] rb_vm_search_method_slowpath
   1.18%  ruby     ruby                [.] vm_call_iseq_setup_normal_0start_1params_1locals
   1.13%  ruby     libc-2.27.so        [.] _int_malloc
   1.12%  ruby     ruby                [.] callable_method_entry.constprop.440
   1.03%  ruby     ruby                [.] rb_wb_protected_newobj_of
   0.99%  ruby     ruby                [.] rb_vm_exec
   0.99%  ruby     ruby                [.] vm_call_iseq_setup
   0.97%  ruby     libc-2.27.so        [.] cfree@GLIBC_2.2.5
   0.92%  ruby     ruby                [.] rb_enc_get
   0.84%  ruby     ruby                [.] rb_enc_mbclen
   0.78%  ruby     libc-2.27.so        [.] malloc
   0.74%  ruby     ruby                [.] rb_vm_call0
   0.74%  ruby     ruby                [.] match_at
   0.68%  ruby     ruby                [.] vm_call_ivar
   0.61%  ruby     ruby                [.] rb_file_expand_path_internal
   0.61%  ruby     ruby                [.] vm_call_iseq_setup_normal_opt_start
   0.56%  ruby     ruby                [.] rb_obj_is_kind_of
   0.55%  ruby     libc-2.27.so        [.] __malloc_usable_size
   0.54%  ruby     ruby                [.] vm_setivar
   0.53%  ruby     ruby                [.] rb_enc_set_index
   0.52%  ruby     ruby                [.] vm_search_super_method
   0.51%  ruby     ruby                [.] vm_call_iseq_setup_normal_0start_1params_2locals
   0.49%  ruby     ruby                [.] method_entry_resolve_refinement


$ PERF="record -c 10000" WARMUP=20000 REQUESTS=20000 sudo -E ~/.rbenv/versions/ruby/bin/ruby -v --jit-debug=-g1 --jit-save-temps bench.rb
ruby 2.8.0dev (2020-03-14T09:17:17Z master 666194559f) +JIT [x86_64-linux]
warmup: 20000/20000
benchmark: 20000/20000
[ perf record: Woken up 13 times to write data ]
[ perf record: Captured and wrote 3.082 MB perf.data (98476 samples) ]
10052.47 rps

$ sudo perf report
Samples: 98K of event 'cycles:ppp', Event count (approx.): 984760000
Overhead  Command  Shared Object            Symbol
   7.82%  ruby     ruby                     [.] vm_exec_core
   4.57%  ruby     ruby                     [.] vm_call_cfunc
   3.10%  ruby     ruby                     [.] rb_id_table_lookup
   2.22%  ruby     ruby                     [.] gc_sweep_step
   1.70%  ruby     ruby                     [.] rb_st_lookup
   1.66%  ruby     ruby                     [.] rb_memhash
   1.55%  ruby     ruby                     [.] rb_vm_exec
   1.45%  ruby     ruby                     [.] CALLER_SETUP_ARG
   1.30%  ruby     ruby                     [.] rb_vm_search_method_slowpath
   1.05%  ruby     ruby                     [.] callable_method_entry.constprop.440
   1.02%  ruby     ruby                     [.] rb_wb_protected_newobj_of
   1.00%  ruby     libc-2.27.so             [.] _int_malloc
   0.92%  ruby     libc-2.27.so             [.] cfree@GLIBC_2.2.5
   0.85%  ruby     ruby                     [.] rb_enc_get
   0.84%  ruby     libc-2.27.so             [.] malloc
   0.83%  ruby     ruby                     [.] vm_call_iseq_setup
   0.72%  ruby     ruby                     [.] rb_enc_mbclen
   0.71%  ruby     ruby                     [.] vm_call_iseq_setup_normal_0start_0params_0locals
   0.67%  ruby     ruby                     [.] rb_vm_call0
   0.66%  ruby     ruby                     [.] vm_call_ivar
   0.65%  ruby     ruby                     [.] rb_obj_is_kind_of
   0.61%  ruby     ruby                     [.] rb_class_of
   0.61%  ruby     ruby                     [.] match_at
   0.56%  ruby     ruby                     [.] rb_file_expand_path_internal
   0.56%  ruby     ruby                     [.] vm_call_iseq_setup_normal_opt_start
   0.54%  ruby     ruby                     [.] rb_hash_aref
   0.53%  ruby     libc-2.27.so             [.] __malloc_usable_size
   0.52%  ruby     ruby                     [.] vm_yield_setup_args
   0.50%  ruby     ruby                     [.] method_entry_resolve_refinement
   0.49%  ruby     libc-2.27.so             [.] malloc_consolidate
   0.49%  ruby     ruby                     [.] rb_enc_set_index
   0.46%  ruby     ruby                     [.] setup_parameters_complex
```

### report (call graph)

```
$ PERF="record -c 10000 --call-graph dwarf" WARMUP=20000 REQUESTS=20000 sudo -E ~/.rbenv/versions/ruby/bin/ruby -v bench.rb
ruby 2.8.0dev (2020-03-14T09:17:17Z master 666194559f) [x86_64-linux]
warmup: 20000/20000
benchmark: 20000/20000
[ perf record: Woken up 893 times to write data ]
Warning:
Processed 110944 events and lost 6 chunks!

Check IO/CPU overload!

[ perf record: Captured and wrote 700.012 MB perf.data (87068 samples) ]
11361.62 rps

$ sudo perf report -i perf.data.old



$ PERF="record -c 10000 --call-graph dwarf" WARMUP=20000 REQUESTS=20000 sudo -E ~/.rbenv/versions/ruby/bin/ruby -v --jit-debug=-g1 --jit-save-temps bench.rb
ruby 2.8.0dev (2020-03-14T09:17:17Z master 666194559f) +JIT [x86_64-linux]
warmup: 20000/20000
benchmark: 20000/20000
[ perf record: Woken up 1059 times to write data ]
Warning:
Processed 134988 events and lost 11 chunks!

Check IO/CPU overload!

[ perf record: Captured and wrote 830.695 MB perf.data (103282 samples) ]
9730.67 rps

$ sudo perf report
```

### stat
```
$ PERF="stat" WARMUP=20000 REQUESTS=20000 sudo -E ~/.rbenv/versions/ruby/bin/ruby -v bench.rb
ruby 2.8.0dev (2020-03-14T09:17:17Z master 666194559f) [x86_64-linux]
warmup: 20000/20000
benchmark: 20000/20000

 Performance counter stats for process id '10211':

       1599.171103      task-clock (msec)         #    1.000 CPUs utilized
                 5      context-switches          #    0.003 K/sec
                 1      cpu-migrations            #    0.001 K/sec
               236      page-faults               #    0.148 K/sec
     6,703,825,122      cycles                    #    4.192 GHz
     6,680,974,488      instructions              #    1.00  insn per cycle
     1,342,705,221      branches                  #  839.626 M/sec
        47,979,038      branch-misses             #    3.57% of all branches

       1.599213438 seconds time elapsed

12944.64 rps

$ PERF="stat" WARMUP=20000 REQUESTS=20000 sudo -E ~/.rbenv/versions/ruby/bin/ruby -v --jit bench.rb
ruby 2.8.0dev (2020-03-14T09:17:17Z master 666194559f) +JIT [x86_64-linux]
warmup: 20000/20000
benchmark: 20000/20000

 Performance counter stats for process id '10288':

       1807.683511      task-clock (msec)         #    0.999 CPUs utilized
               107      context-switches          #    0.059 K/sec
                 0      cpu-migrations            #    0.000 K/sec
               233      page-faults               #    0.129 K/sec
     7,546,590,686      cycles                    #    4.175 GHz
     6,617,652,235      instructions              #    0.88  insn per cycle
     1,346,985,268      branches                  #  745.144 M/sec
        42,223,775      branch-misses             #    3.13% of all branches

       1.808596976 seconds time elapsed

11487.65 rps
```

### stat (more)
```
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
