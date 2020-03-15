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
[RUBY_DEBUG_COUNTER]    18332 show_debug_counters
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
[RUBY_DEBUG_COUNTER]    frame_R2C                            4,962,564
[RUBY_DEBUG_COUNTER]    frame_C2C                              417,453
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
[RUBY_DEBUG_COUNTER]    gc_isptr_trial                          97,400
[RUBY_DEBUG_COUNTER]    gc_isptr_range                          28,026
[RUBY_DEBUG_COUNTER]    gc_isptr_align                          13,391
[RUBY_DEBUG_COUNTER]    gc_isptr_maybe                           9,165
[RUBY_DEBUG_COUNTER]    obj_newobj                           3,300,009
[RUBY_DEBUG_COUNTER]    obj_newobj_slowpath                     18,961
[RUBY_DEBUG_COUNTER]    obj_newobj_wb_unprotected              180,000
[RUBY_DEBUG_COUNTER]    obj_free                             3,280,004
[RUBY_DEBUG_COUNTER]    obj_promote                              1,223
[RUBY_DEBUG_COUNTER]    obj_wb_unprotect                             0
[RUBY_DEBUG_COUNTER]    obj_obj_embed                           60,136
[RUBY_DEBUG_COUNTER]    obj_obj_transient                       59,609
[RUBY_DEBUG_COUNTER]    obj_obj_ptr                             20,105
[RUBY_DEBUG_COUNTER]    obj_str_ptr                            200,029
[RUBY_DEBUG_COUNTER]    obj_str_embed                        1,339,902
[RUBY_DEBUG_COUNTER]    obj_str_shared                         120,019
[RUBY_DEBUG_COUNTER]    obj_str_nofree                               0
[RUBY_DEBUG_COUNTER]    obj_str_fstr                                 0
[RUBY_DEBUG_COUNTER]    obj_ary_embed                          600,233
[RUBY_DEBUG_COUNTER]    obj_ary_transient                       20,004
[RUBY_DEBUG_COUNTER]    obj_ary_ptr                                  0
[RUBY_DEBUG_COUNTER]    obj_ary_extracapa                            0
[RUBY_DEBUG_COUNTER]    obj_ary_shared_create                        0
[RUBY_DEBUG_COUNTER]    obj_ary_shared                               0
[RUBY_DEBUG_COUNTER]    obj_ary_shared_root_occupied                 0
[RUBY_DEBUG_COUNTER]    obj_hash_empty                         140,017
[RUBY_DEBUG_COUNTER]    obj_hash_1                              20,003
[RUBY_DEBUG_COUNTER]    obj_hash_2                                   0
[RUBY_DEBUG_COUNTER]    obj_hash_3                                   0
[RUBY_DEBUG_COUNTER]    obj_hash_4                              20,004
[RUBY_DEBUG_COUNTER]    obj_hash_5_8                            40,006
[RUBY_DEBUG_COUNTER]    obj_hash_g8                             19,860
[RUBY_DEBUG_COUNTER]    obj_hash_null                          140,017
[RUBY_DEBUG_COUNTER]    obj_hash_ar                             80,013
[RUBY_DEBUG_COUNTER]    obj_hash_st                             19,860
[RUBY_DEBUG_COUNTER]    obj_hash_transient                      79,592
[RUBY_DEBUG_COUNTER]    obj_hash_force_convert                       0
[RUBY_DEBUG_COUNTER]    obj_struct_embed                             0
[RUBY_DEBUG_COUNTER]    obj_struct_transient                         0
[RUBY_DEBUG_COUNTER]    obj_struct_ptr                               0
[RUBY_DEBUG_COUNTER]    obj_data_empty                               0
[RUBY_DEBUG_COUNTER]    obj_data_xfree                         100,006
[RUBY_DEBUG_COUNTER]    obj_data_imm_free                       19,854
[RUBY_DEBUG_COUNTER]    obj_data_zombie                              0
[RUBY_DEBUG_COUNTER]    obj_match_under4                        80,013
[RUBY_DEBUG_COUNTER]    obj_match_ge4                                0
[RUBY_DEBUG_COUNTER]    obj_match_ge8                                0
[RUBY_DEBUG_COUNTER]    obj_match_ptr                           80,013
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
[RUBY_DEBUG_COUNTER]    obj_imemo_ment                          20,003
[RUBY_DEBUG_COUNTER]    obj_imemo_iseq                               0
[RUBY_DEBUG_COUNTER]    obj_imemo_env                           20,142
[RUBY_DEBUG_COUNTER]    obj_imemo_tmpbuf                             0
[RUBY_DEBUG_COUNTER]    obj_imemo_ast                                0
[RUBY_DEBUG_COUNTER]    obj_imemo_cref                               0
[RUBY_DEBUG_COUNTER]    obj_imemo_svar                         120,019
[RUBY_DEBUG_COUNTER]    obj_imemo_throw_data                    60,009
[RUBY_DEBUG_COUNTER]    obj_imemo_ifunc                        120,019
[RUBY_DEBUG_COUNTER]    obj_imemo_memo                          60,009
[RUBY_DEBUG_COUNTER]    obj_imemo_parser_strterm                     0
[RUBY_DEBUG_COUNTER]    obj_imemo_callinfo                           0
[RUBY_DEBUG_COUNTER]    obj_imemo_callcache                          0
[RUBY_DEBUG_COUNTER]    artable_hint_hit                       460,000
[RUBY_DEBUG_COUNTER]    artable_hint_miss                            0
[RUBY_DEBUG_COUNTER]    artable_hint_notfound                  660,000
[RUBY_DEBUG_COUNTER]    heap_xmalloc                           340,842
[RUBY_DEBUG_COUNTER]    heap_xrealloc                          100,000
[RUBY_DEBUG_COUNTER]    heap_xfree                             540,162
[RUBY_DEBUG_COUNTER]    theap_alloc                            160,000
[RUBY_DEBUG_COUNTER]    theap_alloc_fail                             0
[RUBY_DEBUG_COUNTER]    theap_evacuate                             825
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
12722.17 rps

