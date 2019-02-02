package server

import (
	"fmt"
	"log"

	pb "bitbucket.org/miry/miry-readdle-test/pkg/chat"
	"bitbucket.org/miry/miry-readdle-test/pkg/version"
	context "golang.org/x/net/context"
)

type ChatServer struct {
	connections map[string]*Connection
}

func (s *ChatServer) Say(ctx context.Context, in *pb.Text) (*pb.Confirm, error) {
	// TODO: validate username on allowed characters
	if in.Username == "" {
		log.Println("Got broken message: Missing username")
		return nil, fmt.Errorf("Username is nat valid")
	}

	_, err := s.addUser(in.Username, nil)
	if err != nil {
		return nil, err
	}

	// TODO: validate message on allowed characters
	log.Printf("INFO: *** @%s sent message: %s\n", in.Username, in.Message)

	s.broadcast(in)

	return &pb.Confirm{Message: "Roger"}, nil
}

func (s *ChatServer) Version(ctx context.Context, in *pb.Empty) (*pb.Confirm, error) {
	serverVersion := version.Get()
	return &pb.Confirm{Message: fmt.Sprintf("%#v", serverVersion)}, nil
}

func (s *ChatServer) Users(ctx context.Context, in *pb.Empty) (*pb.UserList, error) {
	count := len(s.connections)
	result := make([]*pb.User, count, count)
	i := 0
	for username := range s.connections {
		result[i] = &pb.User{Name: username}
		i++
	}
	return &pb.UserList{Users: result}, nil
}

func (s *ChatServer) Channel(in *pb.ConnectRequest, stream pb.Chat_ChannelServer) error {
	log.Printf("DEBUG: Channel created %s: %#v\n", in.Username, stream)

	created, err := s.addUser(in.Username, &stream)
	if err != nil {
		return err
	}

	var msg *pb.Text
	if created {
		msg = &pb.Text{Message: fmt.Sprintf("@%s logged in", in.Username), Username: "***"}
		s.broadcast(msg)
	}

	<-stream.Context().Done()

	log.Printf("DEBUG: %s channel closed\n", in.Username)

	connect, ok := s.connections[in.Username]
	if ok {
		connect.DeleteStream(&stream)
		connect.Clean()
	}

	if !ok || (ok && connect.NStreams() == 0) {
		msg = &pb.Text{Message: fmt.Sprintf("@%s logged out", in.Username), Username: "***"}
		s.broadcast(msg)
	}

	return stream.Context().Err()
}

// Register user and returns true, if there is user with same name, then returns false
func (s *ChatServer) addUser(username string, stream *pb.Chat_ChannelServer) (bool, error) {
	newUser := false
	if s.connections == nil {
		s.connections = make(map[string]*Connection)
	}

	if _, ok := s.connections[username]; !ok {
		log.Printf("INFO: *** @%s connected\n", username)
		newUser = true
		s.connections[username] = NewConnection(username, stream)
	} else {
		if stream != nil {
			connect := s.connections[username]
			connect.AddStream(stream)
			s.connections[username] = connect
		}
	}
	return newUser, nil
}

func (s *ChatServer) broadcast(msg *pb.Text) {
	removed := []string{}
	for username, connect := range s.connections {
		if len(connect.Streams) == 0 {
			log.Printf("WARNING: There is no connection for user %s", username)
			removed = append(removed, username)
			continue
		}

		log.Printf("DEBUG: Sending message to @%s", username)
		for _, stream := range connect.Streams {
			if err := stream.Send(msg); err != nil {
				log.Printf("ERROR: Could not send message to %s: %v", username, err)
				continue
			}
		}
	}

	// Extract to channel
	for _, key := range removed {
		log.Printf("INFO: *** @%s disconnected", key)
		delete(s.connections, key)
	}
}
