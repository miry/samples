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
	assert.Equal(t, []byte("."), subject.Fields[0])
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
	assert.Equal(t, []byte("................."), subject.Fields[0])
	assert.Equal(t, []byte("................."), subject.Fields[1])
	assert.Equal(t, []byte("...##...###..#..."), subject.Fields[2])
	assert.Equal(t, []byte(".####..#####.###."), subject.Fields[3])
	assert.Equal(t, []byte("#################"), subject.Fields[4])
}

func TestGravityEmptyField(t *testing.T) {
	subject := &gravity_tumbler.Input{}
	assert.Equal(t, [][]byte{}, subject.Gravity().Fields)
}

func TestGravityPunktField(t *testing.T) {

	tables := []map[string][][]byte{
		map[string][][]byte{
			"in": [][]byte{
				[]byte("."),
				[]byte("."),
			},
			"out": [][]byte{
				[]byte("."),
				[]byte("."),
			},
		},

		map[string][][]byte{
			"in": [][]byte{
				[]byte(".."),
			},
			"out": [][]byte{
				[]byte(".."),
			},
		},

		map[string][][]byte{
			"in": [][]byte{
				[]byte(".#"),
			},
			"out": [][]byte{
				[]byte(".#"),
			},
		},

		map[string][][]byte{
			"in": [][]byte{
				[]byte("##"),
			},
			"out": [][]byte{
				[]byte("##"),
			},
		},

		map[string][][]byte{
			"in": [][]byte{
				[]byte("#."),
			},
			"out": [][]byte{
				[]byte("#."),
			},
		},

		map[string][][]byte{
			"in": [][]byte{
				[]byte("."),
				[]byte("#"),
			},
			"out": [][]byte{
				[]byte("."),
				[]byte("#"),
			},
		},

		map[string][][]byte{
			"in": [][]byte{
				[]byte("#"),
				[]byte("."),
			},
			"out": [][]byte{
				[]byte("."),
				[]byte("#"),
			},
		},

		map[string][][]byte{
			"in": [][]byte{
				[]byte(".."),
				[]byte(".."),
			},
			"out": [][]byte{
				[]byte(".."),
				[]byte(".."),
			},
		},

		map[string][][]byte{
			"in": [][]byte{
				[]byte(".."),
				[]byte("#."),
			},
			"out": [][]byte{
				[]byte(".."),
				[]byte("#."),
			},
		},
	}

	subject := &gravity_tumbler.Input{
		Height: 1,
	}

	for _, row := range tables {
		subject.Fields = row["in"]
		subject.Height = len(row["in"])
		subject.Width = len(row["in"][0])
		assert.Equal(t, row["out"], subject.Gravity().Fields)
	}
}

func TestRotateCase1(t *testing.T) {
	tmpfile := mockStdin("input1")
	defer tmpfile.Close()

	subject, err := gravity_tumbler.NewInputFromReader(tmpfile)
	assert.Nil(t, err)
	actual := subject.Rotate()
	assert.Equal(t, []byte("....#"), actual.Fields[0])
	assert.Equal(t, []byte("...##"), actual.Fields[15])
	assert.Equal(t, []byte("....#"), actual.Fields[16])
}

func TestRunCase1(t *testing.T) {
	tmpfile := mockStdin("input1")
	defer tmpfile.Close()

	subject, err := gravity_tumbler.NewInputFromReader(tmpfile)
	assert.Nil(t, err)
	assert.NotNil(t, subject)
	actual := subject.Run()
	assert.Len(t, actual.Fields, 17)
	assert.Equal(t, []byte("....#"), actual.Fields[0])
	assert.Equal(t, []byte("...##"), actual.Fields[5])
	assert.Equal(t, []byte("..###"), actual.Fields[15])
	assert.Equal(t, []byte("..###"), actual.Fields[16])
}

func TestRunCase2(t *testing.T) {
	tmpfile := mockStdin("input2")
	defer tmpfile.Close()

	subject, err := gravity_tumbler.NewInputFromReader(tmpfile)
	assert.Nil(t, err)
	assert.NotNil(t, subject)
	actual := subject.Run()
	assert.NotNil(t, actual)
	assert.Len(t, actual.Fields, 5)
	assert.Equal(t, []byte("................."), actual.Fields[0])
	assert.Equal(t, []byte("................."), actual.Fields[1])
	assert.Equal(t, []byte("...........######"), actual.Fields[2])
	assert.Equal(t, []byte(".....############"), actual.Fields[3])
	assert.Equal(t, []byte("#################"), actual.Fields[4])
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
