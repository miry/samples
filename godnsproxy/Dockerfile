FROM golang:rc-alpine3.8 AS build

RUN apk add --no-cache \
      git \
      bash \
      ca-certificates \
      gcc \
      musl-dev

WORKDIR /go/src/github.com/miry/smaples/godnsproxy

COPY . .

ENV GO111MODULE=on

RUN go get . \
 && go build -o /go/bin/dnstls cmd/dnstls/main.go \
 && go build -o /go/bin/dnsproxy cmd/dnsproxy/main.go

FROM alpine:3.8
RUN apk add --no-cache \
      bash \
      curl \
      netcat-openbsd \
      ca-certificates \
      tzdata

ENV PORT 8080
EXPOSE ${PORT}

COPY --from=build /go/bin/dnsproxy /
COPY --from=build /go/bin/dnstls /
CMD ["/dnsproxy"]

HEALTHCHECK --interval=5m --timeout=3s \
CMD nc -v -u -z -w 5 localhost ${PORT}
