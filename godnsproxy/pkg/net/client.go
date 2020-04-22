package net

import (
	"encoding/hex"
	"fmt"
	"io"
	"log"
	"net"
	"time"
)

// Client specify client connection to server
type Client struct {
	Conn net.Conn
	quit bool
}

func (c *Client) String() string {
	return c.Conn.RemoteAddr().String()
}

// Close client connection
func (c *Client) Close() error {
	c.quit = true
	log.Printf("[%s] DEBUG: Closing connection", c)
	err := c.Conn.Close()
	if err != nil {

		log.Printf("[%s] ERROR: On close connection: %v\n", c, err)
	}
	return err
}

// Read reads bytes from connection
func (c *Client) Read() ([]byte, error) {
	result := make([]byte, netBufferSize)
	if c.Closed() {
		return result[:0], nil
	}

	c.Conn.SetDeadline(time.Now().Add(readTimeout))
	n, err := c.Conn.Read(result)
	if err != nil {
		if err == io.EOF {
			log.Printf("[%s] DEBUG: Connection closed", c)
			return nil, err
		}

		if opErr, ok := err.(*net.OpError); ok {
			if opErr.Timeout() {
				log.Printf("[%s] net: Read Timeout", c)
			} else {
				log.Printf("[%s] net ERROR: read from socket: %v %T %v", c, opErr.Temporary(), err, opErr)
			}
			log.Printf("\n%s", hex.Dump(result[:n]))
			return result[:n], nil
		}

		log.Printf("[%s] ERROR: read from socket: %T %v", c, err, err)
		return nil, err
	}
	log.Printf("[%s] DEBUG: Read %d bytes from client", c, n)
	log.Printf("\n%s", hex.Dump(result[:n]))
	return result[:n], nil
}

// Write writes bytes to connection
func (c *Client) Write(buf []byte) error {
	c.Conn.SetDeadline(time.Now().Add(readTimeout))
	n, err := c.Conn.Write(buf)
	if err != nil {
		if opErr, ok := err.(*net.OpError); ok {
			if opErr.Timeout() {
				log.Printf("[%s] net: Write Timeout", c)
			}
			return nil
		}
		return fmt.Errorf("failed to write to client %v : %v", c, err)
	}
	log.Printf("[%s] DEBUG: Write %d bytes to client\n", c, n)
	return nil
}

// Closed returns the state of connection
func (c *Client) Closed() bool {
	return c.quit
}

// ClientUDP specify UDP connection to server
type ClientUDP struct {
	Addr net.Addr
	Conn net.PacketConn
	quit bool
}

// Close client connection
func (c ClientUDP) Close() error {
	c.quit = true
	log.Printf("[%s] DEBUG: Closing connection", c.Addr)
	return nil
}

func (c ClientUDP) String() string {
	if c.Addr == nil {
		return ""
	}
	return c.Addr.String()
}
