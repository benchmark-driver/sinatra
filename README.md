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

## StackProf
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
ruby 2.8.0dev (2020-03-15T04:13:31Z master 67fbc122fb) [x86_64-linux]
warmup: 20000/20000
benchmark: 20000/20000
[ perf record: Woken up 839 times to write data ]
Warning:
Processed 108625 events and lost 26 chunks!

Check IO/CPU overload!

[ perf record: Captured and wrote 653.350 MB perf.data (81251 samples) ]
11341.86 rps

$ sudo perf report -i perf.data.old
Samples: 81K of event 'cycles:ppp', Event count (approx.): 812510000
  Children      Self  Command  Shared Object       Symbol
-   84.81%    20.41%  ruby     ruby                [.] vm_exec_core
   - 64.42% vm_exec_core
      - 59.29% vm_sendish (inlined)
         - 52.71% vm_call_cfunc
            - 52.17% vm_call_cfunc_with_frame (inlined)
               + 24.38% rb_f_catch
               + 7.98% rb_class_s_new
               + 3.31% rb_f_print
               + 1.98% rb_obj_dup
               + 1.91% enum_find
               + 1.88% rb_str_aref_m
                 1.26% str_gsub
               + 1.16% rb_ary_all_p
                 1.15% rb_str_downcase
               + 0.94% enum_collect
                 0.77% rb_str_split_m
         + 1.48% vm_search_method_wrap (inlined)
         - 1.32% vm_call_method
            - 1.28% vm_call_method_each_type
               - 1.20% vm_call_cfunc
                  - 1.14% vm_call_cfunc_with_frame (inlined)
                     + 0.63% rb_hash_aset
         + 0.64% vm_call_iseq_setup_normal_0start_1params_1locals
         + 0.57% vm_call_iseq_setup_normal_0start_0params_0locals
      + 1.15% vm_opt_aref (inlined)
      + 0.56% rb_ary_new_from_values
        0.55% str_duplicate
      + 0.52% vm_opt_aset (inlined)
   + 19.78% _start
+   84.23%     0.93%  ruby     ruby                [.] rb_vm_exec
+   83.80%     0.00%  ruby     ruby                [.] rb_ec_exec_node
+   83.41%     0.00%  ruby     ruby                [.] _start


$ PERF="record -c 10000 --call-graph dwarf" WARMUP=20000 REQUESTS=20000 sudo -E ~/.rbenv/versions/ruby/bin/ruby -v --jit-debug=-g1 --jit-save-temps bench.rb
ruby 2.8.0dev (2020-03-15T04:13:31Z master 67fbc122fb) +JIT [x86_64-linux]
warmup: 20000/20000
benchmark: 20000/20000
[ perf record: Woken up 1014 times to write data ]
Warning:
Processed 126579 events and lost 25 chunks!

Check IO/CPU overload!

[ perf record: Captured and wrote 792.909 MB perf.data (98601 samples) ]
9727.10 rps

$ sudo perf report
Samples: 98K of event 'cycles:ppp', Event count (approx.): 986010000
  Children      Self  Command  Shared Object            Symbol
+   81.84%     1.39%  ruby     ruby                     [.] rb_vm_exec
-   81.34%     7.59%  ruby     ruby                     [.] vm_exec_core
   - 73.75% vm_exec_core
      - 73.41% vm_sendish (inlined)
         - 68.23% mjit_exec (inlined)
            - 58.95% _mjit33_sinatra_base_rb_call
               - 58.81% _mjit34_sinatra_base_rb_synchronize
                  - 58.57% _mjit37_sinatra_base_rb_block_in_call
                     - 58.19% _mjit39_sinatra_base_rb_call
                        - 58.03% _mjit40_sinatra_base_rb_call
                           - 57.79% rb_vm_exec
                              - mjit_exec (inlined)
                                 - _mjit41_sinatra_show_exceptions_rb_call
                                    - 57.66% _mjit42_rack_method_override_rb_call
                                       - 57.32% _mjit44_rack_head_rb_call
                                          - 56.99% _mjit45_sinatra_base_rb_call
                                             - 56.82% _mjit49_rack_logger_rb_call
                                                - 52.18% _mjit56_rack_protection_frame_options_rb_call
                                                   - 49.51% rb_vm_exec
                                                      - vm_exec_core
                                                         - 49.30% vm_sendish (inlined)
                                                            - 48.44% mjit_exec (inlined)
                                                               + 47.60% _mjit60_rack_protection_json_csrf_rb_call
                                                               + 0.68% _mjit57_rack_protection_http_origin_rb_accepts_
                                                   + 1.88% _mjit26_rack_protection_base_rb_html_
                                                + 4.17% vm_call_cfunc
            + 9.26% _mjit60_rack_protection_json_csrf_rb_call
         - 5.05% vm_call_cfunc
            - 5.03% vm_call_cfunc_with_frame (inlined)
               + 3.23% rb_f_print
               + 1.29% rb_obj_dup
   + 6.09% _start
```

### report (flame graph)

Set `$PATH` for [brendangregg/FlameGraph](https://github.com/brendangregg/FlameGraph) and:

```
sudo perf script -i perf.data.old | stackcollapse-perf.pl | flamegraph.pl > docs/vm.svg
sudo perf script | stackcollapse-perf.pl | flamegraph.pl > docs/jit.svg
```

See [benchmark-driver.github.io/sinatra](https://benchmark-driver.github.io/sinatra/)

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
$ PERF="stat -e task-clock,cycles,instructions,branches,branch-misses,cache-misses,cache-references,l1d_pend_miss.pending_cycles,l1d_pend_miss.pending_cycles_any,l2_rqsts.all_code_rd,l2_rqsts.code_rd_hit,dsb2mite_switches.penalty_cycles,icache.hit,icache.ifdata_stall,icache.ifetch_stall,icache.misses,idq.all_dsb_cycles_4_uops,idq.all_dsb_cycles_any_uops,idq.all_mite_cycles_4_uops,idq.all_mite_cycles_any_uops,idq.dsb_cycles,idq.dsb_uops,l2_rqsts.code_rd_hit,l2_rqsts.code_rd_miss" WARMUP=20000 REQUESTS=20000 sudo -E ~/.rbenv/versions/ruby/bin/ruby -v bench.rb
ruby 2.8.0dev (2020-03-14T09:17:17Z master 666194559f) [x86_64-linux]
warmup: 20000/20000
benchmark: 20000/20000

 Performance counter stats for process id '11794':

       1586.574299      task-clock (msec)         #    1.000 CPUs utilized
     6,644,885,032      cycles                    #    4.188 GHz                      (17.37%)
     6,676,957,970      instructions              #    1.00  insn per cycle           (21.90%)
     1,338,058,315      branches                  #  843.363 M/sec                    (22.16%)
        47,693,924      branch-misses             #    3.56% of all branches          (22.41%)
           496,650      cache-misses              #    0.245 % of all cache refs      (22.66%)
       202,497,627      cache-references          #  127.632 M/sec                    (22.63%)
     2,153,663,578      l1d_pend_miss.pending_cycles # 1357.430 M/sec                    (17.84%)
     2,257,835,321      l1d_pend_miss.pending_cycles_any # 1423.088 M/sec                    (4.29%)
       258,617,335      l2_rqsts.all_code_rd      #  163.004 M/sec                    (8.57%)
       157,453,746      l2_rqsts.code_rd_hit      #   99.241 M/sec                    (12.86%)
       149,282,346      dsb2mite_switches.penalty_cycles #   94.091 M/sec                    (17.14%)
     3,287,563,452      icache.hit                # 2072.114 M/sec                    (17.15%)
       906,652,048      icache.ifdata_stall       #  571.453 M/sec                    (17.14%)
       903,912,325      icache.ifetch_stall       #  569.726 M/sec                    (17.14%)
       109,012,625      icache.misses             #   68.709 M/sec                    (17.15%)
       721,386,353      idq.all_dsb_cycles_4_uops #  454.682 M/sec                    (17.14%)
     1,148,099,107      idq.all_dsb_cycles_any_uops #  723.634 M/sec                    (17.14%)
       593,925,049      idq.all_mite_cycles_4_uops #  374.344 M/sec                    (17.14%)
     2,281,133,887      idq.all_mite_cycles_any_uops # 1437.773 M/sec                    (17.14%)
     1,147,362,230      idq.dsb_cycles            #  723.170 M/sec                    (17.15%)
     3,772,166,577      idq.dsb_uops              # 2377.554 M/sec                    (17.15%)
       157,512,908      l2_rqsts.code_rd_hit      #   99.279 M/sec                    (17.15%)
       100,257,436      l2_rqsts.code_rd_miss     #   63.191 M/sec                    (17.15%)

       1.586668834 seconds time elapsed

13092.99 rps

$ PERF="stat -e task-clock,cycles,instructions,branches,branch-misses,cache-misses,cache-references,l1d_pend_miss.pending_cycles,l1d_pend_miss.pending_cycles_any,l2_rqsts.all_code_rd,l2_rqsts.code_rd_hit,dsb2mite_switches.penalty_cycles,icache.hit,icache.ifdata_stall,icache.ifetch_stall,icache.misses,idq.all_dsb_cycles_4_uops,idq.all_dsb_cycles_any_uops,idq.all_mite_cycles_4_uops,idq.all_mite_cycles_any_uops,idq.dsb_cycles,idq.dsb_uops,l2_rqsts.code_rd_hit,l2_rqsts.code_rd_miss" WARMUP=20000 REQUESTS=20000 sudo -E ~/.rbenv/versions/ruby/bin/ruby -v --jit bench.rb
ruby 2.8.0dev (2020-03-14T09:17:17Z master 666194559f) +JIT [x86_64-linux]
warmup: 20000/20000
benchmark: 20000/20000

 Performance counter stats for process id '11855':

       1702.690915      task-clock (msec)         #    1.000 CPUs utilized
     7,127,572,665      cycles                    #    4.186 GHz                      (17.13%)
     6,440,625,661      instructions              #    0.90  insn per cycle           (21.60%)
     1,309,829,449      branches                  #  769.270 M/sec                    (21.83%)
        40,867,481      branch-misses             #    3.12% of all branches          (22.06%)
           352,618      cache-misses              #    0.118 % of all cache refs      (22.30%)
       300,027,391      cache-references          #  176.208 M/sec                    (22.32%)
     2,295,622,687      l1d_pend_miss.pending_cycles # 1348.232 M/sec                    (17.85%)
     2,334,120,211      l1d_pend_miss.pending_cycles_any # 1370.842 M/sec                    (4.46%)
       368,693,895      l2_rqsts.all_code_rd      #  216.536 M/sec                    (8.93%)
       174,999,317      l2_rqsts.code_rd_hit      #  102.778 M/sec                    (13.39%)
       109,452,119      dsb2mite_switches.penalty_cycles #   64.282 M/sec                    (17.85%)
     3,395,994,842      icache.hit                # 1994.487 M/sec                    (17.79%)
     1,423,286,277      icache.ifdata_stall       #  835.904 M/sec                    (17.56%)
     1,423,825,914      icache.ifetch_stall       #  836.221 M/sec                    (17.33%)
       157,340,878      icache.misses             #   92.407 M/sec                    (17.09%)
       445,461,655      idq.all_dsb_cycles_4_uops #  261.622 M/sec                    (16.91%)
       740,134,139      idq.all_dsb_cycles_any_uops #  434.685 M/sec                    (16.92%)
       571,685,478      idq.all_mite_cycles_4_uops #  335.754 M/sec                    (16.92%)
     2,396,189,589      idq.all_mite_cycles_any_uops # 1407.296 M/sec                    (16.92%)
       734,424,985      idq.dsb_cycles            #  431.332 M/sec                    (16.92%)
     2,383,169,448      idq.dsb_uops              # 1399.649 M/sec                    (16.92%)
       176,746,557      l2_rqsts.code_rd_hit      #  103.804 M/sec                    (16.92%)
       196,245,656      l2_rqsts.code_rd_miss     #  115.256 M/sec                    (16.91%)

       1.702740743 seconds time elapsed

11981.18 rps
```

