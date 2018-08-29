package gravity_tumbler_test

import (
	"io/ioutil"
	"log"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/miry/samples/codinggame/gravity_tumbler"
)

func TestNewInputFromReader(t *testing.T) {
	tmpfile := mockStdin("")
	defer tmpfile.Close()

	subject, err := gravity_tumbler.NewInputFromReader(tmpfile)
	assert.Nil(t, err)
	assert.NotNil(t, subject)
	assert.Equal(t, 1, subject.Width)
	assert.Equal(t, 1, subject.Height)
	assert.Equal(t, 1, subject.Count)
	assert.Equal(t, ".", subject.Fields[0])
}

func TestNewInputFromReaderCase1(t *testing.T) {
	tmpfile := mockStdin("input1")
	defer tmpfile.Close()

	subject, err := gravity_tumbler.NewInputFromReader(tmpfile)
	assert.Nil(t, err)
	assert.NotNil(t, subject)
	assert.Equal(t, 17, subject.Width)
	assert.Equal(t, 5, subject.Height)
	assert.Equal(t, 1, subject.Count)
	assert.Equal(t, ".................", subject.Fields[0])
}

func mockStdin(fixture string) *os.File {
	if fixture == "" {
		return createTmpFile()
	}

	filename := "fixtures/" + fixture + ".txt"
	file, err := os.Open(filename)
	if err != nil {
		log.Fatalf("could not open file %s: %v", filename, err)
	}
	return file
}

func createTmpFile() *os.File {
	content := []byte("1 1\n1\n.")
	tmpfile, err := ioutil.TempFile("", "example")
	if err != nil {
		log.Fatal(err)
	}
	defer os.Remove(tmpfile.Name()) // clean up

	if _, err := tmpfile.Write(content); err != nil {
		log.Fatal(err)
	}

	if _, err := tmpfile.Seek(0, 0); err != nil {
		log.Fatal(err)
	}

	return tmpfile
}
