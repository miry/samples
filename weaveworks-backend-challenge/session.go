package main

import (
	"log"
	"net"
)

type Session struct {
	client *Connection
	server *Connection
	done   chan bool
}

func NewSession(clientConn, serverConn net.Conn) *Session {
	client := NewConnection(clientConn)
	server := NewConnection(serverConn)

	result := &Session{client: client, server: server, done: make(chan bool)}
	client.session = result
	server.session = result
	return result
}

// Start is connecting 2 channels to 1 stream
func (session *Session) Start(mesure *Mesure) {
	log.Printf("start: session: %+v\n", session)
	for {
		select {
		case msg := <-session.client.income:
			session.server.outcome <- msg
			mesure.Process(msg)
		case msg := <-session.server.income:
			session.client.outcome <- msg
			mesure.Process(msg)
		case <-session.done:
			session.Close()
			return
		}
	}
}

func (session *Session) Close() {
	close(session.done)
	session.client.Close()
	session.server.Close()
}