## debug\_counter
### USE\_DEBUG\_COUNTER
```
$ WARMUP=20000 REQUESTS=20000 bundle exec ruby -v bench.rb
ruby 2.8.0dev (2020-03-15T09:25:47Z master d79890cbfa) [x86_64-linux]
warmup: 20000/20000
benchmark: 20000/20000
[RUBY_DEBUG_COUNTER]    16938 show_debug_counters
[RUBY_DEBUG_COUNTER]    mc_inline_hit                        9,100,014
[RUBY_DEBUG_COUNTER]    mc_inline_miss_klass                   760,016
[RUBY_DEBUG_COUNTER]    mc_inline_miss_invalidated                   0
[RUBY_DEBUG_COUNTER]    mc_cme_complement                            0
[RUBY_DEBUG_COUNTER]    mc_cme_complement_hit                        0
[RUBY_DEBUG_COUNTER]    mc_search                              660,003
[RUBY_DEBUG_COUNTER]    mc_search_notfound                     460,000
[RUBY_DEBUG_COUNTER]    mc_search_super                      3,560,003
[RUBY_DEBUG_COUNTER]    ci_packed                            1,300,008
[RUBY_DEBUG_COUNTER]    ci_kw                                        0
[RUBY_DEBUG_COUNTER]    ci_nokw                                      0
[RUBY_DEBUG_COUNTER]    ci_runtime                           1,300,008
[RUBY_DEBUG_COUNTER]    cc_new                                       2
[RUBY_DEBUG_COUNTER]    cc_temp                                      0
[RUBY_DEBUG_COUNTER]    cc_found_ccs                           760,014
[RUBY_DEBUG_COUNTER]    cc_ent_invalidate                            0
[RUBY_DEBUG_COUNTER]    cc_cme_invalidate                            0
[RUBY_DEBUG_COUNTER]    cc_invalidate_leaf                           0
[RUBY_DEBUG_COUNTER]    cc_invalidate_leaf_ccs                       0
[RUBY_DEBUG_COUNTER]    cc_invalidate_leaf_callable                  0
[RUBY_DEBUG_COUNTER]    cc_invalidate_tree                           0
[RUBY_DEBUG_COUNTER]    cc_invalidate_tree_cme                       0
[RUBY_DEBUG_COUNTER]    cc_invalidate_tree_callable                  0
[RUBY_DEBUG_COUNTER]    ccs_free                                     0
[RUBY_DEBUG_COUNTER]    ccs_maxlen                                   1
[RUBY_DEBUG_COUNTER]    ccs_found                            2,080,012
[RUBY_DEBUG_COUNTER]    iseq_num                                     0
[RUBY_DEBUG_COUNTER]    iseq_cd_num                                  0
[RUBY_DEBUG_COUNTER]    ccf_general                                  2
[RUBY_DEBUG_COUNTER]    ccf_iseq_setup                         540,003
[RUBY_DEBUG_COUNTER]    ccf_iseq_setup_0start                   20,000
[RUBY_DEBUG_COUNTER]    ccf_iseq_setup_tailcall_0start               0
[RUBY_DEBUG_COUNTER]    ccf_iseq_fix                         2,500,011
[RUBY_DEBUG_COUNTER]    ccf_iseq_opt                           200,002
[RUBY_DEBUG_COUNTER]    ccf_iseq_kw1                                 0
[RUBY_DEBUG_COUNTER]    ccf_iseq_kw2                                 0
[RUBY_DEBUG_COUNTER]    ccf_cfunc                            4,900,012
[RUBY_DEBUG_COUNTER]    ccf_ivar                               940,001
[RUBY_DEBUG_COUNTER]    ccf_attrset                             60,000
[RUBY_DEBUG_COUNTER]    ccf_method_missing                           0
[RUBY_DEBUG_COUNTER]    ccf_zsuper                                   0
[RUBY_DEBUG_COUNTER]    ccf_bmethod                            380,000
[RUBY_DEBUG_COUNTER]    ccf_opt_send                                 0
[RUBY_DEBUG_COUNTER]    ccf_opt_call                            20,000
[RUBY_DEBUG_COUNTER]    ccf_opt_block_call                           0
[RUBY_DEBUG_COUNTER]    ccf_super_method                       680,001
[RUBY_DEBUG_COUNTER]    frame_push                           9,520,033
[RUBY_DEBUG_COUNTER]    frame_push_method                    3,260,016
[RUBY_DEBUG_COUNTER]    frame_push_block                       860,000
[RUBY_DEBUG_COUNTER]    frame_push_class                             0
[RUBY_DEBUG_COUNTER]    frame_push_top                               0
[RUBY_DEBUG_COUNTER]    frame_push_cfunc                     5,280,014
[RUBY_DEBUG_COUNTER]    frame_push_ifunc                       100,003
[RUBY_DEBUG_COUNTER]    frame_push_eval                              0
[RUBY_DEBUG_COUNTER]    frame_push_rescue                       20,000
[RUBY_DEBUG_COUNTER]    frame_push_dummy                             0
[RUBY_DEBUG_COUNTER]    frame_R2R                            3,600,014
[RUBY_DEBUG_COUNTER]    frame_R2C                            4,962,569
[RUBY_DEBUG_COUNTER]    frame_C2C                              417,448
[RUBY_DEBUG_COUNTER]    frame_C2R                              540,002
[RUBY_DEBUG_COUNTER]    ivar_get_ic_hit                      2,000,006
[RUBY_DEBUG_COUNTER]    ivar_get_ic_miss                       160,001
[RUBY_DEBUG_COUNTER]    ivar_get_ic_miss_serial                 60,001
[RUBY_DEBUG_COUNTER]    ivar_get_ic_miss_unset                 140,001
[RUBY_DEBUG_COUNTER]    ivar_get_ic_miss_noobject                    0
[RUBY_DEBUG_COUNTER]    ivar_set_ic_hit                        480,004
[RUBY_DEBUG_COUNTER]    ivar_set_ic_miss                       260,002
[RUBY_DEBUG_COUNTER]    ivar_set_ic_miss_serial                140,002
[RUBY_DEBUG_COUNTER]    ivar_set_ic_miss_unset                       0
[RUBY_DEBUG_COUNTER]    ivar_set_ic_miss_oorange               100,000
[RUBY_DEBUG_COUNTER]    ivar_set_ic_miss_noobject               20,000
[RUBY_DEBUG_COUNTER]    ivar_get_base                           20,000
[RUBY_DEBUG_COUNTER]    ivar_set_base                          260,002
[RUBY_DEBUG_COUNTER]    lvar_get                             7,500,026
[RUBY_DEBUG_COUNTER]    lvar_get_dynamic                       500,000
[RUBY_DEBUG_COUNTER]    lvar_set                             1,740,011
[RUBY_DEBUG_COUNTER]    lvar_set_dynamic                             0
[RUBY_DEBUG_COUNTER]    lvar_set_slowpath                          146
[RUBY_DEBUG_COUNTER]    gc_count                                   145
[RUBY_DEBUG_COUNTER]    gc_minor_newobj                            145
[RUBY_DEBUG_COUNTER]    gc_minor_malloc                              0
[RUBY_DEBUG_COUNTER]    gc_minor_method                              0
[RUBY_DEBUG_COUNTER]    gc_minor_capi                                0
[RUBY_DEBUG_COUNTER]    gc_minor_stress                              0
[RUBY_DEBUG_COUNTER]    gc_major_nofree                              0
[RUBY_DEBUG_COUNTER]    gc_major_oldgen                              0
[RUBY_DEBUG_COUNTER]    gc_major_shady                               0
[RUBY_DEBUG_COUNTER]    gc_major_force                               0
[RUBY_DEBUG_COUNTER]    gc_major_oldmalloc                           0
[RUBY_DEBUG_COUNTER]    gc_isptr_trial                         107,223
[RUBY_DEBUG_COUNTER]    gc_isptr_range                          27,743
[RUBY_DEBUG_COUNTER]    gc_isptr_align                          12,258
[RUBY_DEBUG_COUNTER]    gc_isptr_maybe                           8,720
[RUBY_DEBUG_COUNTER]    obj_newobj                           3,300,009
[RUBY_DEBUG_COUNTER]    obj_newobj_slowpath                     18,996
[RUBY_DEBUG_COUNTER]    obj_newobj_wb_unprotected              180,000
[RUBY_DEBUG_COUNTER]    obj_free                             3,280,024
[RUBY_DEBUG_COUNTER]    obj_promote                              1,229
[RUBY_DEBUG_COUNTER]    obj_wb_unprotect                             0
[RUBY_DEBUG_COUNTER]    obj_obj_embed                           60,135
[RUBY_DEBUG_COUNTER]    obj_obj_transient                       59,619
[RUBY_DEBUG_COUNTER]    obj_obj_ptr                             20,091
[RUBY_DEBUG_COUNTER]    obj_str_ptr                            200,030
[RUBY_DEBUG_COUNTER]    obj_str_embed                        1,339,920
[RUBY_DEBUG_COUNTER]    obj_str_shared                         120,018
[RUBY_DEBUG_COUNTER]    obj_str_nofree                               0
[RUBY_DEBUG_COUNTER]    obj_str_fstr                                 0
[RUBY_DEBUG_COUNTER]    obj_ary_embed                          600,235
[RUBY_DEBUG_COUNTER]    obj_ary_transient                       20,003
[RUBY_DEBUG_COUNTER]    obj_ary_ptr                                  0
[RUBY_DEBUG_COUNTER]    obj_ary_extracapa                            0
[RUBY_DEBUG_COUNTER]    obj_ary_shared_create                        0
[RUBY_DEBUG_COUNTER]    obj_ary_shared                               0
[RUBY_DEBUG_COUNTER]    obj_ary_shared_root_occupied                 0
[RUBY_DEBUG_COUNTER]    obj_hash_empty                         140,018
[RUBY_DEBUG_COUNTER]    obj_hash_1                              20,003
[RUBY_DEBUG_COUNTER]    obj_hash_2                                   0
[RUBY_DEBUG_COUNTER]    obj_hash_3                                   0
[RUBY_DEBUG_COUNTER]    obj_hash_4                              20,003
[RUBY_DEBUG_COUNTER]    obj_hash_5_8                            40,008
[RUBY_DEBUG_COUNTER]    obj_hash_g8                             19,861
[RUBY_DEBUG_COUNTER]    obj_hash_null                          140,018
[RUBY_DEBUG_COUNTER]    obj_hash_ar                             80,014
[RUBY_DEBUG_COUNTER]    obj_hash_st                             19,861
[RUBY_DEBUG_COUNTER]    obj_hash_transient                      79,613
[RUBY_DEBUG_COUNTER]    obj_hash_force_convert                       0
[RUBY_DEBUG_COUNTER]    obj_struct_embed                             0
[RUBY_DEBUG_COUNTER]    obj_struct_transient                         0
[RUBY_DEBUG_COUNTER]    obj_struct_ptr                               0
[RUBY_DEBUG_COUNTER]    obj_data_empty                               0
[RUBY_DEBUG_COUNTER]    obj_data_xfree                         100,004
[RUBY_DEBUG_COUNTER]    obj_data_imm_free                       19,850
[RUBY_DEBUG_COUNTER]    obj_data_zombie                              0
[RUBY_DEBUG_COUNTER]    obj_match_under4                        80,014
[RUBY_DEBUG_COUNTER]    obj_match_ge4                                0
[RUBY_DEBUG_COUNTER]    obj_match_ge8                                0
[RUBY_DEBUG_COUNTER]    obj_match_ptr                           80,014
[RUBY_DEBUG_COUNTER]    obj_iclass_ptr                               0
[RUBY_DEBUG_COUNTER]    obj_class_ptr                                0
[RUBY_DEBUG_COUNTER]    obj_module_ptr                               0
[RUBY_DEBUG_COUNTER]    obj_bignum_ptr                               0
[RUBY_DEBUG_COUNTER]    obj_bignum_embed                             0
[RUBY_DEBUG_COUNTER]    obj_float                                    0
[RUBY_DEBUG_COUNTER]    obj_complex                                  0
[RUBY_DEBUG_COUNTER]    obj_rational                                 0
[RUBY_DEBUG_COUNTER]    obj_regexp_ptr                               0
[RUBY_DEBUG_COUNTER]    obj_file_ptr                                 0
[RUBY_DEBUG_COUNTER]    obj_symbol                                   0
[RUBY_DEBUG_COUNTER]    obj_imemo_ment                          20,004
[RUBY_DEBUG_COUNTER]    obj_imemo_iseq                               0
[RUBY_DEBUG_COUNTER]    obj_imemo_env                           20,142
[RUBY_DEBUG_COUNTER]    obj_imemo_tmpbuf                             0
[RUBY_DEBUG_COUNTER]    obj_imemo_ast                                0
[RUBY_DEBUG_COUNTER]    obj_imemo_cref                               0
[RUBY_DEBUG_COUNTER]    obj_imemo_svar                         120,021
[RUBY_DEBUG_COUNTER]    obj_imemo_throw_data                    60,011
[RUBY_DEBUG_COUNTER]    obj_imemo_ifunc                        120,020
[RUBY_DEBUG_COUNTER]    obj_imemo_memo                          60,011
[RUBY_DEBUG_COUNTER]    obj_imemo_parser_strterm                     0
[RUBY_DEBUG_COUNTER]    obj_imemo_callinfo                           0
[RUBY_DEBUG_COUNTER]    obj_imemo_callcache                          0
[RUBY_DEBUG_COUNTER]    artable_hint_hit                       460,000
[RUBY_DEBUG_COUNTER]    artable_hint_miss                            0
[RUBY_DEBUG_COUNTER]    artable_hint_notfound                  660,000
[RUBY_DEBUG_COUNTER]    heap_xmalloc                           340,801
[RUBY_DEBUG_COUNTER]    heap_xrealloc                          100,000
[RUBY_DEBUG_COUNTER]    heap_xfree                             540,128
[RUBY_DEBUG_COUNTER]    theap_alloc                            160,000
[RUBY_DEBUG_COUNTER]    theap_alloc_fail                             0
[RUBY_DEBUG_COUNTER]    theap_evacuate                             784
[RUBY_DEBUG_COUNTER]    mjit_exec                                    0
[RUBY_DEBUG_COUNTER]    mjit_exec_not_added                          0
[RUBY_DEBUG_COUNTER]    mjit_exec_not_ready                          0
[RUBY_DEBUG_COUNTER]    mjit_exec_not_compiled                       0
[RUBY_DEBUG_COUNTER]    mjit_exec_call_func                          0
[RUBY_DEBUG_COUNTER]    mjit_add_iseq_to_process                     0
[RUBY_DEBUG_COUNTER]    mjit_unload_units                            0
[RUBY_DEBUG_COUNTER]    mjit_frame_VM2VM                             0
[RUBY_DEBUG_COUNTER]    mjit_frame_VM2JT                             0
[RUBY_DEBUG_COUNTER]    mjit_frame_JT2JT                             0
[RUBY_DEBUG_COUNTER]    mjit_frame_JT2VM                             0
[RUBY_DEBUG_COUNTER]    mjit_cancel                                  0
[RUBY_DEBUG_COUNTER]    mjit_cancel_ivar_inline                      0
[RUBY_DEBUG_COUNTER]    mjit_cancel_send_inline                      0
[RUBY_DEBUG_COUNTER]    mjit_cancel_opt_insn                         0
[RUBY_DEBUG_COUNTER]    mjit_cancel_invalidate_all                   0
[RUBY_DEBUG_COUNTER]    mjit_length_unit_queue                       0
[RUBY_DEBUG_COUNTER]    mjit_length_active_units                     0
[RUBY_DEBUG_COUNTER]    mjit_length_compact_units                    0
[RUBY_DEBUG_COUNTER]    mjit_length_stale_units                      0
[RUBY_DEBUG_COUNTER]    mjit_compile_failures                        0
12141.28 rps

$ WARMUP=20000 REQUESTS=20000 bundle exec ruby -v --jit bench.rb
ruby 2.8.0dev (2020-03-15T09:25:47Z master d79890cbfa) +JIT [x86_64-linux]
warmup: 20000/20000
benchmark: 20000/20000
[RUBY_DEBUG_COUNTER]    15659 show_debug_counters
[RUBY_DEBUG_COUNTER]    mc_inline_hit                        7,319,999
[RUBY_DEBUG_COUNTER]    mc_inline_miss_klass                   760,017
[RUBY_DEBUG_COUNTER]    mc_inline_miss_invalidated                   0
[RUBY_DEBUG_COUNTER]    mc_cme_complement                            0
[RUBY_DEBUG_COUNTER]    mc_cme_complement_hit                        0
[RUBY_DEBUG_COUNTER]    mc_search                              660,003
[RUBY_DEBUG_COUNTER]    mc_search_notfound                     460,000
[RUBY_DEBUG_COUNTER]    mc_search_super                      3,560,003
[RUBY_DEBUG_COUNTER]    ci_packed                            1,300,010
[RUBY_DEBUG_COUNTER]    ci_kw                                        0
[RUBY_DEBUG_COUNTER]    ci_nokw                                      0
[RUBY_DEBUG_COUNTER]    ci_runtime                           1,300,010
[RUBY_DEBUG_COUNTER]    cc_new                                       5
[RUBY_DEBUG_COUNTER]    cc_temp                                      0
[RUBY_DEBUG_COUNTER]    cc_found_ccs                           760,015
[RUBY_DEBUG_COUNTER]    cc_ent_invalidate                            0
[RUBY_DEBUG_COUNTER]    cc_cme_invalidate                            0
[RUBY_DEBUG_COUNTER]    cc_invalidate_leaf                           0
[RUBY_DEBUG_COUNTER]    cc_invalidate_leaf_ccs                       0
[RUBY_DEBUG_COUNTER]    cc_invalidate_leaf_callable                  0
[RUBY_DEBUG_COUNTER]    cc_invalidate_tree                           0
[RUBY_DEBUG_COUNTER]    cc_invalidate_tree_cme                       0
[RUBY_DEBUG_COUNTER]    cc_invalidate_tree_callable                  0
[RUBY_DEBUG_COUNTER]    ccs_free                                     0
[RUBY_DEBUG_COUNTER]    ccs_maxlen                                   1
[RUBY_DEBUG_COUNTER]    ccs_found                            2,080,016
[RUBY_DEBUG_COUNTER]    iseq_num                                     0
[RUBY_DEBUG_COUNTER]    iseq_cd_num                                  0
[RUBY_DEBUG_COUNTER]    ccf_general                                  2
[RUBY_DEBUG_COUNTER]    ccf_iseq_setup                         540,003
[RUBY_DEBUG_COUNTER]    ccf_iseq_setup_0start                        0
[RUBY_DEBUG_COUNTER]    ccf_iseq_setup_tailcall_0start               0
[RUBY_DEBUG_COUNTER]    ccf_iseq_fix                           739,998
[RUBY_DEBUG_COUNTER]    ccf_iseq_opt                           200,002
[RUBY_DEBUG_COUNTER]    ccf_iseq_kw1                                 0
[RUBY_DEBUG_COUNTER]    ccf_iseq_kw2                                 0
[RUBY_DEBUG_COUNTER]    ccf_cfunc                            5,200,014
[RUBY_DEBUG_COUNTER]    ccf_ivar                               940,001
[RUBY_DEBUG_COUNTER]    ccf_attrset                             60,000
[RUBY_DEBUG_COUNTER]    ccf_method_missing                           0
[RUBY_DEBUG_COUNTER]    ccf_zsuper                                   0
[RUBY_DEBUG_COUNTER]    ccf_bmethod                            380,000
[RUBY_DEBUG_COUNTER]    ccf_opt_send                                 0
[RUBY_DEBUG_COUNTER]    ccf_opt_call                            20,000
[RUBY_DEBUG_COUNTER]    ccf_opt_block_call                           0
[RUBY_DEBUG_COUNTER]    ccf_super_method                       680,001
[RUBY_DEBUG_COUNTER]    frame_push                           9,540,037
[RUBY_DEBUG_COUNTER]    frame_push_method                    2,980,016
[RUBY_DEBUG_COUNTER]    frame_push_block                       860,000
[RUBY_DEBUG_COUNTER]    frame_push_class                             0
[RUBY_DEBUG_COUNTER]    frame_push_top                               0
[RUBY_DEBUG_COUNTER]    frame_push_cfunc                     5,580,016
[RUBY_DEBUG_COUNTER]    frame_push_ifunc                       100,005
[RUBY_DEBUG_COUNTER]    frame_push_eval                              0
[RUBY_DEBUG_COUNTER]    frame_push_rescue                       20,000
[RUBY_DEBUG_COUNTER]    frame_push_dummy                             0
[RUBY_DEBUG_COUNTER]    frame_R2R                            3,320,014
[RUBY_DEBUG_COUNTER]    frame_R2C                            5,262,640
[RUBY_DEBUG_COUNTER]    frame_C2C                              417,381
[RUBY_DEBUG_COUNTER]    frame_C2R                              540,002
[RUBY_DEBUG_COUNTER]    ivar_get_ic_hit                      1,719,999
[RUBY_DEBUG_COUNTER]    ivar_get_ic_miss                       160,001
[RUBY_DEBUG_COUNTER]    ivar_get_ic_miss_serial                 60,001
[RUBY_DEBUG_COUNTER]    ivar_get_ic_miss_unset                 140,001
[RUBY_DEBUG_COUNTER]    ivar_get_ic_miss_noobject                    0
[RUBY_DEBUG_COUNTER]    ivar_set_ic_hit                        320,002
[RUBY_DEBUG_COUNTER]    ivar_set_ic_miss                       260,002
[RUBY_DEBUG_COUNTER]    ivar_set_ic_miss_serial                140,002
[RUBY_DEBUG_COUNTER]    ivar_set_ic_miss_unset                       0
[RUBY_DEBUG_COUNTER]    ivar_set_ic_miss_oorange               100,000
[RUBY_DEBUG_COUNTER]    ivar_set_ic_miss_noobject               20,000
[RUBY_DEBUG_COUNTER]    ivar_get_base                           20,000
[RUBY_DEBUG_COUNTER]    ivar_set_base                          260,002
[RUBY_DEBUG_COUNTER]    lvar_get                             7,500,026
[RUBY_DEBUG_COUNTER]    lvar_get_dynamic                       500,000
[RUBY_DEBUG_COUNTER]    lvar_set                             1,740,011
[RUBY_DEBUG_COUNTER]    lvar_set_dynamic                             0
[RUBY_DEBUG_COUNTER]    lvar_set_slowpath                          146
[RUBY_DEBUG_COUNTER]    gc_count                                   145
[RUBY_DEBUG_COUNTER]    gc_minor_newobj                            145
[RUBY_DEBUG_COUNTER]    gc_minor_malloc                              0
[RUBY_DEBUG_COUNTER]    gc_minor_method                              0
[RUBY_DEBUG_COUNTER]    gc_minor_capi                                0
[RUBY_DEBUG_COUNTER]    gc_minor_stress                              0
[RUBY_DEBUG_COUNTER]    gc_major_nofree                              0
[RUBY_DEBUG_COUNTER]    gc_major_oldgen                              0
[RUBY_DEBUG_COUNTER]    gc_major_shady                               0
[RUBY_DEBUG_COUNTER]    gc_major_force                               0
[RUBY_DEBUG_COUNTER]    gc_major_oldmalloc                           0
[RUBY_DEBUG_COUNTER]    gc_isptr_trial                         145,805
[RUBY_DEBUG_COUNTER]    gc_isptr_range                          44,448
[RUBY_DEBUG_COUNTER]    gc_isptr_align                          27,878
[RUBY_DEBUG_COUNTER]    gc_isptr_maybe                          22,486
[RUBY_DEBUG_COUNTER]    obj_newobj                           3,300,012
[RUBY_DEBUG_COUNTER]    obj_newobj_slowpath                     18,422
[RUBY_DEBUG_COUNTER]    obj_newobj_wb_unprotected              180,000
[RUBY_DEBUG_COUNTER]    obj_free                             3,280,216
[RUBY_DEBUG_COUNTER]    obj_promote                              1,274
[RUBY_DEBUG_COUNTER]    obj_wb_unprotect                             0
[RUBY_DEBUG_COUNTER]    obj_obj_embed                           60,134
[RUBY_DEBUG_COUNTER]    obj_obj_transient                       59,347
[RUBY_DEBUG_COUNTER]    obj_obj_ptr                             20,361
[RUBY_DEBUG_COUNTER]    obj_str_ptr                            200,049
[RUBY_DEBUG_COUNTER]    obj_str_embed                        1,339,983
[RUBY_DEBUG_COUNTER]    obj_str_shared                         120,029
[RUBY_DEBUG_COUNTER]    obj_str_nofree                               0
[RUBY_DEBUG_COUNTER]    obj_str_fstr                                 0
[RUBY_DEBUG_COUNTER]    obj_ary_embed                          600,284
[RUBY_DEBUG_COUNTER]    obj_ary_transient                       19,886
[RUBY_DEBUG_COUNTER]    obj_ary_ptr                                117
[RUBY_DEBUG_COUNTER]    obj_ary_extracapa                            0
[RUBY_DEBUG_COUNTER]    obj_ary_shared_create                        0
[RUBY_DEBUG_COUNTER]    obj_ary_shared                               0
[RUBY_DEBUG_COUNTER]    obj_ary_shared_root_occupied                 0
[RUBY_DEBUG_COUNTER]    obj_hash_empty                         140,026
[RUBY_DEBUG_COUNTER]    obj_hash_1                              20,005
[RUBY_DEBUG_COUNTER]    obj_hash_2                                   0
[RUBY_DEBUG_COUNTER]    obj_hash_3                                   0
[RUBY_DEBUG_COUNTER]    obj_hash_4                              20,005
[RUBY_DEBUG_COUNTER]    obj_hash_5_8                            40,008
[RUBY_DEBUG_COUNTER]    obj_hash_g8                             19,861
[RUBY_DEBUG_COUNTER]    obj_hash_null                          140,026
[RUBY_DEBUG_COUNTER]    obj_hash_ar                             80,018
[RUBY_DEBUG_COUNTER]    obj_hash_st                             19,861
[RUBY_DEBUG_COUNTER]    obj_hash_transient                      79,747
[RUBY_DEBUG_COUNTER]    obj_hash_force_convert                       0
[RUBY_DEBUG_COUNTER]    obj_struct_embed                             0
[RUBY_DEBUG_COUNTER]    obj_struct_transient                         0
[RUBY_DEBUG_COUNTER]    obj_struct_ptr                               0
[RUBY_DEBUG_COUNTER]    obj_data_empty                               0
[RUBY_DEBUG_COUNTER]    obj_data_xfree                         100,007
[RUBY_DEBUG_COUNTER]    obj_data_imm_free                       19,849
[RUBY_DEBUG_COUNTER]    obj_data_zombie                              0
[RUBY_DEBUG_COUNTER]    obj_match_under4                        80,020
[RUBY_DEBUG_COUNTER]    obj_match_ge4                                0
[RUBY_DEBUG_COUNTER]    obj_match_ge8                                0
[RUBY_DEBUG_COUNTER]    obj_match_ptr                           80,020
[RUBY_DEBUG_COUNTER]    obj_iclass_ptr                               0
[RUBY_DEBUG_COUNTER]    obj_class_ptr                                0
[RUBY_DEBUG_COUNTER]    obj_module_ptr                               0
[RUBY_DEBUG_COUNTER]    obj_bignum_ptr                               0
[RUBY_DEBUG_COUNTER]    obj_bignum_embed                             0
[RUBY_DEBUG_COUNTER]    obj_float                                    0
[RUBY_DEBUG_COUNTER]    obj_complex                                  0
[RUBY_DEBUG_COUNTER]    obj_rational                                 0
[RUBY_DEBUG_COUNTER]    obj_regexp_ptr                               0
[RUBY_DEBUG_COUNTER]    obj_file_ptr                                 0
[RUBY_DEBUG_COUNTER]    obj_symbol                                   0
[RUBY_DEBUG_COUNTER]    obj_imemo_ment                          20,005
[RUBY_DEBUG_COUNTER]    obj_imemo_iseq                               0
[RUBY_DEBUG_COUNTER]    obj_imemo_env                           20,143
[RUBY_DEBUG_COUNTER]    obj_imemo_tmpbuf                             0
[RUBY_DEBUG_COUNTER]    obj_imemo_ast                                0
[RUBY_DEBUG_COUNTER]    obj_imemo_cref                               0
[RUBY_DEBUG_COUNTER]    obj_imemo_svar                         120,029
[RUBY_DEBUG_COUNTER]    obj_imemo_throw_data                    60,015
[RUBY_DEBUG_COUNTER]    obj_imemo_ifunc                        120,030
[RUBY_DEBUG_COUNTER]    obj_imemo_memo                          60,015
[RUBY_DEBUG_COUNTER]    obj_imemo_parser_strterm                     0
[RUBY_DEBUG_COUNTER]    obj_imemo_callinfo                           0
[RUBY_DEBUG_COUNTER]    obj_imemo_callcache                          3
[RUBY_DEBUG_COUNTER]    artable_hint_hit                       460,000
[RUBY_DEBUG_COUNTER]    artable_hint_miss                       40,000
[RUBY_DEBUG_COUNTER]    artable_hint_notfound                  660,000
[RUBY_DEBUG_COUNTER]    heap_xmalloc                           341,075
[RUBY_DEBUG_COUNTER]    heap_xrealloc                          100,000
[RUBY_DEBUG_COUNTER]    heap_xfree                             540,413
[RUBY_DEBUG_COUNTER]    theap_alloc                            160,000
[RUBY_DEBUG_COUNTER]    theap_alloc_fail                             0
[RUBY_DEBUG_COUNTER]    theap_evacuate                           1,058
[RUBY_DEBUG_COUNTER]    mjit_exec                            3,840,016
[RUBY_DEBUG_COUNTER]    mjit_exec_not_added                          0
[RUBY_DEBUG_COUNTER]    mjit_exec_not_ready                    580,001
[RUBY_DEBUG_COUNTER]    mjit_exec_not_compiled                       0
[RUBY_DEBUG_COUNTER]    mjit_exec_call_func                  3,260,015
[RUBY_DEBUG_COUNTER]    mjit_add_iseq_to_process                     0
[RUBY_DEBUG_COUNTER]    mjit_unload_units                            0
[RUBY_DEBUG_COUNTER]    mjit_frame_VM2VM                       400,001
[RUBY_DEBUG_COUNTER]    mjit_frame_VM2JT                     1,460,002
[RUBY_DEBUG_COUNTER]    mjit_frame_JT2JT                     1,800,013
[RUBY_DEBUG_COUNTER]    mjit_frame_JT2VM                       180,000
[RUBY_DEBUG_COUNTER]    mjit_cancel                                  0
[RUBY_DEBUG_COUNTER]    mjit_cancel_ivar_inline                      0
[RUBY_DEBUG_COUNTER]    mjit_cancel_send_inline                      0
[RUBY_DEBUG_COUNTER]    mjit_cancel_opt_insn                         0
[RUBY_DEBUG_COUNTER]    mjit_cancel_invalidate_all                   0
[RUBY_DEBUG_COUNTER]    mjit_length_unit_queue                      30
[RUBY_DEBUG_COUNTER]    mjit_length_active_units                   100
[RUBY_DEBUG_COUNTER]    mjit_length_compact_units                    2
[RUBY_DEBUG_COUNTER]    mjit_length_stale_units                      9
[RUBY_DEBUG_COUNTER]    mjit_compile_failures                        0
10841.52 rps
```

