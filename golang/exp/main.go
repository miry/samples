package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"os"
)

var file = flag.String("f", "", "file path for input data")

func main() {
	flag.Parse()

	if file != nil {
		err := process(*file)
		if err != nil {
			log.Fatalf("could not process file '%s': %v", *file, err)
		}
	} else {
		log.Fatal("no input file")
	}

	return
}

func process(filename string) error {
	fmt.Printf("file: %s\n", filename)

	if filename == "" {
		return fmt.Errorf("no input file")
	}

	file, err := os.Open(filename)
	if err != nil {
		return err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		fmt.Println(scanner.Text())
	}

	return nil
}
