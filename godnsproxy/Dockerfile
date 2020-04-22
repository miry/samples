# Builder
FROM golang:alpine AS build

RUN apk add --no-cache \
      git \
      bash \
      ca-certificates \
      gcc \
      musl-dev

WORKDIR /go/src/github.com/miry/smaples/godnsproxy

COPY . .

ENV GO111MODULE=on

RUN go build -o /go/bin/proxy ./cmd/proxy/ \
 && go build -o /go/bin/dnsproxy ./cmd/dnsproxy/

# Runner
FROM alpine
RUN apk add --no-cache \
      # bash \
      # curl \
      netcat-openbsd \
      ca-certificates \
      tzdata

ENV PORT 8053
EXPOSE ${PORT}/udp

USER 1001

COPY --from=build /go/bin/dnsproxy /
COPY --from=build /go/bin/proxy /
CMD /dnsproxy -address udp://0.0.0.0:${PORT} -upstream tls://1.1.1.1:853

HEALTHCHECK --interval=5m --timeout=3s \
CMD nc -v -u -z -w 5 localhost ${PORT}
