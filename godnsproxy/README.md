dnstls
======

Tool to query DNS over TLS.

# Usage

## Proxy

```
$ make proxy
$ curl -v 127.0.0.1:8080
$ make proxy-test
```

## DNS proxy

UDP proxy to TLS

```
$ make dnsproxy
$ dig @127.0.0.1 -p 1053 one.one.one.one
```

TCP proxy to TLS

```
$ make proxy-dns
$ make proxy-dns-test
```

## Docker

```
$ ./build/run
$ docker run -p 8053:8053/udp -it miry/dnsproxy
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

# Investigation

Checked documentation https://routley.io/tech/2017/12/28/hand-writing-dns-messages.html how DNS message is buidling, in short version.

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
