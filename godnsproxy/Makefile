IMAGE ?= dnsproxy
PORT ?= 8053

default: run

.PHONY: run
run: dnsproxy

.PHONY: dnsproxy
dnsproxy:
	go run ./cmd/dnsproxy/ -address udp://127.0.0.1:8053 -upstream tls://1.1.1.1:853

.PHONY: dnsproxy-tcp
dnsproxy-tcp:
	go run ./cmd/dnsproxy/ -address tcp://127.0.0.1:8053 -upstream tls://1.1.1.1:853

.PHONY: proxy
proxy:
	go run ./cmd/proxy/ -address tcp4://127.0.0.1:8080 -upstream tcp4://1.1.1.1:80

.PHONY: proxy-dns
proxy-dns:
	go run ./cmd/proxy -address tcp4://127.0.0.1:8053 -upstream tls://1.1.1.1:853

.PHONY: proxy-test
proxy-test:
	dd if=/dev/random of=/dev/stdout count=10 | nc localhost 8080

.PHONY: proxy-dns-test
proxy-dns-test:
	dig @127.0.0.1 +tcp -p 8053 one.one.one.one

.PHONY: docker.build
docker.build:
	docker build -t $(IMAGE) .

.PHONY: docker.run
docker.run: docker.build
  docker run -p $(PORT):$(PORT)/udp -e PORT=$(PORT) $(IMAGE)

.PHONY: archive
archive:
	git archive --format=tar.gz --prefix=mnikitochkin-dnsproxy/ HEAD . > mnikitochkin-dnsproxy.tar.gz
