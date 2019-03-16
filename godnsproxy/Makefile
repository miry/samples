build: dnstls

dnstls:
	./build/run

proxy:
	go run ./cmd/proxy/main.go -address tcp4://127.0.0.1:8080 -upstream tcp4://1.1.1.1:80

proxy-test:
	dd if=/dev/random of=/dev/stdout count=10 | nc localhost 8080
