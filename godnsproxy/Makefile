build: dnstls

dnstls:
	./build/run

proxy:
	go run ./cmd/proxy/main.go -address tcp4://127.0.0.1:8080 -upstream tcp4://1.1.1.1:80

proxy-dns:
	# go run ./cmd/proxy/main.go -address tcp4://127.0.0.1:8080 -upstream tcp4://1.1.1.1:53
	go run ./cmd/proxy/main.go -address tcp4://127.0.0.1:8080 -upstream tls://1.1.1.1:853

proxy-test:
	dd if=/dev/random of=/dev/stdout count=10 | nc localhost 8080

proxy-dns-test:
	dig @127.0.0.1 +tcp -p 8080 one.one.one.one
