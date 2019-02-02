package server

import (
	"fmt"

	pb "bitbucket.org/miry/miry-readdle-test/pkg/chat"
)

type Connection struct {
	User    pb.User
	Streams []*Stream
	Deleted bool
}

func NewConnection(username string, stream *pb.Chat_ChannelServer) *Connection {
	return &Connection{
		User: pb.User{Name: username},
		Streams: []*Stream{
			&Stream{Server: stream},
		},
	}
}

func (connect *Connection) AddStream(stream *pb.Chat_ChannelServer) {
	fmt.Printf("DEBUG: Adding stream server %v\n", stream)
	connect.Streams = append(connect.Streams, &Stream{Server: stream})
}

func (connect *Connection) DeleteStream(server *pb.Chat_ChannelServer) {
	for i, stream := range connect.Streams {
		fmt.Printf("DEBUG: stream.Server[%d]: %+v == %p\n", i, stream.Server, server)
		if stream.Server == server {
			stream.Deleted = true
			fmt.Printf("DEBUG: Mark stream %#v as deleted\n", stream)
			return
		}
	}
}

func (connect *Connection) NStreams() int {
	result := 0
	for _, stream := range connect.Streams {
		fmt.Printf("DEBUG: Check stream %#v\n", stream)
		if !stream.Deleted {
			result++
		}
	}
	return result
}

func (connect *Connection) Clean() {
	result := []*Stream{}
	for _, stream := range connect.Streams {
		if !stream.Deleted {
			result = append(result, stream)
		}
	}
	connect.Streams = result
}

type Stream struct {
	Server  *pb.Chat_ChannelServer
	Deleted bool
}

func (stream *Stream) Send(msg *pb.Text) error {
	if stream.Server == nil {
		return fmt.Errorf("No server")
	}
	server := *stream.Server
	return server.Send(msg)
}
