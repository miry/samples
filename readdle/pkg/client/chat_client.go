package client

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"os"
	"strings"
	"time"

	context "golang.org/x/net/context"
	"google.golang.org/grpc"

	pb "bitbucket.org/miry/miry-readdle-test/pkg/chat"
	"bitbucket.org/miry/miry-readdle-test/pkg/version"
)

type ChatClient struct {
	Address  string
	Username string
}

func (c *ChatClient) Run() error {
	// Connect to server port
	conn, err := grpc.Dial(c.Address, grpc.WithInsecure())
	if err != nil {
		return fmt.Errorf("could not connect to %s: %v", c.Address, err)
	}
	defer conn.Close()
	chat := pb.NewChatClient(conn)

	go watchForConnectionInput(chat, c.Username)

	for true {
		err = watchForConsoleInput(chat, c.Username)
		if err != nil {
			// Handle Ctrl+D
			if err == io.EOF {
				fmt.Println()
				break
			}
			log.Printf("ERROR: Could not get input from console: %v", err)
		}
	}

	return nil
}

func watchForConnectionInput(chat pb.ChatClient, username string) {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	stream, err := chat.Channel(ctx, &pb.ConnectRequest{Username: username})
	if err != nil {
		log.Fatalf("%v.Channel(_) = _, %v", chat, err)
	}

	waitc := make(chan struct{})
	go func() {
		for {
			in, err := stream.Recv()
			if err == io.EOF {
				log.Printf("DEBUG: Server disconected")
				close(waitc)
				return
			}
			if err != nil {
				log.Fatalf("Failed to receive a message : %v", err)
			}
			log.Printf("%-12s     %s", in.Username+":", in.Message)
		}
	}()

	stream.CloseSend()
	<-waitc
	log.Printf("DEBUG: Exited from watchForConnectionInput!")
}

func watchForConsoleInput(chat pb.ChatClient, username string) error {
	// prompt(username)
	reader := bufio.NewReader(os.Stdin)
	for true {
		message, err := reader.ReadString('\n')
		if err != nil {
			return err
		}

		if err := processCommand(chat, username, message); err != nil {
			return err
		}

		// prompt(username)
	}
	return nil
}

func sendMessage(chat pb.ChatClient, username, message string) error {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()

	r, err := chat.Say(ctx, &pb.Text{Username: username, Message: message})
	if err != nil {
		return fmt.Errorf("could not send message: %v", err)
	}
	if r.Error == true {
		return fmt.Errorf("could not send message: %v", r.GetMessage())
	}
	return nil
}

func processCommand(chat pb.ChatClient, username, message string) error {
	switch text := strings.TrimSpace(message); text {
	case "":
	case "/help":
		fmt.Println("<message> : Send message to all users")
		fmt.Println("/version  : Get current client and server versions")
		fmt.Println("/users    : Show online user list")
	case "/users":
		err := printUsers(chat)
		if err != nil {
			return err
		}
	case "/version":
		err := printVersion(chat)
		if err != nil {
			return err
		}
	default:
		err := sendMessage(chat, username, text)
		if err != nil {
			return err
		}
	}
	return nil
}

func prompt(username string) {
	fmt.Printf("@%s > ", username)
}

func printVersion(chat pb.ChatClient) error {
	clientVersion := version.Get()
	log.Printf("Client Version: %s\n", fmt.Sprintf("%#v", clientVersion))
	if chat == nil {
		return nil
	}

	serverVersion, err := getServerVersion(chat)
	if err != nil {
		return fmt.Errorf("could not get server version: %v", err)
	}
	log.Printf("Server Version: %s\n", serverVersion)
	return nil
}

func getServerVersion(chat pb.ChatClient) (string, error) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()

	r, err := chat.Version(ctx, &pb.Empty{})
	if err != nil {
		return "", fmt.Errorf("could not get version: %v", err)
	}

	if r.Error == true {
		return "", fmt.Errorf("could not get version: %v", r.GetMessage())
	}

	return r.GetMessage(), nil
}

func printUsers(chat pb.ChatClient) error {
	users, err := getServerUsers(chat)
	if err != nil {
		return err
	}
	for _, u := range users {
		log.Println("- " + u.Name)
	}
	return nil
}

func getServerUsers(chat pb.ChatClient) ([]*pb.User, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	r, err := chat.Users(ctx, &pb.Empty{})
	if err != nil {
		return nil, fmt.Errorf("could not get users: %v", err)
	}

	return r.GetUsers(), nil
}
