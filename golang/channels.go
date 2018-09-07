package main

import (
	"fmt"
	"time"
)

type Buffer struct {
	Id  int
	Job int
}

var freeList = make(chan *Buffer, 100)
var serverChan = make(chan *Buffer, 10)

func client() {
	i := 0
	job := 0
	for {
		if job > 1000 {
			return
		}

		var b *Buffer
		// Grab a buffer if available; allocate if not.
		select {
		case b = <-freeList:
			// Got one; nothing more to do.
		default:
			// None free, so allocate a new one.
			b = &Buffer{i, 0}
			i++
		}
		load(b, job) // Read next message from the net.
		job++
		select {
		case serverChan <- b: // Send to server.
		default:
			fmt.Println("Could not send message", b.Id, b.Job)
			freeList <- b // reuse buffer
		}
	}
}

func server(finish chan int) {
	time.Sleep(1 * time.Millisecond)
	for {
		select {
		case b := <-serverChan:
			process(b)
			select {
			case freeList <- b:
				// Buffer on free list; nothing more to do.
			default:
				// Free list full, just carry on.
			}
		default:
			fmt.Println("No Job")
			finish <- 1
			time.Sleep(5 * time.Millisecond)
		}
	}
}

func load(b *Buffer, job int) {
	b.Job = job
	fmt.Println("Load Buffer :", b.Id, job)
}

func process(b *Buffer) {
	fmt.Println("Process Buffer :", b.Id, b.Job)
	time.Sleep(10 * time.Millisecond)
}

func main() {
	finished := make(chan int)
	go server(finished)
	client()
	<-finished
	fmt.Println("Finished")
}
