package queue_test

import (
	"strings"
	"testing"

	"github.com/miry/samples/algorithms/queue"

	"github.com/stretchr/testify/assert"
)

func TestEmpty(t *testing.T) {
	subject := queue.Queue{}
	assert.True(t, subject.Empty(), "should be empty")
}

func TestNotEmpty(t *testing.T) {
	subject := queue.Queue{}
	subject.Enqueue("some element")
	assert.False(t, subject.Empty(), "should not be empty")
}

func TestPopLastElement(t *testing.T) {
	subject := queue.Queue{}
	subject.Enqueue("last")
	actual := subject.Dequeue()
	assert.Equal(t, "last", actual)
}

func TestPopIfEmpty(t *testing.T) {
	subject := queue.Queue{}
	actual := subject.Dequeue()
	assert.Equal(t, "", actual)
}

func TestMixCases(t *testing.T) {
	actual := make([]string, 3)
	subject := queue.Queue{}

	subject.Enqueue("first")
	subject.Enqueue("second")
	actual[0] = subject.Dequeue()
	subject.Enqueue("third")
	actual[1] = subject.Dequeue()
	actual[2] = subject.Dequeue()

	assert.Equal(t, "first second third", strings.Join(actual, " "))
}
