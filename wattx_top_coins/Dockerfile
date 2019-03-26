FROM golang:rc-alpine3.8 AS build

RUN apk add --no-cache \
      git \
      bash \
      ca-certificates \
      gcc \
      musl-dev \
 && go get -u github.com/golang/dep/cmd/dep

WORKDIR /go/src/github.com/miry/wattx_top_coins

COPY . .

ENV GO111MODULE=on

RUN go get . \
 && go generate pkg/version/base.go \
 && go build -o /go/bin/coinmarketcapctl cmd/coinmarketcapctl/main.go \
 && go build -o /go/bin/top_coins cmd/top_coins/main.go

FROM alpine:3.8
RUN apk add --no-cache \
      bash \
      curl \
      ca-certificates \
      tzdata

ENV PORT 8080
EXPOSE ${PORT}

COPY --from=build /go/bin/{top_coins,coinmarketcapctl} /
CMD ["/top_coins"]

HEALTHCHECK --interval=5m --timeout=3s \
CMD curl -f http://localhost:${PORT}/version || exit 1
