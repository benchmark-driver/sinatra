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
7669.87 rps
```

```
$ WARMUP=1000 REQUESTS=10000 bundle exec ruby bench.rb
warmup: 1000/10000
benchmark: 10000/10000
7399.75 rps
```

## Profiling

```
$ bundle exec ruby profile.rb
$ stackprof stackprof.dump
==================================
  Mode: cpu(1)
  Samples: 1460 (0.00% miss rate)
  GC: 92 (6.30%)
==================================
     TOTAL    (pct)     SAMPLES    (pct)     FRAME
       117   (8.0%)         111   (7.6%)     Rack::CommonLogger#log
        92   (6.3%)          92   (6.3%)     (garbage collection)
        91   (6.2%)          91   (6.2%)     Rack::Utils::HeaderHash#[]=
       175  (12.0%)          87   (6.0%)     Rack::MockRequest.env_for
        90   (6.2%)          70   (4.8%)     block in <class:Base>
        95   (6.5%)          56   (3.8%)     Sinatra::Helpers#content_type
        56   (3.8%)          56   (3.8%)     Rack::Request::Env#get_header
        55   (3.8%)          55   (3.8%)     Rack::Utils::HeaderHash#[]
        41   (2.8%)          41   (2.8%)     Rack::Protection::PathTraversal#cleanup
        54   (3.7%)          40   (2.7%)     Rack::Protection::Base#html?
        33   (2.3%)          33   (2.3%)     URI::RFC2396_Parser#split
        45   (3.1%)          32   (2.2%)     Rack::Utils::HeaderHash.new
       179  (12.3%)          31   (2.1%)     Rack::Response#initialize
        31   (2.1%)          31   (2.1%)     Sinatra::Base.settings
       142   (9.7%)          30   (2.1%)     block in <class:Base>
        25   (1.7%)          25   (1.7%)     Sinatra::IndifferentHash#initialize
        25   (1.7%)          25   (1.7%)     MonitorMixin#mon_initialize
        23   (1.6%)          23   (1.6%)     Mustermann::RegexpBased#match
        43   (2.9%)          23   (1.6%)     URI::Generic#initialize
        23   (1.6%)          23   (1.6%)     block in set
        22   (1.5%)          22   (1.5%)     Rack::BodyProxy#respond_to?
       112   (7.7%)          22   (1.5%)     block in <class:Base>
        47   (3.2%)          21   (1.4%)     Rack::Utils::HeaderHash#each
        21   (1.4%)          21   (1.4%)     Rack::Utils::HeaderHash#names
        20   (1.4%)          20   (1.4%)     #<Module:0x000055d21a084390>.mime_type
        18   (1.2%)          18   (1.2%)     block in <top (required)>
        26   (1.8%)          17   (1.2%)     Sinatra::Base#filter!
       107   (7.3%)          17   (1.2%)     Sinatra::Base#process_route
        16   (1.1%)          16   (1.1%)     Logger#level=
        20   (1.4%)          15   (1.0%)     Sinatra::Base.force_encoding
```

```
$ WALL=1 INTERVAL=10 bundle exec ruby profile.rb
$ stackprof stackprof.dump
==================================
  Mode: wall(10)
  Samples: 941282 (0.18% miss rate)
  GC: 52766 (5.61%)
==================================
     TOTAL    (pct)     SAMPLES    (pct)     FRAME
     82064   (8.7%)       82064   (8.7%)     Rack::Utils::HeaderHash#[]=
     75141   (8.0%)       71613   (7.6%)     Rack::CommonLogger#log
     52766   (5.6%)       52766   (5.6%)     (garbage collection)
     57742   (6.1%)       44828   (4.8%)     block in <class:Base>
     89704   (9.5%)       43163   (4.6%)     Rack::MockRequest.env_for
     37965   (4.0%)       37965   (4.0%)     Rack::Utils::HeaderHash#[]
     36922   (3.9%)       36922   (3.9%)     Rack::Request::Env#get_header
     26275   (2.8%)       26275   (2.8%)     Sinatra::Base.settings
     29915   (3.2%)       26227   (2.8%)     Rack::Protection::Base#html?
     71506   (7.6%)       26129   (2.8%)     Sinatra::Helpers#content_type
     24373   (2.6%)       24373   (2.6%)     Rack::Protection::PathTraversal#cleanup
     17531   (1.9%)       17531   (1.9%)     block in set
     27347   (2.9%)       17003   (1.8%)     Rack::Utils::HeaderHash.new
     86601   (9.2%)       16501   (1.8%)     block in <class:Base>
     20750   (2.2%)       16394   (1.7%)     Sinatra::Base#filter!
     15301   (1.6%)       15301   (1.6%)     #<Module:0x00005599ce31a908>.mime_type
     14743   (1.6%)       14743   (1.6%)     Mustermann::RegexpBased#match
     14333   (1.5%)       14333   (1.5%)     Sinatra::IndifferentHash#initialize
     14229   (1.5%)       14229   (1.5%)     URI::RFC2396_Parser#split
     13388   (1.4%)       13388   (1.4%)     Rack::BodyProxy#respond_to?
     17827   (1.9%)       13387   (1.4%)     Sinatra::Base.force_encoding
     80988   (8.6%)       13199   (1.4%)     Sinatra::Base#process_route
     70100   (7.4%)       12358   (1.3%)     block in <class:Base>
    285192  (30.3%)       12024   (1.3%)     Sinatra::Base#invoke
     11796   (1.3%)       11796   (1.3%)     Rack::Protection::Base#safe?
     10846   (1.2%)       10846   (1.2%)     Rack::Request::Env#initialize
     46541   (4.9%)       10813   (1.1%)     Rack::MockRequest.parse_uri_rfc2396
     10344   (1.1%)       10344   (1.1%)     Rack::Utils::HeaderHash#initialize
     10284   (1.1%)       10284   (1.1%)     Logger#level=
     10237   (1.1%)       10237   (1.1%)     Rack::Utils::HeaderHash#names