### USE\_INSNS\_COUNTER
```
$ WARMUP=20000 REQUESTS=20000 bundle exec ruby -v bench.rb
ruby 2.8.0dev (2020-03-14T09:17:17Z master 666194559f) [x86_64-linux]
warmup: 20000/20000
benchmark: 20000/20000
12511.24 rps
[RUBY_INSNS_COUNTER]    nop                                  4508940 ( 4.7%)
[RUBY_INSNS_COUNTER]    getlocal                               41146 ( 0.0%)
[RUBY_INSNS_COUNTER]    setlocal                                  89 ( 0.0%)
[RUBY_INSNS_COUNTER]    getblockparam                          20213 ( 0.0%)
[RUBY_INSNS_COUNTER]    setblockparam                              0 ( 0.0%)
[RUBY_INSNS_COUNTER]    getblockparamproxy                     80927 ( 0.1%)
[RUBY_INSNS_COUNTER]    getspecial                              1561 ( 0.0%)
[RUBY_INSNS_COUNTER]    setspecial                                 0 ( 0.0%)
[RUBY_INSNS_COUNTER]    getinstancevariable                  2696267 ( 2.8%)
[RUBY_INSNS_COUNTER]    setinstancevariable                  1495871 ( 1.6%)
[RUBY_INSNS_COUNTER]    getclassvariable                         812 ( 0.0%)
[RUBY_INSNS_COUNTER]    setclassvariable                          55 ( 0.0%)
[RUBY_INSNS_COUNTER]    getconstant                             6430 ( 0.0%)
[RUBY_INSNS_COUNTER]    setconstant                              417 ( 0.0%)
[RUBY_INSNS_COUNTER]    getglobal                                910 ( 0.0%)
[RUBY_INSNS_COUNTER]    setglobal                                375 ( 0.0%)
[RUBY_INSNS_COUNTER]    putnil                               1630046 ( 1.7%)
[RUBY_INSNS_COUNTER]    putself                              8597551 ( 9.0%)
[RUBY_INSNS_COUNTER]    putobject                            3915628 ( 4.1%)
[RUBY_INSNS_COUNTER]    putspecialobject                        1426 ( 0.0%)
[RUBY_INSNS_COUNTER]    putstring                             641617 ( 0.7%)
[RUBY_INSNS_COUNTER]    concatstrings                         203676 ( 0.2%)
[RUBY_INSNS_COUNTER]    tostring                              242247 ( 0.3%)
[RUBY_INSNS_COUNTER]    freezestring                          123077 ( 0.1%)
[RUBY_INSNS_COUNTER]    toregexp                                 395 ( 0.0%)
[RUBY_INSNS_COUNTER]    intern                                   133 ( 0.0%)
[RUBY_INSNS_COUNTER]    newarray                              423712 ( 0.4%)
[RUBY_INSNS_COUNTER]    newarraykwsplat                            0 ( 0.0%)
[RUBY_INSNS_COUNTER]    duparray                               40132 ( 0.0%)
[RUBY_INSNS_COUNTER]    duphash                                   18 ( 0.0%)
[RUBY_INSNS_COUNTER]    expandarray                           180160 ( 0.2%)
[RUBY_INSNS_COUNTER]    concatarray                               12 ( 0.0%)
[RUBY_INSNS_COUNTER]    splatarray                            280755 ( 0.3%)
[RUBY_INSNS_COUNTER]    newhash                               220929 ( 0.2%)
[RUBY_INSNS_COUNTER]    newrange                                 579 ( 0.0%)
[RUBY_INSNS_COUNTER]    pop                                  3723527 ( 3.9%)
[RUBY_INSNS_COUNTER]    dup                                  2922647 ( 3.1%)
[RUBY_INSNS_COUNTER]    dupn                                  160853 ( 0.2%)
[RUBY_INSNS_COUNTER]    swap                                   80205 ( 0.1%)
[RUBY_INSNS_COUNTER]    reverse                                    0 ( 0.0%)
[RUBY_INSNS_COUNTER]    topn                                      28 ( 0.0%)
[RUBY_INSNS_COUNTER]    setn                                  283527 ( 0.3%)
[RUBY_INSNS_COUNTER]    adjuststack                              503 ( 0.0%)
[RUBY_INSNS_COUNTER]    defined                               255308 ( 0.3%)
[RUBY_INSNS_COUNTER]    checkmatch                              4525 ( 0.0%)
[RUBY_INSNS_COUNTER]    checkkeyword                           80071 ( 0.1%)
[RUBY_INSNS_COUNTER]    checktype                             327210 ( 0.3%)
[RUBY_INSNS_COUNTER]    defineclass                              792 ( 0.0%)
[RUBY_INSNS_COUNTER]    definemethod                            3436 ( 0.0%)
[RUBY_INSNS_COUNTER]    definesmethod                            419 ( 0.0%)
[RUBY_INSNS_COUNTER]    send                                 1329037 ( 1.4%)
[RUBY_INSNS_COUNTER]    opt_send_without_block              15534218 (16.2%)
[RUBY_INSNS_COUNTER]    opt_str_freeze                          2190 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_nil_p                             263181 ( 0.3%)
[RUBY_INSNS_COUNTER]    opt_str_uminus                             0 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_newarray_max                           0 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_newarray_min                           0 ( 0.0%)
[RUBY_INSNS_COUNTER]    invokesuper                          1381854 ( 1.4%)
[RUBY_INSNS_COUNTER]    invokeblock                           321705 ( 0.3%)
[RUBY_INSNS_COUNTER]    leave                                8152364 ( 8.5%)
[RUBY_INSNS_COUNTER]    throw                                  40373 ( 0.0%)
[RUBY_INSNS_COUNTER]    jump                                  363584 ( 0.4%)
[RUBY_INSNS_COUNTER]    branchif                             2968812 ( 3.1%)
[RUBY_INSNS_COUNTER]    branchunless                         4244963 ( 4.4%)
[RUBY_INSNS_COUNTER]    branchnil                                 12 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_getinlinecache                   3194489 ( 3.3%)
[RUBY_INSNS_COUNTER]    opt_setinlinecache                      4963 ( 0.0%)
[RUBY_INSNS_COUNTER]    once                                      54 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_case_dispatch                        417 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_plus                              181421 ( 0.2%)
[RUBY_INSNS_COUNTER]    opt_minus                              20647 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_mult                                 143 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_div                                40003 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_mod                                 1324 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_eq                                490384 ( 0.5%)
[RUBY_INSNS_COUNTER]    opt_neq                                80327 ( 0.1%)
[RUBY_INSNS_COUNTER]    opt_lt                                    95 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_le                                 41050 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_gt                                  1054 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_ge                                   113 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_ltlt                               82344 ( 0.1%)
[RUBY_INSNS_COUNTER]    opt_and                                  281 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_or                                     8 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_aref                             2610566 ( 2.7%)
[RUBY_INSNS_COUNTER]    opt_aset                              825385 ( 0.9%)
[RUBY_INSNS_COUNTER]    opt_aset_with                          80236 ( 0.1%)
[RUBY_INSNS_COUNTER]    opt_aref_with                         120001 ( 0.1%)
[RUBY_INSNS_COUNTER]    opt_length                               832 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_size                                1707 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_empty_p                           141791 ( 0.1%)
[RUBY_INSNS_COUNTER]    opt_succ                                   0 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_not                               542540 ( 0.6%)
[RUBY_INSNS_COUNTER]    opt_regexpmatch2                       82352 ( 0.1%)
[RUBY_INSNS_COUNTER]    opt_call_c_function                        0 ( 0.0%)
[RUBY_INSNS_COUNTER]    invokebuiltin                              0 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_invokebuiltin_delegate                 0 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_invokebuiltin_delegate_leave           1 ( 0.0%)
[RUBY_INSNS_COUNTER]    getlocal_WC_0                       14517557 (15.2%)
[RUBY_INSNS_COUNTER]    getlocal_WC_1                         972892 ( 1.0%)
[RUBY_INSNS_COUNTER]    setlocal_WC_0                        3583101 ( 3.7%)
[RUBY_INSNS_COUNTER]    setlocal_WC_1                             52 ( 0.0%)
[RUBY_INSNS_COUNTER]    putobject_INT2FIX_0_                  221806 ( 0.2%)
[RUBY_INSNS_COUNTER]    putobject_INT2FIX_1_                   83370 ( 0.1%)

$ WARMUP=20000 REQUESTS=20000 bundle exec ruby -v --jit bench.rb
ruby 2.8.0dev (2020-03-14T09:17:17Z master 666194559f) +JIT [x86_64-linux]
warmup: 20000/20000
benchmark: 20000/20000
10526.11 rps
[RUBY_INSNS_COUNTER]    nop                                  2376945 ( 3.8%)
[RUBY_INSNS_COUNTER]    getlocal                               41146 ( 0.1%)
[RUBY_INSNS_COUNTER]    setlocal                                  89 ( 0.0%)
[RUBY_INSNS_COUNTER]    getblockparam                          20213 ( 0.0%)
[RUBY_INSNS_COUNTER]    setblockparam                              0 ( 0.0%)
[RUBY_INSNS_COUNTER]    getblockparamproxy                     40927 ( 0.1%)
[RUBY_INSNS_COUNTER]    getspecial                              1561 ( 0.0%)
[RUBY_INSNS_COUNTER]    setspecial                                 0 ( 0.0%)
[RUBY_INSNS_COUNTER]    getinstancevariable                  1664190 ( 2.6%)
[RUBY_INSNS_COUNTER]    setinstancevariable                  1255861 ( 2.0%)
[RUBY_INSNS_COUNTER]    getclassvariable                         812 ( 0.0%)
[RUBY_INSNS_COUNTER]    setclassvariable                          55 ( 0.0%)
[RUBY_INSNS_COUNTER]    getconstant                             6433 ( 0.0%)
[RUBY_INSNS_COUNTER]    setconstant                              417 ( 0.0%)
[RUBY_INSNS_COUNTER]    getglobal                                910 ( 0.0%)
[RUBY_INSNS_COUNTER]    setglobal                                375 ( 0.0%)
[RUBY_INSNS_COUNTER]    putnil                               1110041 ( 1.8%)
[RUBY_INSNS_COUNTER]    putself                              5223941 ( 8.3%)
[RUBY_INSNS_COUNTER]    putobject                            2935626 ( 4.7%)
[RUBY_INSNS_COUNTER]    putspecialobject                        1426 ( 0.0%)
[RUBY_INSNS_COUNTER]    putstring                             361617 ( 0.6%)
[RUBY_INSNS_COUNTER]    concatstrings                         183676 ( 0.3%)
[RUBY_INSNS_COUNTER]    tostring                              222247 ( 0.4%)
[RUBY_INSNS_COUNTER]    freezestring                          123077 ( 0.2%)
[RUBY_INSNS_COUNTER]    toregexp                                 395 ( 0.0%)
[RUBY_INSNS_COUNTER]    intern                                   133 ( 0.0%)
[RUBY_INSNS_COUNTER]    newarray                              263711 ( 0.4%)
[RUBY_INSNS_COUNTER]    newarraykwsplat                            0 ( 0.0%)
[RUBY_INSNS_COUNTER]    duparray                               40132 ( 0.1%)
[RUBY_INSNS_COUNTER]    duphash                                   18 ( 0.0%)
[RUBY_INSNS_COUNTER]    expandarray                           100159 ( 0.2%)
[RUBY_INSNS_COUNTER]    concatarray                               12 ( 0.0%)
[RUBY_INSNS_COUNTER]    splatarray                            200755 ( 0.3%)
[RUBY_INSNS_COUNTER]    newhash                               160927 ( 0.3%)
[RUBY_INSNS_COUNTER]    newrange                                 579 ( 0.0%)
[RUBY_INSNS_COUNTER]    pop                                  2643524 ( 4.2%)
[RUBY_INSNS_COUNTER]    dup                                  2142645 ( 3.4%)
[RUBY_INSNS_COUNTER]    dupn                                   80853 ( 0.1%)
[RUBY_INSNS_COUNTER]    swap                                   40205 ( 0.1%)
[RUBY_INSNS_COUNTER]    reverse                                    0 ( 0.0%)
[RUBY_INSNS_COUNTER]    topn                                      28 ( 0.0%)
[RUBY_INSNS_COUNTER]    setn                                  183525 ( 0.3%)
[RUBY_INSNS_COUNTER]    adjuststack                              503 ( 0.0%)
[RUBY_INSNS_COUNTER]    defined                               155308 ( 0.2%)
[RUBY_INSNS_COUNTER]    checkmatch                              4525 ( 0.0%)
[RUBY_INSNS_COUNTER]    checkkeyword                           40071 ( 0.1%)
[RUBY_INSNS_COUNTER]    checktype                             307210 ( 0.5%)
[RUBY_INSNS_COUNTER]    defineclass                              792 ( 0.0%)
[RUBY_INSNS_COUNTER]    definemethod                            3436 ( 0.0%)
[RUBY_INSNS_COUNTER]    definesmethod                            419 ( 0.0%)
[RUBY_INSNS_COUNTER]    send                                  869035 ( 1.4%)
[RUBY_INSNS_COUNTER]    opt_send_without_block              10243248 (16.3%)
[RUBY_INSNS_COUNTER]    opt_str_freeze                          2190 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_nil_p                             203180 ( 0.3%)
[RUBY_INSNS_COUNTER]    opt_str_uminus                             0 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_newarray_max                           0 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_newarray_min                           0 ( 0.0%)
[RUBY_INSNS_COUNTER]    invokesuper                           921851 ( 1.5%)
[RUBY_INSNS_COUNTER]    invokeblock                           201705 ( 0.3%)
[RUBY_INSNS_COUNTER]    leave                                4240685 ( 6.7%)
[RUBY_INSNS_COUNTER]    throw                                  40373 ( 0.1%)
[RUBY_INSNS_COUNTER]    jump                                  303584 ( 0.5%)
[RUBY_INSNS_COUNTER]    branchif                             2228808 ( 3.5%)
[RUBY_INSNS_COUNTER]    branchunless                         2924968 ( 4.7%)
[RUBY_INSNS_COUNTER]    branchnil                                 12 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_getinlinecache                   2054479 ( 3.3%)
[RUBY_INSNS_COUNTER]    opt_setinlinecache                      4964 ( 0.0%)
[RUBY_INSNS_COUNTER]    once                                      54 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_case_dispatch                        417 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_plus                              141421 ( 0.2%)
[RUBY_INSNS_COUNTER]    opt_minus                              20647 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_mult                                 143 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_div                                40003 ( 0.1%)
[RUBY_INSNS_COUNTER]    opt_mod                                 1324 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_eq                                350388 ( 0.6%)
[RUBY_INSNS_COUNTER]    opt_neq                                80329 ( 0.1%)
[RUBY_INSNS_COUNTER]    opt_lt                                    95 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_le                                 41050 ( 0.1%)
[RUBY_INSNS_COUNTER]    opt_gt                                  1054 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_ge                                   113 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_ltlt                               82344 ( 0.1%)
[RUBY_INSNS_COUNTER]    opt_and                                  281 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_or                                     8 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_aref                             1458493 ( 2.3%)
[RUBY_INSNS_COUNTER]    opt_aset                              685382 ( 1.1%)
[RUBY_INSNS_COUNTER]    opt_aset_with                          40236 ( 0.1%)
[RUBY_INSNS_COUNTER]    opt_aref_with                          80001 ( 0.1%)
[RUBY_INSNS_COUNTER]    opt_length                               832 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_size                                1707 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_empty_p                           101790 ( 0.2%)
[RUBY_INSNS_COUNTER]    opt_succ                                   0 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_not                               302539 ( 0.5%)
[RUBY_INSNS_COUNTER]    opt_regexpmatch2                       82352 ( 0.1%)
[RUBY_INSNS_COUNTER]    opt_call_c_function                        0 ( 0.0%)
[RUBY_INSNS_COUNTER]    invokebuiltin                              0 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_invokebuiltin_delegate                 0 ( 0.0%)
[RUBY_INSNS_COUNTER]    opt_invokebuiltin_delegate_leave           1 ( 0.0%)
[RUBY_INSNS_COUNTER]    getlocal_WC_0                        9985462 (15.9%)
[RUBY_INSNS_COUNTER]    getlocal_WC_1                         446896 ( 0.7%)
[RUBY_INSNS_COUNTER]    setlocal_WC_0                        2463089 ( 3.9%)
[RUBY_INSNS_COUNTER]    setlocal_WC_1                             52 ( 0.0%)
[RUBY_INSNS_COUNTER]    putobject_INT2FIX_0_                  201805 ( 0.3%)
[RUBY_INSNS_COUNTER]    putobject_INT2FIX_1_                   83370 ( 0.1%)
```

