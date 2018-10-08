# Foo protocol proxy

## Protocol

Foo is a simple, powerful, extensible, cloud-native request/response protocol.
Foo protocol messages are UTF-8 encoded strings with the following BNF-ish definition:

```
Msg  := Type <whitespace> Seq [<whitespace> Data] '\n'
Type := "REQ" | "ACK" | "NAK"
Seq  := <integer>
Data := <string without newline>
```

A Msg is composed of
 a Type string, either "REQ", "ACK", or "NAK";
 a Seq integer, starting with 1;
 an optional Data string;
 and a terminating newline character '\n', 0x0A.
A Foo client initiates a TCP connection to a Foo server,
 sends messages and receives replies in the request/response pattern,
 and eventually terminates the connection.
Clients produce REQ messages, and servers respond with ACK or NAK messages.
Only clients may terminate the connection.

Here is a valid example exchange of messages:

```
A->B: <connect>
A->B: REQ 1 Hey\n
A<-B: ACK 1 Hello\n
A->B: REQ 2 Hey there\n
A<-B: ACK 2\n
A->B: REQ 3 Hey\n
A->B: REQ 4 Hey\n
A->B: REQ 5 Hey\n
A<-B: ACK 3 What\n
A<-B: ACK 4 What do you want\n
A->B: REQ 6 Hey\n
A<-B: NAK 5 Stop it\n
A<-B: NAK 6 Stop doing that\n
A->B: <disconnect>
```

## Task

Your task is to write a Foo protocol proxy server, which sits "in front" of an existing Foo server.
It should accept connections from arbitrary clients, and proxy them to the server.
In addition, it should collect statistics for the traffic that it proxies.
When your proxy receives SIGUSR1, it should report the current statistics to stdout as a JSON object.
Your object may include as many statistics as you like, but we will check for the following fields, named exactly as shown.

- `msg_total` — total number of messages (integer)
- `msg_req` — total number of REQ messages (integer)
- `msg_ack` — total number of ACK messages (integer)
- `msg_nak` — total number of NAK messages (integer)
- `request_rate_1s` — average REQ messages/sec, in a 1s moving window (floating point)
- `request_rate_10s` — average REQ messages/sec, in a 10s moving window (floating point)
- `response_rate_1s` — average ACK+NAK messages per second, in a 1s moving window (floating point)
- `response_rate_10s` — average ACK+NAK messages per second, in a 10s moving window (floating point)

## Test driver

In addition to this document, you should have received **server** and **client** binaries.
You may use these to confirm your proxy is behaving correctly.
The client will connect to the server, send a specific number of requests, and report results.

```
$ ./server
$ ./client
..........OK!
```

The client should work identically if you put your proxy in the middle.

```
$ ./server -listen=:8001
$ ./proxy -listen=:8002 -forward=localhost:8001
$ ./client -connect=localhost:8002
..........OK!
```

## Submission requirements

Language choice is entirely up to you.

Please submit the complete source code to your proxy (not the binaries).
Be sure to include a README or equivalent, with build and usage instructions.
Your submission should have as few third-party dependencies as possible,
 ideally none beyond your language's standard library.

Your submission should be what you consider _production quality_.
Treat your reviewers as you would treat your colleagues.
But, please don't spend more than 4 hours on this task.
If you need to leave some things out due to time constraints, no problem: just make a note in the code or README.

