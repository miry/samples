## Run

```
$ go get -u github.com/rcrowley/go-metrics
$ go build -o proxy *.go
$ ./proxy 2> stderr.logs
```

## Problems

Broke the server via send a lot of random values and got on logs:

```
2017/03/16 20:23:53 [::1]:60246: Decode error: too many fields
2017/03/16 20:23:53 [::1]:60246: Decode error: not enough fields
1970/01/01 01:00:00 [::1]:60246: Decode error: bad type ""
fatal error: unexpected signal during runtime execution
[signal 0xb code=0x1 addr=0xb01dfacedebac1e pc=0xf9a90]

goroutine 37 [running]:
runtime.throw(0x1df740, 0x2a)
	/usr/local/Cellar/go/1.6.2/libexec/src/runtime/panic.go:547 +0x90 fp=0xc82004bab8 sp=0xc82004baa0
runtime.sigpanic()
	/usr/local/Cellar/go/1.6.2/libexec/src/runtime/sigpanic_unix.go:12 +0x5a fp=0xc82004bb08 sp=0xc82004bab8
sync.(*Pool).Get(0x281a80, 0x0, 0x0)
	/usr/local/Cellar/go/1.6.2/libexec/src/sync/pool.go:102 +0x40 fp=0xc82004bb58 sp=0xc82004bb08
fmt.newPrinter(0x8)
	/usr/local/Cellar/go/1.6.2/libexec/src/fmt/print.go:133 +0x27 fp=0xc82004bb98 sp=0xc82004bb58
fmt.Fprintf(0x600120, 0xc8200b6018, 0x1a7610, 0x5, 0xc82004bc78, 0x2, 0x2, 0xc8200c2100, 0x0, 0x0)
	/usr/local/Cellar/go/1.6.2/libexec/src/fmt/print.go:187 +0x30 fp=0xc82004bbe0 sp=0xc82004bb98
github.com/weaveworks/challenges/backend/protocol.Msg.Encode(0x1a8148, 0x3, 0x0, 0x1abf50, 0x9, 0x600120, 0xc8200b6018, 0x0, 0x0)
	/Users/david/weave/src/github.com/weaveworks/challenges/backend/protocol/msg.go:20 +0x19d fp=0xc82004bca0 sp=0xc82004bbe0
main.handle(0x600000, 0xc8200b6018)
	/Users/david/weave/src/github.com/weaveworks/challenges/backend/server/main.go:61 +0x6fd fp=0xc82004bf90 sp=0xc82004bca0
runtime.goexit()
	/usr/local/Cellar/go/1.6.2/libexec/src/runtime/asm_amd64.s:1998 +0x1 fp=0xc82004bf98 sp=0xc82004bf90
created by main.main
	/Users/david/weave/src/github.com/weaveworks/challenges/backend/server/main.go:41 +0x42c

goroutine 1 [IO wait]:
net.runtime_pollWait(0x3a1360, 0x72, 0x39c028)
	/usr/local/Cellar/go/1.6.2/libexec/src/runtime/netpoll.go:160 +0x60
net.(*pollDesc).Wait(0xc82006a0d0, 0x72, 0x0, 0x0)
	/usr/local/Cellar/go/1.6.2/libexec/src/net/fd_poll_runtime.go:73 +0x3a
net.(*pollDesc).WaitRead(0xc82006a0d0, 0x0, 0x0)
	/usr/local/Cellar/go/1.6.2/libexec/src/net/fd_poll_runtime.go:78 +0x36
net.(*netFD).accept(0xc82006a070, 0x0, 0x3a1498, 0xc8200c43a0)
	/usr/local/Cellar/go/1.6.2/libexec/src/net/fd_unix.go:426 +0x27c
net.(*TCPListener).AcceptTCP(0xc820090020, 0xc82004be58, 0x0, 0x0)
	/usr/local/Cellar/go/1.6.2/libexec/src/net/tcpsock_posix.go:254 +0x4d
net.(*TCPListener).Accept(0xc820090020, 0x0, 0x0, 0x0, 0x0)
	/usr/local/Cellar/go/1.6.2/libexec/src/net/tcpsock_posix.go:264 +0x3d
main.main()
	/Users/david/weave/src/github.com/weaveworks/challenges/backend/server/main.go:37 +0x3cb

goroutine 17 [syscall, locked to thread]:
runtime.goexit()
	/usr/local/Cellar/go/1.6.2/libexec/src/runtime/asm_amd64.s:1998 +0x1

goroutine 20 [syscall]:
os/signal.signal_recv(0x0)
	/usr/local/Cellar/go/1.6.2/libexec/src/runtime/sigqueue.go:116 +0x132
os/signal.loop()
	/usr/local/Cellar/go/1.6.2/libexec/src/os/signal/signal_unix.go:22 +0x18
created by os/signal.init.1
	/usr/local/Cellar/go/1.6.2/libexec/src/os/signal/signal_unix.go:28 +0x37

goroutine 21 [chan receive]:
main.main.func1(0x3a03e0, 0xc820090020)
	/Users/david/weave/src/github.com/weaveworks/challenges/backend/server/main.go:32 +0xfc
created by main.main
	/Users/david/weave/src/github.com/weaveworks/challenges/backend/server/main.go:34 +0x3b7

goroutine 22 [select, locked to thread]:
runtime.gopark(0x1ef4d0, 0xc820024728, 0x1a9fb8, 0x6, 0x18, 0x2)
	/usr/local/Cellar/go/1.6.2/libexec/src/runtime/proc.go:262 +0x163
runtime.selectgoImpl(0xc820024728, 0x0, 0x18)
	/usr/local/Cellar/go/1.6.2/libexec/src/runtime/select.go:392 +0xa67
runtime.selectgo(0xc820024728)
	/usr/local/Cellar/go/1.6.2/libexec/src/runtime/select.go:215 +0x12
runtime.ensureSigM.func1()
	/usr/local/Cellar/go/1.6.2/libexec/src/runtime/signal1_unix.go:279 +0x32c
runtime.goexit()
	/usr/local/Cellar/go/1.6.2/libexec/src/runtime/asm_amd64.s:1998 +0x1
```

