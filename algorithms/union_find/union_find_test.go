package union_find_test

import (
	"testing"

	"github.com/miry/samples/algorithms/union_find"
	"github.com/stretchr/testify/assert"
)

func TestEmpty(t *testing.T) {
	subject := union_find.NewUF(9)
	assert.NotNil(t, subject)
}

func TestUnion(t *testing.T) {
	subject := union_find.NewUF(9)
	subject.Union(1, 9)
	assert.True(t, subject.Connected(1, 9))
}

func TestConnectedZeroLevel(t *testing.T) {
	subject := union_find.NewUF(9)
	assert.True(t, subject.Connected(1, 1))
	assert.False(t, subject.Connected(1, 2))
}

func TestConnectedFirstLevel(t *testing.T) {
	subject := union_find.NewUF(9)
	subject.Union(1, 2)
	assert.True(t, subject.Connected(1, 1))
	assert.True(t, subject.Connected(1, 2))
}

func TestConnectedSecondLevel(t *testing.T) {
	subject := union_find.NewUF(9)
	subject.Union(1, 2)
	subject.Union(2, 3)
	assert.True(t, subject.Connected(1, 3))
}

func TestMultiUnion(t *testing.T) {
	subject := union_find.NewUF(9)
	subject.Union(1, 2)
	subject.Union(1, 3)
	assert.True(t, subject.Connected(2, 3))
}

func TestCycleUnion(t *testing.T) {
	subject := union_find.NewUF(9)
	subject.Union(1, 2)
	subject.Union(2, 3)
	subject.Union(3, 1)
	assert.True(t, subject.Connected(2, 3))
	assert.True(t, subject.Connected(1, 3))
	assert.True(t, subject.Connected(1, 2))
}
