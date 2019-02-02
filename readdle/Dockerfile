FROM golang:1.11rc2-alpine3.7 AS builder

RUN apk add --update --no-cache \
            git \
            mercurial \
            bash \
            ca-certificates \
            gcc \
            musl-dev \
            protobuf \
 && go get -u github.com/golang/dep/cmd/dep \
 && go get -u github.com/golang/protobuf/protoc-gen-go

WORKDIR /go/src/bitbucket.org/miry/miry-readdle-test

COPY Gopkg.* ./
RUN dep ensure --vendor-only

COPY . .
RUN go generate pkg/version/base.go \
 && protoc -I ./pkg/chat/ --go_out=plugins=grpc:./pkg/chat chat.proto \
 && go test -v ./... \
 && go build -o /go/bin/client cmd/client/main.go \
 && go build -o /go/bin/server cmd/server/main.go

FROM alpine:3.7
RUN apk add --update --no-cache \
        bash \
        curl \
        ca-certificates \
        tzdata

ENV PORT="50051"

COPY --from=builder /go/bin/server /server
COPY --from=builder /go/bin/client /client
CMD /server -address 0.0.0.0:$PORT
