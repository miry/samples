FROM golang:1.11-rc-alpine3.7

RUN apk add --update --no-cache \
            git \
            bash \
            ca-certificates \
            gcc \
            musl-dev \
 && go get -u github.com/golang/dep/cmd/dep

WORKDIR /go/src/github.com/miry/samples/hellofresh

COPY . .

RUN dep ensure \
 && go generate pkg/conf/vsn.go \
 && go test -v ./... \
 && go build -o /go/bin/recipes cmd/recipes/main.go

FROM alpine:3.7
RUN apk add --update --no-cache \
        bash \
        curl \
        ca-certificates \
        tzdata

ENV PORT 8080
EXPOSE ${PORT}

COPY --from=0 /go/bin/recipes /recipes
CMD ["/recipes"]

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost:${PORT}/version || exit 1
