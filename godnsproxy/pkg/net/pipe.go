package net

import "log"

func Pipe(src *Client, dst *Client, exit chan int) {
	defer func() {
		if x := recover(); x != nil {
			// TODO: Create a better way to handle closed channel with quit
			log.Printf("PANIC: %v", x)
			return
		}
	}()

	for {
		if src.Closed() || dst.Closed() {
			log.Printf("[%s -> %s] DEBUG: Connection is closed, no connection required", src, dst)
			break
		}

		buf, err := src.Read()
		if err != nil {
			log.Printf("[%s -> %s] ERROR: reading : marking of exit becuase of %v", src, dst, err)
			exit <- 1
			break
		}

		err = dst.Write(buf)
		if err != nil {
			log.Printf("[%s -> %s] ERROR: writing : marking of exit becuase of %v", src, dst, err)
			exit <- 1
			break
		}
	}

	log.Printf("[%s -> %s] DEBUG: Closed pipe", src, dst)
}
