[![CircleCI](https://circleci.com/bb/miry/miry-readdle-test/tree/dev.svg?style=svg)](https://circleci.com/bb/miry/miry-readdle-test/tree/dev)

# Description

Create a simple chat with CLI interface
- Both client and server should be console apps. Users send messages to chat via stdin prompt
- Users must specify their names when joining chat
- Each message is broadcasted to all chat members
- Same user (identified by same name) can have multiple simultaneous clients running.
- Online status calculation: user is "online" when he/she has at least one client running, otherwise user is "offline".
- Server must notify all chat members when some user comes online or goes offline.

Example output:

```
 *** Alice is online
 *** Bob is online
 Alice:     anybody home?
 Bob:       hi
 *** Alice is offline
```

- Client and server part should be written using Golang
- Network protocol must be extensible. It should be possible to add new features in future.
- Clean, readable code. Simplicity is a plus
- All errors must be handled, some examples:
  - network failures
  - slow clients
  - invalid messages (like attempt to send message on behalf of other user)
  - etc

# Chat Commands

```
/help    - shows commands usage
/version - prints the current client and server versions
/users   - prints user names connected
```

# Usage

## Local

### Server

Run a chat server to listen for new connection. Option `address` is optional. By default it listen on `0.0.0.0:50051`.

```shell
$ bin/server -address localhost:50051
```

### Client

Run a client to connect to a server. By default it connects to `localhost:50051`.

```shell
$ bin/client -address localhost:50051 username
```

### Docker

Create a docker image and you can test. Install MacOS dependicies use `brew bundle`.

```shell
$ bin/build
$ docker run -p 50051:50051 -it miry/readdle:<commit id>
$ docker run -it miry/readdle:<commit id> /client -address $(docker-machine ip):50051 miry
```

### Staging

```shell
$ bin/staging [heroku_app_name]
```

# Development

## Environment

Develop using Go version 1.11. Docker hub did not have 1.11 release tag

```shell
 $ go version
go version go1.11 darwin/amd64

 $ dep version
dep:
 version     : devel
 build date  :
 git hash    :
 go version  : go1.10.3
 go compiler : gc
 platform    : darwin/amd64
 features    : ImportDuringSolve=false
```

## Structure

The project tries to follow the almost standard [go project layout](https://medium.com/golang-learn/go-project-layout-e5213cdcfaa2), below are some highlights:

```
$ tree -dL 2
.
├── _output
├── bin
├── build
├── cmd
│   ├── client
│   └── server
├── pkg
│   ├── chat
│   ├── server
│   └── version
└── vendor
    ├── github.com
    ├── golang.org
    └── google.golang.org
```

## Testings

```shell
$ go test -v ./...
```