```

## Perf

```
$ sudo perf record -c 10000 ~/.rbenv/versions/2.5.3/bin/ruby bench.rb
benchmark: 20000/20000
7036.72 rps
[ perf record: Woken up 19 times to write data ]
[ perf record: Captured and wrote 4.605 MB perf.data (148041 samples) ]

$ sudo perf report
Samples: 148K of event 'cycles:ppp', Event count (approx.): 1480410000
Overhead  Command         Shared Object       Symbol
  17.65%  ruby            ruby                [.] vm_exec_core
   3.73%  ruby            ruby                [.] vm_call_cfunc
   3.37%  ruby            ruby                [.] vm_search_method.isra.110
   3.06%  ruby            ruby                [.] st_lookup
   2.37%  ruby            ruby                [.] gc_sweep_step
   1.90%  ruby            ruby                [.] method_entry_get
   1.82%  ruby            ruby                [.] vm_call_iseq_setup
   1.77%  ruby            libc-2.27.so        [.] _int_malloc
   1.51%  ruby            libc-2.27.so        [.] __malloc_usable_size
   1.50%  ruby            ruby                [.] rb_memhash
   1.46%  ruby            libc-2.27.so        [.] cfree@GLIBC_2.2.5
   1.33%  ruby            libc-2.27.so        [.] malloc
   1.19%  ruby            ruby                [.] vm_call_iseq_setup_normal_0start_0params_0locals
   1.10%  ruby            ruby                [.] objspace_malloc_increase.isra.75
   1.10%  ruby            ruby                [.] rb_class_of
   0.99%  ruby            ruby                [.] setup_parameters_complex
   0.92%  ruby            ruby                [.] rb_id_table_lookup
   0.92%  ruby            ruby                [.] rb_enc_get
   0.90%  ruby            ruby                [.] match_at
   0.87%  ruby            ruby                [.] invoke_iseq_block_from_c
   0.82%  ruby            ruby                [.] st_update
   0.76%  ruby            ruby                [.] rb_wb_protected_newobj_of
   0.76%  ruby            ruby                [.] rb_call0
   0.75%  ruby            ruby                [.] vm_call_iseq_setup_normal_0start_1params_1locals
   0.74%  ruby            ruby                [.] vm_exec
   0.66%  ruby            ruby                [.] vm_call_method_each_type
   0.66%  ruby            ruby                [.] vm_call0_body.constprop.148
   0.63%  ruby            libc-2.27.so        [.] malloc_consolidate
   0.59%  ruby            ruby                [.] prepare_callable_method_entry
   0.53%  ruby            ruby                [.] BSD_vfprintf
   0.51%  ruby            ruby                [.] rb_str_format
```

```
$ sudo perf stat ~/.rbenv/versions/2.5.3/bin/ruby bench.rb
benchmark: 20000/20000
7905.35 rps

 Performance counter stats for '/home/k0kubun/.rbenv/versions/2.5.3/bin/ruby bench.rb':

       2717.813924      task-clock (msec)         #    1.000 CPUs utilized
                91      context-switches          #    0.033 K/sec
                 1      cpu-migrations            #    0.000 K/sec
             3,299      page-faults               #    0.001 M/sec
    11,278,083,872      cycles                    #    4.150 GHz
    10,615,806,238      instructions              #    0.94  insn per cycle
     2,186,780,879      branches                  #  804.610 M/sec
        98,175,739      branch-misses             #    4.49% of all branches

       2.719011304 seconds time elapsed

```

## License

MIT License