### MJIT\_COUNTER

```
$ WARMUP=19998 REQUESTS=0 ~/.rbenv/versions/ruby/bin/ruby -v --jit-verbose=1 bench.rb
ruby 2.8.0dev (2020-04-12T19:19:06Z master 82fdffc5ec) +JIT [x86_64-linux]
JIT success (44.2ms): get_header@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:62 -> /tmp/_ruby_mjit_p25533u0.c
JIT recompile: get_header@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:62
JIT success (23.2ms): block in set@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1238 -> /tmp/_ruby_mjit_p25533u1.c
JIT success (34.3ms): get_header@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:62 -> /tmp/_ruby_mjit_p25533u4.c
JIT recompile: get_header@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:62
JIT success (21.8ms): settings@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:934 -> /tmp/_ruby_mjit_p25533u2.c
JIT success (44.8ms): get_header@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:62 -> /tmp/_ruby_mjit_p25533u7.c
JIT inline: settings@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:939 => settings@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:934
JIT success (44.0ms): settings@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:939 -> /tmp/_ruby_mjit_p25533u3.c
JIT success (1107.5ms): []@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/utils.rb:452 -> /tmp/_ruby_mjit_p25533u5.c
JIT recompile: []@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/utils.rb:452
warmup: 19998/19998
JIT success (1088.4ms): []=@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/utils.rb:456 -> /tmp/_ruby_mjit_p25533u6.c
JIT success (975.7ms): []@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/utils.rb:452 -> /tmp/_ruby_mjit_p25533u132.c
JIT success (107.0ms): block in <class:Base>@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1822 -> /tmp/_ruby_mjit_p25533u8.c
JIT success (129.6ms): filter!@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:976 -> /tmp/_ruby_mjit_p25533u9.c
JIT success (45.5ms): block in content_type@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:346 -> /tmp/_ruby_mjit_p25533u10.c
JIT success (201.5ms): invoke@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1071 -> /tmp/_ruby_mjit_p25533u11.c
JIT success (312.0ms): block in invoke@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1072 -> /tmp/_ruby_mjit_p25533u12.c
JIT success (88.0ms): query_string@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:158 -> /tmp/_ruby_mjit_p25533u13.c
JIT success (74.2ms): request_method@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:157 -> /tmp/_ruby_mjit_p25533u14.c
JIT success (182.0ms): body@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:254 -> /tmp/_ruby_mjit_p25533u15.c
JIT success (253.9ms): level=@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/2.8.0/logger.rb:250 -> /tmp/_ruby_mjit_p25533u16.c
JIT success (75.3ms): call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/base.rb:45 -> /tmp/_ruby_mjit_p25533u17.c
JIT success (940.2ms): initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:26 -> /tmp/_ruby_mjit_p25533u18.c
JIT success (921.3ms): initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:50 -> /tmp/_ruby_mjit_p25533u19.c
JIT success (32.4ms): set_header@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:78 -> /tmp/_ruby_mjit_p25533u20.c
JIT success (92.1ms): media_type@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:383 -> /tmp/_ruby_mjit_p25533u21.c
JIT success (59.4ms): content_type@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:271 -> /tmp/_ruby_mjit_p25533u22.c
JIT success (118.3ms): type@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/media_type.rb:16 -> /tmp/_ruby_mjit_p25533u23.c
JIT success (86.7ms): block in <class:Base>@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1828 -> /tmp/_ruby_mjit_p25533u24.c
JIT success (50.1ms): set_header@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/response.rb:128 -> /tmp/_ruby_mjit_p25533u25.c
JIT success (78.7ms): drop_body?@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:182 -> /tmp/_ruby_mjit_p25533u26.c
JIT success (111.5ms): html?@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/base.rb:120 -> /tmp/_ruby_mjit_p25533u27.c
JIT success (947.8ms): each@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/utils.rb:440 -> /tmp/_ruby_mjit_p25533u28.c
JIT success (322.9ms): block in each@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/utils.rb:441 -> /tmp/_ruby_mjit_p25533u29.c
JIT success (55.5ms): block in html?@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/base.rb:121 -> /tmp/_ruby_mjit_p25533u30.c
JIT success (76.1ms): []@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/utils.rb:414 -> /tmp/_ruby_mjit_p25533u31.c
JIT success (19.9ms): environment@(eval):1 -> /tmp/_ruby_mjit_p25533u32.c
JIT inline: development?@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1420 => environment@(eval):1
JIT success (36.8ms): development?@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1420 -> /tmp/_ruby_mjit_p25533u33.c
JIT success (81.9ms): call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1502 -> /tmp/_ruby_mjit_p25533u34.c
JIT success (376.3ms): synchronize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1726 -> /tmp/_ruby_mjit_p25533u35.c
JIT inline: lock?@(eval):1 => lock@(eval):1
JIT success (45.5ms): lock?@(eval):1 -> /tmp/_ruby_mjit_p25533u36.c
JIT success (19.2ms): lock@(eval):1 -> /tmp/_ruby_mjit_p25533u37.c
JIT success (44.8ms): block in call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1503 -> /tmp/_ruby_mjit_p25533u38.c
JIT success (73.3ms): prototype@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1477 -> /tmp/_ruby_mjit_p25533u39.c
JIT success (42.3ms): call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1950 -> /tmp/_ruby_mjit_p25533u40.c
JIT success (122.3ms): call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:193 -> /tmp/_ruby_mjit_p25533u41.c
JIT success (41.5ms): call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/show_exceptions.rb:21 -> /tmp/_ruby_mjit_p25533u42.c
JIT success (193.3ms): call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/method_override.rb:15 -> /tmp/_ruby_mjit_p25533u43.c
JIT success (52.4ms): allowed_methods@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/method_override.rb:40 -> /tmp/_ruby_mjit_p25533u44.c
JIT success (217.4ms): call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/head.rb:11 -> /tmp/_ruby_mjit_p25533u45.c
JIT success (948.3ms): call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:223 -> /tmp/_ruby_mjit_p25533u46.c
JIT success (39.4ms): call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:229 -> /tmp/_ruby_mjit_p25533u47.c
JIT success (208.2ms): call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/common_logger.rb:36 -> /tmp/_ruby_mjit_p25533u48.c
JIT success (88.8ms): clock_time@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/utils.rb:83 -> /tmp/_ruby_mjit_p25533u49.c
JIT success (138.5ms): call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/logger.rb:12 -> /tmp/_ruby_mjit_p25533u50.c
JIT success (164.4ms): initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/2.8.0/logger.rb:379 -> /tmp/_ruby_mjit_p25533u51.c
JIT success (33.6ms): initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/2.8.0/logger/formatter.rb:10 -> /tmp/_ruby_mjit_p25533u52.c
JIT success (41.7ms): datetime_format=@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/2.8.0/logger.rb:279 -> /tmp/_ruby_mjit_p25533u53.c
JIT success (200.3ms): initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/2.8.0/logger/log_device.rb:14 -> /tmp/_ruby_mjit_p25533u54.c
JIT success (144.1ms): mon_initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/2.8.0/monitor.rb:230 -> /tmp/_ruby_mjit_p25533u55.c
JIT success (110.1ms): set_dev@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/2.8.0/logger/log_device.rb:79 -> /tmp/_ruby_mjit_p25533u56.c
JIT success (105.9ms): call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/frame_options.rb:30 -> /tmp/_ruby_mjit_p25533u57.c
JIT success (106.7ms): accepts?@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/http_origin.rb:30 -> /tmp/_ruby_mjit_p25533u58.c
JIT success (39.6ms): safe?@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/base.rb:37 -> /tmp/_ruby_mjit_p25533u59.c
JIT success (77.3ms): accepts?@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/ip_spoofing.rb:14 -> /tmp/_ruby_mjit_p25533u60.c
JIT success (125.4ms): call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/json_csrf.rb:24 -> /tmp/_ruby_mjit_p25533u61.c
JIT success (85.0ms): call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/path_traversal.rb:13 -> /tmp/_ruby_mjit_p25533u62.c
JIT success (137.4ms): cleanup@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/path_traversal.rb:21 -> /tmp/_ruby_mjit_p25533u63.c
JIT success (137.8ms): call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/xss_header.rb:17 -> /tmp/_ruby_mjit_p25533u64.c
JIT success (49.4ms): call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:907 -> /tmp/_ruby_mjit_p25533u65.c
JIT success (253.3ms): call!@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:911 -> /tmp/_ruby_mjit_p25533u66.c
JIT success (945.0ms): initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/indifferent_hash.rb:51 -> /tmp/_ruby_mjit_p25533u67.c
JIT success (961.3ms): initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:136 -> /tmp/_ruby_mjit_p25533u68.c
JIT success (469.7ms): initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/response.rb:42 -> /tmp/_ruby_mjit_p25533u69.c
JIT success (964.9ms): initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/utils.rb:422 -> /tmp/_ruby_mjit_p25533u70.c
JIT success (36.1ms): block in <class:Base>@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1824 -> /tmp/_ruby_mjit_p25533u71.c
JIT success (30.2ms): clear@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/tilt-2.0.10/lib/tilt.rb:109 -> /tmp/_ruby_mjit_p25533u72.c
JIT success (32.6ms): block in call!@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:919 -> /tmp/_ruby_mjit_p25533u73.c
JIT success (119.4ms): dispatch!@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1087 -> /tmp/_ruby_mjit_p25533u74.c
JIT success (975.5ms): params@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:78 -> /tmp/_ruby_mjit_p25533u75.c
JIT success (973.5ms): params@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:31 -> /tmp/_ruby_mjit_p25533u76.c
JIT success (55.4ms): params@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:468 -> /tmp/_ruby_mjit_p25533u77.c
JIT success (182.2ms): GET@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:426 -> /tmp/_ruby_mjit_p25533u78.c
JIT success (51.2ms): parse_query@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:589 -> /tmp/_ruby_mjit_p25533u79.c
JIT success (68.0ms): query_parser@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:585 -> /tmp/_ruby_mjit_p25533u80.c
JIT success (209.4ms): parse_nested_query@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/query_parser.rb:64 -> /tmp/_ruby_mjit_p25533u81.c
JIT success (41.3ms): make_params@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/query_parser.rb:124 -> /tmp/_ruby_mjit_p25533u82.c
JIT success (39.7ms): initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/query_parser.rb:159 -> /tmp/_ruby_mjit_p25533u83.c
JIT success (90.7ms): to_h@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/query_parser.rb:197 -> /tmp/_ruby_mjit_p25533u84.c
JIT success (268.7ms): POST@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:440 -> /tmp/_ruby_mjit_p25533u85.c
JIT success (187.5ms): form_data?@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:412 -> /tmp/_ruby_mjit_p25533u86.c
JIT success (83.3ms): parseable_data?@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:421 -> /tmp/_ruby_mjit_p25533u87.c
JIT success (83.5ms): merge!@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/indifferent_hash.rb:135 -> /tmp/_ruby_mjit_p25533u88.c
JIT success (950.5ms): block in merge!@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/indifferent_hash.rb:136 -> /tmp/_ruby_mjit_p25533u89.c
JIT success (67.0ms): block in dispatch!@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1095 -> /tmp/_ruby_mjit_p25533u90.c
JIT success (50.3ms): static?@(eval):1 -> /tmp/_ruby_mjit_p25533u91.c
JIT success (83.1ms): block in <class:Base>@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1829 -> /tmp/_ruby_mjit_p25533u92.c
JIT success (144.0ms): route!@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:982 -> /tmp/_ruby_mjit_p25533u93.c
JIT success (89.8ms): block in route!@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:984 -> /tmp/_ruby_mjit_p25533u94.c
JIT success (381.7ms): process_route@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1014 -> /tmp/_ruby_mjit_p25533u95.c
JIT success (87.1ms): path_info@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:154 -> /tmp/_ruby_mjit_p25533u96.c
JIT inline: strict_paths?@(eval):1 => strict_paths@(eval):1
JIT success (46.2ms): strict_paths?@(eval):1 -> /tmp/_ruby_mjit_p25533u97.c
JIT success (19.9ms): strict_paths@(eval):1 -> /tmp/_ruby_mjit_p25533u98.c
JIT success (137.8ms): params@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/mustermann-1.1.1/lib/mustermann/pattern.rb:204 -> /tmp/_ruby_mjit_p25533u99.c
JIT success (171.5ms): match@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/2.8.0/forwardable.rb:226 -> /tmp/_ruby_mjit_p25533u100.c
JIT success (174.1ms): named_captures@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/2.8.0/forwardable.rb:226 -> /tmp/_ruby_mjit_p25533u101.c
JIT compaction (17.8ms): Compacted 100 methods -> /tmp/_ruby_mjit_p25533u133.so
JIT recompile: level=@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/2.8.0/logger.rb:250
JIT recompile: initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/2.8.0/logger/log_device.rb:14
JIT recompile: call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/base.rb:45
JIT recompile: initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:50
JIT recompile: call!@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:911
JIT recompile: initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/response.rb:42
JIT recompile: []=@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/utils.rb:456
JIT success (1021.2ms): []=@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/utils.rb:456 -> /tmp/_ruby_mjit_p25533u140.c
JIT success (271.4ms): level=@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/2.8.0/logger.rb:250 -> /tmp/_ruby_mjit_p25533u134.c
JIT success (57.2ms): call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/base.rb:45 -> /tmp/_ruby_mjit_p25533u136.c
JIT success (937.3ms): initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:50 -> /tmp/_ruby_mjit_p25533u137.c
JIT success (48.9ms): force_encoding@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1761 -> /tmp/_ruby_mjit_p25533u102.c
JIT inline: force_encoding@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1749 => settings@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:934
JIT success (151.3ms): force_encoding@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1749 -> /tmp/_ruby_mjit_p25533u103.c
JIT success (959.9ms): respond_to?@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/mustermann-1.1.1/lib/mustermann/pattern.rb:353 -> /tmp/_ruby_mjit_p25533u104.c
JIT compaction (18.0ms): Compacted 100 methods -> /tmp/_ruby_mjit_p25533u141.so

NaN rps
[MJIT_COUNTER] total_calls of active_units:
  320000: get_header@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:62
  220012: block in set@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1238
  200000: settings@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:939
  160000: []@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/utils.rb:452
  140000: []=@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/utils.rb:456
   80000: filter!@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:976
   80000: block in content_type@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:346
   80000: block in <class:Base>@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1822
   60000: request_method@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:157
   60000: query_string@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:158
   60000: invoke@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1071
   60000: body@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:254
   60000: block in invoke@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1072
   46990: settings@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:934
   40000: type@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/media_type.rb:16
   40000: set_header@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/response.rb:128
   40000: set_header@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:78
   40000: media_type@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:383
   40000: level=@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/2.8.0/logger.rb:250
   40000: initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:50
   40000: initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:26
   40000: html?@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/base.rb:120
   40000: each@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/utils.rb:440
   40000: drop_body?@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:182
   40000: content_type@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:271
   40000: call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/base.rb:45
   40000: block in html?@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/base.rb:121
   40000: block in each@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/utils.rb:441
   40000: block in <class:Base>@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1828
   40000: []@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/utils.rb:414
   20002: environment@(eval):1
   20001: development?@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1420
   20000: to_h@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/query_parser.rb:197
   20000: synchronize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1726
   20000: strict_paths?@(eval):1
   20000: static?@(eval):1
   20000: set_dev@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/2.8.0/logger/log_device.rb:79
   20000: safe?@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/base.rb:37
   20000: route!@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:982
   20000: respond_to?@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/mustermann-1.1.1/lib/mustermann/pattern.rb:353
   20000: query_parser@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:585
   20000: prototype@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1477
   20000: process_route@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1014
   20000: path_info@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:154
   20000: parseable_data?@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:421
   20000: parse_query@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:589
   20000: parse_nested_query@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/query_parser.rb:64
   20000: params@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:78
   20000: params@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:468
   20000: params@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:31
   20000: params@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/mustermann-1.1.1/lib/mustermann/pattern.rb:204
   20000: named_captures@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/2.8.0/forwardable.rb:226
   20000: mon_initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/2.8.0/monitor.rb:230
   20000: merge!@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/indifferent_hash.rb:135
   20000: match@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/2.8.0/forwardable.rb:226
   20000: make_params@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/query_parser.rb:124
   20000: lock?@(eval):1
   20000: initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/indifferent_hash.rb:51
   20000: initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:136
   20000: initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/utils.rb:422
   20000: initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/query_parser.rb:159
   20000: initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/2.8.0/logger/formatter.rb:10
   20000: initialize@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/2.8.0/logger.rb:379
   20000: form_data?@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:412
   20000: force_encoding@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1761
   20000: force_encoding@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1749
   20000: dispatch!@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1087
   20000: datetime_format=@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/2.8.0/logger.rb:279
   20000: clock_time@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/utils.rb:83
   20000: clear@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/tilt-2.0.10/lib/tilt.rb:109
   20000: cleanup@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/path_traversal.rb:21
   20000: call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/show_exceptions.rb:21
   20000: call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:907
   20000: call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:229
   20000: call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:223
   20000: call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1950
   20000: call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:193
   20000: call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1502
   20000: call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/xss_header.rb:17
   20000: call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/path_traversal.rb:13
   20000: call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/json_csrf.rb:24
   20000: call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/frame_options.rb:30
   20000: call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/method_override.rb:15
   20000: call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/logger.rb:12
   20000: call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/head.rb:11
   20000: call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/common_logger.rb:36
   20000: block in route!@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:984
   20000: block in merge!@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/indifferent_hash.rb:136
   20000: block in dispatch!@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1095
   20000: block in call@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1503
   20000: block in call!@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:919
   20000: block in <class:Base>@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1829
   20000: block in <class:Base>@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/sinatra-2.0.8.1/lib/sinatra/base.rb:1824
   20000: allowed_methods@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/method_override.rb:40
   20000: accepts?@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/ip_spoofing.rb:14
   20000: accepts?@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-protection-2.0.8.1/lib/rack/protection/http_origin.rb:30
   20000: POST@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:440
   20000: GET@/home/k0kubun/.rbenv/versions/ruby/lib/ruby/gems/2.8.0/gems/rack-2.2.2/lib/rack/request.rb:426
   19998: strict_paths@(eval):1
   19998: lock@(eval):1
```

(The last output is manually sorted by counts)

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