Reproduces via:

```
$ ./server-darwin &
$ ./proxy 2> stderr.logs &
$ cat /dev/random | nc localhost 8000
```

Possible Solution:
Thanks David for the task: `/Users/david/weave/src/`
I think it is good to rebuild bin via go 1.8: `/usr/local/Cellar/go/1.6.2`

## Benchamrk:

```
$ ./server-darwin -listen=:8001
$ while true; do ./client-darwin -connect=localhost:8002 ; done
$ ./proxy -listen=:8002 -forward=localhost:8001 2> stderr.logs
{"msg_total":1800,"msg_req":900,"msg_ack":792,"msg_nak":108,"request_rate_1s":100,"request_rate_10s":90,"response_rate_1s":100,"response_rate_10s":90}
{"msg_total":2000,"msg_req":1000,"msg_ack":880,"msg_nak":120,"request_rate_1s":0,"request_rate_10s":100,"response_rate_1s":0,"response_rate_10s":100}
{"msg_total":4649,"msg_req":2325,"msg_ack":2044,"msg_nak":280,"request_rate_1s":25,"request_rate_10s":22.5,"response_rate_1s":24,"response_rate_10s":22.4}
{"msg_total":4800,"msg_req":2400,"msg_ack":2112,"msg_nak":288,"request_rate_1s":100,"request_rate_10s":30,"response_rate_1s":100,"response_rate_10s":30}
{"msg_total":5000,"msg_req":2500,"msg_ack":2200,"msg_nak":300,"request_rate_1s":0,"request_rate_10s":40,"response_rate_1s":0,"response_rate_10s":40}
{"msg_total":6600,"msg_req":3300,"msg_ack":2904,"msg_nak":396,"request_rate_1s":0,"request_rate_10s":10,"response_rate_1s":0,"response_rate_10s":10}
{"msg_total":19400,"msg_req":9700,"msg_ack":8536,"msg_nak":1164,"request_rate_1s":3800,"request_rate_10s":650,"response_rate_1s":3800,"response_rate_10s":650}
{"msg_total":22600,"msg_req":11300,"msg_ack":9944,"msg_nak":1356,"request_rate_1s":500,"request_rate_10s":50,"response_rate_1s":500,"response_rate_10s":50}
{"msg_total":33600,"msg_req":16800,"msg_ack":14784,"msg_nak":2016,"request_rate_1s":482,"request_rate_10s":600,"response_rate_1s":482,"response_rate_10s":600}
{"msg_total":82668,"msg_req":41334,"msg_ack":36374,"msg_nak":4960,"request_rate_1s":5461,"request_rate_10s":274.9,"response_rate_1s":5461,"response_rate_10s":275}
{"msg_total":86179,"msg_req":43090,"msg_ack":37917,"msg_nak":5172,"request_rate_1s":1690,"request_rate_10s":450.5,"response_rate_1s":1689,"response_rate_10s":450.5}
{"msg_total":89683,"msg_req":44842,"msg_ack":39460,"msg_nak":5381,"request_rate_1s":3442,"request_rate_10s":625.7,"response_rate_1s":3441,"response_rate_10s":625.7}
{"msg_total":93695,"msg_req":46848,"msg_ack":41225,"msg_nak":5622,"request_rate_1s":148,"request_rate_10s":826.3,"response_rate_1s":147,"response_rate_10s":826.3}
{"msg_total":97530,"msg_req":48765,"msg_ack":42913,"msg_nak":5852,"request_rate_1s":2065,"request_rate_10s":1018,"response_rate_1s":2065,"response_rate_10s":1018.1}
{"msg_total":101168,"msg_req":50584,"msg_ack":44513,"msg_nak":6071,"request_rate_1s":3884,"request_rate_10s":1199.9,"response_rate_1s":3884,"response_rate_10s":1200}
{"msg_total":104776,"msg_req":52388,"msg_ack":46100,"msg_nak":6288,"request_rate_1s":474,"request_rate_10s":1380.3,"response_rate_1s":475,"response_rate_10s":1380.4}
{"msg_total":108400,"msg_req":54200,"msg_ack":47696,"msg_nak":6504,"request_rate_1s":2286,"request_rate_10s":1561.5,"response_rate_1s":2287,"response_rate_10s":1561.6}
{"msg_total":112054,"msg_req":56027,"msg_ack":49303,"msg_nak":6724,"request_rate_1s":4113,"request_rate_10s":1744.2,"response_rate_1s":4114,"response_rate_10s":1744.3}
{"msg_total":116249,"msg_req":58125,"msg_ack":51148,"msg_nak":6976,"request_rate_1s":872,"request_rate_10s":1954,"response_rate_1s":871,"response_rate_10s":1954}
{"msg_total":120200,"msg_req":60100,"msg_ack":52888,"msg_nak":7212,"request_rate_1s":2847,"request_rate_10s":2151.5,"response_rate_1s":2847,"response_rate_10s":2151.6}
{"msg_total":123800,"msg_req":61900,"msg_ack":54472,"msg_nak":7428,"request_rate_1s":4647,"request_rate_10s":2331.5,"response_rate_1s":4647,"response_rate_10s":2331.6}
{"msg_total":127384,"msg_req":63692,"msg_ack":56048,"msg_nak":7644,"request_rate_1s":1092,"request_rate_10s":2510.7,"response_rate_1s":1092,"response_rate_10s":2510.8}
{"msg_total":132400,"msg_req":66200,"msg_ack":58256,"msg_nak":7944,"request_rate_1s":3600,"request_rate_10s":2761.5,"response_rate_1s":3600,"response_rate_10s":2761.6}
{"msg_total":136056,"msg_req":68028,"msg_ack":59864,"msg_nak":8164,"request_rate_1s":5428,"request_rate_10s":2944.3,"response_rate_1s":5428,"response_rate_10s":2944.4}
{"msg_total":139600,"msg_req":69800,"msg_ack":61424,"msg_nak":8376,"request_rate_1s":1728,"request_rate_10s":172.8,"response_rate_1s":1729,"response_rate_10s":172.9}
{"msg_total":144600,"msg_req":72300,"msg_ack":63624,"msg_nak":8676,"request_rate_1s":4228,"request_rate_10s":422.8,"response_rate_1s":4229,"response_rate_10s":422.9}
{"msg_total":150225,"msg_req":75113,"msg_ack":66098,"msg_nak":9014,"request_rate_1s":1813,"request_rate_10s":704.1,"response_rate_1s":1812,"response_rate_10s":704.1}
{"msg_total":160000,"msg_req":80000,"msg_ack":70400,"msg_nak":9600,"request_rate_1s":1200,"request_rate_10s":1192.8,"response_rate_1s":1200,"response_rate_10s":1192.9}
```