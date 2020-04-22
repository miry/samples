dnstls
======

Tool to query DNS over TLS.

## Usage

`go run ./cmd/dnsproxy/ -address <protocol>://<host>:<port>  -upstream <protocol>://<host>:<port>`

Examples:

```shell
$ go run ./cmd/dnsproxy/ -address udp://127.0.0.1:8053  -upstream tls://1.1.1.1:853
$ go run ./cmd/dnsproxy/ -address tcp://127.0.0.1:8053  -upstream tls://1.1.1.1:853
```

`address` - specifies on which interface, port and protocol proxy is listening
`upstream` - specifies where it should proxy requests

## Makefile

UDP proxy to TLS

```
$ make dnsproxy
$ dig @127.0.0.1 -p 8053 one.one.one.one
```

TCP proxy to TLS

```shell
$ make dnsproxy-tcp
$ dig @127.0.0.1 +tcp -p 8053 one.one.one.one
```

### Docker

It runs UDP version of DNS proxy

```
$ ./build/run
$ make docker.run
$ dig @127.0.0.1 -p 8053 one.one.one.one
```

# Development

## Build

```
$ ./build/run
```

Currently working on Proxy tool and have more clean code. DNSProxy is under development.

TODO:

- [ ] Extract code to pkg
- [ ] Reuse proxy pkg in DNS proxy
- [ ] Handle TCP and UDP in same time
- [ ] Support proxy of UDP to UDP communications
- [ ] Allow use TLS connection to proxy
- [ ] Use connection pool for upstreams

# Investigation

Checked post  [Let's hand write DNS messages by ](https://routley.io/posts/hand-writing-dns-messages/) how DNS message is buidling, in short version.

To check difference between UDP and TCP dns requests used util proxy, also used wireshark+tcpdump.

```
UDP:
Read 44 bytes from client
00000000  11 99 01 20 00 01 00 00  00 00 00 01 03 6f 6e 65  |... .........one|
00000010  03 6f 6e 65 03 6f 6e 65  03 6f 6e 65 00 00 01 00  |.one.one.one....|
00000020  01 00 00 29 10 00 00 00  00 00 00 00              |...)........|

00000000  86 81 01 20 00 01 00 00  00 00 00 01 03 6f 6e 65  |... .........one|
00000010  03 6f 6e 65 03 6f 6e 65  03 6f 6e 65 00 00 01 00  |.one.one.one....|
00000020  01 00 00 29 10 00 00 00  00 00 00 00              |...)........|

00000000  53 77 01 20 00 01 00 00  00 00 00 01 03 6f 6e 65  |Sw. .........one|
00000010  03 6f 6e 65 03 6f 6e 65  03 6f 6e 65 00 00 01 00  |.one.one.one....|
00000020  01 00 00 29 10 00 00 00  00 00 00 00              |...)........|
```

```
TCP:
Read 46 bytes from client
00000000  00 2c 2a 57 01 20 00 01  00 00 00 00 00 01 03 6f  |.,*W. .........o|
00000010  6e 65 03 6f 6e 65 03 6f  6e 65 03 6f 6e 65 00 00  |ne.one.one.one..|
00000020  01 00 01 00 00 29 10 00  00 00 00 00 00 00        |.....)........|

00000000  00 2c 71 91 01 20 00 01  00 00 00 00 00 01 03 6f  |.,q.. .........o|
00000010  6e 65 03 6f 6e 65 03 6f  6e 65 03 6f 6e 65 00 00  |ne.one.one.one..|
00000020  01 00 01 00 00 29 10 00  00 00 00 00 00 00        |.....)........|

00000000  00 2c ad be 01 20 00 01  00 00 00 00 00 01 03 6f  |.,... .........o|
00000010  6e 65 03 6f 6e 65 03 6f  6e 65 03 6f 6e 65 00 00  |ne.one.one.one..|
00000020  01 00 01 00 00 29 10 00  00 00 00 00 00 00        |.....)........|
```

There are 2 first bytes in UDP changes. In TCP first 2 bytes constant `00 2c`, and next 2 were changed.
It represents in this case the length of message. As fast solution, I think for UDP -> TCP over TLS add size of message.

Now checked response:

```
UDP:
Read 76 bytes from server 1.1.1.1:53
00000000  ee b5 81 80 00 01 00 02  00 00 00 01 03 6f 6e 65  |.............one|
00000010  03 6f 6e 65 03 6f 6e 65  03 6f 6e 65 00 00 01 00  |.one.one.one....|
00000020  01 c0 0c 00 01 00 01 00  00 00 e3 00 04 01 01 01  |................|
00000030  01 c0 0c 00 01 00 01 00  00 00 e3 00 04 01 00 00  |................|
00000040  01 00 00 29 05 ac 00 00  00 00 00 00              |...)........|
```

```
TCP:
[127.0.0.1:60694] Read 78 bytes from server 1.1.1.1:53
00000000  00 4c 95 4f 81 80 00 01  00 02 00 00 00 01 03 6f  |.L.O...........o|
00000010  6e 65 03 6f 6e 65 03 6f  6e 65 03 6f 6e 65 00 00  |ne.one.one.one..|
00000020  01 00 01 c0 0c 00 01 00  01 00 00 00 4e 00 04 01  |............N...|
00000030  00 00 01 c0 0c 00 01 00  01 00 00 00 4e 00 04 01  |............N...|
00000040  01 01 01 00 00 29 05 ac  00 00 00 00 00 00        |.....)........|
```

It seems again extra constant `00 4c` for TCP. Decided just cut 2 bytes.
It represents in this case the length of message.

## FAQ

* Imagine this proxy being deployed in an infrastructure. What would be the security
concerns you would raise?
  1. Is there request logging enabled?
  1. What is current open ports?
  1. Check the firewall rules for incoming traffic.
  1. Depends where the cluster is located need to check security groups or router firewall rules.
  1. Is there traffic logging application running?

* How would you integrate that solution in a distributed, microservices-oriented and
containerized architecture?

  Depends on customer requiremenets, there are several strategies to deploy applications.
  1. If the proxy used by browsers or real users: Deploy application to the cluster.
     Setup ingress network load balancer in front of the application. Deploy at least 3 instances and setup autoscalng.
  1. If the proxy used by other application in cluster and the number of request is small or there is a fallback solution if the proxy down.
     Deploy multiple instances to a cluster. Setup internal load balancer(service). Update container to have DNS server as internal proxy ip address.
  1. If the proxy used by every application in a cluster. Deploy proxy to each machine. Update resolve.conf to use localhost port for resolving hostnames.
  1. It is possible to use DNS cache proxy tools like dnsmasq or unbound infront of each proxy instance.

* What other improvements do you think would be interesting to add to the project?
  1. Implement a cache mechanism for better latency
  1. Improve performance with connection pool and create connection with keep alive
