package net

import (
	"encoding/hex"
	"fmt"
	"io"
	"log"
	"net"
)

// Client specify client connection to server
type Client struct {
	Conn net.Conn
}

func (c *Client) String() string {
	return c.Conn.RemoteAddr().String()
}

// Close client connection
func (c *Client) Close() {
	c.Conn.Close()
}

// Read bytes from connection
func (c *Client) Read() ([]byte, error) {
	result := make([]byte, netBufferSize)
	n, err := c.Conn.Read(result)
	if err != nil {
		if err == io.EOF {
			log.Printf("[%s] INFO: Connection closed", c)
			return nil, err
		}

		log.Printf("[%s] ERROR: %v", c, err)
		return nil, err
	}
	log.Printf("[%s] DEBUG: Read %d bytes from client", c, n)
	log.Printf("\n%s", hex.Dump(result[:n]))
	return result[:n], nil
}

// Write bytes to connection
func (c *Client) Write(buf []byte) error {
	n, err := c.Conn.Write(buf)
	if err != nil {
		return fmt.Errorf("failed to write to client %v : %v", c, err)
	}
	log.Printf("[%s] Write %d bytes to client\n", c, n)
	return nil
}
