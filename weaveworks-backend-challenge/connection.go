package main

import (
	"bufio"
	"log"
	"net"
)

type Connection struct {
	income  chan string
	outcome chan string
	reader  *bufio.Reader
	writer  *bufio.Writer
	session *Session
}

func (conn *Connection) Read() {
	defer func() {
		if r := recover(); r != nil {
			log.Println("Something went wrong in Connection#Read", r)
		}
	}()

	log.Printf("Open Read %+v", conn)
	for {
		line, err := conn.reader.ReadString('\n')
		if err != nil {
			log.Printf("[%+v] Connection read problem: %+v\n", conn, err)
			if conn.session != nil {
				conn.session.done <- true
			}
			return
		}
		conn.income <- line
	}
}

func (conn *Connection) Write() {
	defer func() {
		if r := recover(); r != nil {
			log.Println("Something went wrong in Connection#Write", r)
		}
	}()

	for data := range conn.outcome {
		conn.writer.WriteString(data)
		conn.writer.Flush()
	}
}

func (conn *Connection) Listen() {
	go conn.Read()
	go conn.Write()
}

func (conn *Connection) Close() {
	close(conn.income)
	close(conn.outcome)
}

func NewConnection(conn net.Conn) *Connection {
	result := &Connection{
		income:  make(chan string),
		outcome: make(chan string),
		reader:  bufio.NewReader(conn),
		writer:  bufio.NewWriter(conn),
	}
	result.Listen()

	return result
}