$ WARMUP=20000 REQUESTS=20000 bundle exec ruby -v --jit bench.rb
ruby 2.8.0dev (2020-03-15T09:25:47Z master d79890cbfa) +JIT [x86_64-linux]
warmup: 20000/20000
benchmark: 20000/20000
[RUBY_DEBUG_COUNTER]    18436 show_debug_counters
[RUBY_DEBUG_COUNTER]    mc_inline_hit                        7,379,999
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
[RUBY_DEBUG_COUNTER]    cc_new                                       2
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
[RUBY_DEBUG_COUNTER]    ccf_iseq_fix                           779,998
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
[RUBY_DEBUG_COUNTER]    frame_push                           9,560,037
[RUBY_DEBUG_COUNTER]    frame_push_method                    3,000,016
[RUBY_DEBUG_COUNTER]    frame_push_block                       860,000
[RUBY_DEBUG_COUNTER]    frame_push_class                             0
[RUBY_DEBUG_COUNTER]    frame_push_top                               0
[RUBY_DEBUG_COUNTER]    frame_push_cfunc                     5,580,016
[RUBY_DEBUG_COUNTER]    frame_push_ifunc                       100,005
[RUBY_DEBUG_COUNTER]    frame_push_eval                              0
[RUBY_DEBUG_COUNTER]    frame_push_rescue                       20,000
[RUBY_DEBUG_COUNTER]    frame_push_dummy                             0
[RUBY_DEBUG_COUNTER]    frame_R2R                            3,340,014
[RUBY_DEBUG_COUNTER]    frame_R2C                            5,262,662
[RUBY_DEBUG_COUNTER]    frame_C2C                              417,359
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
[RUBY_DEBUG_COUNTER]    gc_isptr_trial                         183,021
[RUBY_DEBUG_COUNTER]    gc_isptr_range                          42,799
[RUBY_DEBUG_COUNTER]    gc_isptr_align                          23,726
[RUBY_DEBUG_COUNTER]    gc_isptr_maybe                          19,766
[RUBY_DEBUG_COUNTER]    obj_newobj                           3,300,009
[RUBY_DEBUG_COUNTER]    obj_newobj_slowpath                     19,142
[RUBY_DEBUG_COUNTER]    obj_newobj_wb_unprotected              180,000
[RUBY_DEBUG_COUNTER]    obj_free                             3,280,230
[RUBY_DEBUG_COUNTER]    obj_promote                              1,248
[RUBY_DEBUG_COUNTER]    obj_wb_unprotect                             0
[RUBY_DEBUG_COUNTER]    obj_obj_embed                           60,135
[RUBY_DEBUG_COUNTER]    obj_obj_transient                       59,362
[RUBY_DEBUG_COUNTER]    obj_obj_ptr                             20,350
[RUBY_DEBUG_COUNTER]    obj_str_ptr                            200,049
[RUBY_DEBUG_COUNTER]    obj_str_embed                        1,339,998
[RUBY_DEBUG_COUNTER]    obj_str_shared                         120,028
[RUBY_DEBUG_COUNTER]    obj_str_nofree                               0
[RUBY_DEBUG_COUNTER]    obj_str_fstr                                 0
[RUBY_DEBUG_COUNTER]    obj_ary_embed                          600,284
[RUBY_DEBUG_COUNTER]    obj_ary_transient                       20,005
[RUBY_DEBUG_COUNTER]    obj_ary_ptr                                  0
[RUBY_DEBUG_COUNTER]    obj_ary_extracapa                            0
[RUBY_DEBUG_COUNTER]    obj_ary_shared_create                        0
[RUBY_DEBUG_COUNTER]    obj_ary_shared                               0
[RUBY_DEBUG_COUNTER]    obj_ary_shared_root_occupied                 0
[RUBY_DEBUG_COUNTER]    obj_hash_empty                         140,020
[RUBY_DEBUG_COUNTER]    obj_hash_1                              20,005
[RUBY_DEBUG_COUNTER]    obj_hash_2                                   0
[RUBY_DEBUG_COUNTER]    obj_hash_3                                   0
[RUBY_DEBUG_COUNTER]    obj_hash_4                              20,005
[RUBY_DEBUG_COUNTER]    obj_hash_5_8                            40,006
[RUBY_DEBUG_COUNTER]    obj_hash_g8                             19,860
[RUBY_DEBUG_COUNTER]    obj_hash_null                          140,020
[RUBY_DEBUG_COUNTER]    obj_hash_ar                             80,016
[RUBY_DEBUG_COUNTER]    obj_hash_st                             19,860
[RUBY_DEBUG_COUNTER]    obj_hash_transient                      79,566
[RUBY_DEBUG_COUNTER]    obj_hash_force_convert                       0
[RUBY_DEBUG_COUNTER]    obj_struct_embed                             0
[RUBY_DEBUG_COUNTER]    obj_struct_transient                         0
[RUBY_DEBUG_COUNTER]    obj_struct_ptr                               0
[RUBY_DEBUG_COUNTER]    obj_data_empty                               0
[RUBY_DEBUG_COUNTER]    obj_data_xfree                         100,008
[RUBY_DEBUG_COUNTER]    obj_data_imm_free                       19,853
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
[RUBY_DEBUG_COUNTER]    obj_imemo_env                           20,142
[RUBY_DEBUG_COUNTER]    obj_imemo_tmpbuf                             0
[RUBY_DEBUG_COUNTER]    obj_imemo_ast                                0
[RUBY_DEBUG_COUNTER]    obj_imemo_cref                               0
[RUBY_DEBUG_COUNTER]    obj_imemo_svar                         120,030
[RUBY_DEBUG_COUNTER]    obj_imemo_throw_data                    60,015
[RUBY_DEBUG_COUNTER]    obj_imemo_ifunc                        120,030
[RUBY_DEBUG_COUNTER]    obj_imemo_memo                          60,015
[RUBY_DEBUG_COUNTER]    obj_imemo_parser_strterm                     0
[RUBY_DEBUG_COUNTER]    obj_imemo_callinfo                           0
[RUBY_DEBUG_COUNTER]    obj_imemo_callcache                          0
[RUBY_DEBUG_COUNTER]    artable_hint_hit                       460,000
[RUBY_DEBUG_COUNTER]    artable_hint_miss                            0
[RUBY_DEBUG_COUNTER]    artable_hint_notfound                  660,000
[RUBY_DEBUG_COUNTER]    heap_xmalloc                           341,125
[RUBY_DEBUG_COUNTER]    heap_xrealloc                          100,000
[RUBY_DEBUG_COUNTER]    heap_xfree                             540,464
[RUBY_DEBUG_COUNTER]    theap_alloc                            160,000
[RUBY_DEBUG_COUNTER]    theap_alloc_fail                             0
[RUBY_DEBUG_COUNTER]    theap_evacuate                           1,108
[RUBY_DEBUG_COUNTER]    mjit_exec                            3,860,016
[RUBY_DEBUG_COUNTER]    mjit_exec_not_added                          0
[RUBY_DEBUG_COUNTER]    mjit_exec_not_ready                    900,001
[RUBY_DEBUG_COUNTER]    mjit_exec_not_compiled                       0
[RUBY_DEBUG_COUNTER]    mjit_exec_call_func                  2,960,015
[RUBY_DEBUG_COUNTER]    mjit_add_iseq_to_process                     0
[RUBY_DEBUG_COUNTER]    mjit_unload_units                            0
[RUBY_DEBUG_COUNTER]    mjit_frame_VM2VM                       460,001
[RUBY_DEBUG_COUNTER]    mjit_frame_VM2JT                     1,540,002
[RUBY_DEBUG_COUNTER]    mjit_frame_JT2JT                     1,420,013
[RUBY_DEBUG_COUNTER]    mjit_frame_JT2VM                       440,000
[RUBY_DEBUG_COUNTER]    mjit_cancel                                  0
[RUBY_DEBUG_COUNTER]    mjit_cancel_ivar_inline                      0
[RUBY_DEBUG_COUNTER]    mjit_cancel_send_inline                      0
[RUBY_DEBUG_COUNTER]    mjit_cancel_opt_insn                         0
[RUBY_DEBUG_COUNTER]    mjit_cancel_invalidate_all                   0
[RUBY_DEBUG_COUNTER]    mjit_length_unit_queue                      37
[RUBY_DEBUG_COUNTER]    mjit_length_active_units                    93
[RUBY_DEBUG_COUNTER]    mjit_length_compact_units                    1
[RUBY_DEBUG_COUNTER]    mjit_length_stale_units                      9
[RUBY_DEBUG_COUNTER]    mjit_compile_failures                        0
10225.87 rps
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
