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

## License

MIT License
