package list_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/miry/samples/algorithms/list"
)

func TestNodeValue(t *testing.T) {
	subject := list.Node{}
	assert.Equal(t, "", subject.Value, "should be empty")
}
func TestNodePrint(t *testing.T) {
	subject := list.Node{}
	subject.Print()
}

func TestNodeValues(t *testing.T) {
	first := &list.Node{Value: "First Node"}
	second := &list.Node{Value: "Second Node"}
	first.Next = second
	assert.Equal(t, []string{"First Node", "Second Node"}, first.Values())
}

func TestNodeAppend(t *testing.T) {
	first := &list.Node{Value: "First Node"}
	second := &list.Node{Value: "Second Node"}
	first.Append(second)
	assert.Equal(t, []string{"First Node", "Second Node"}, first.Values())
}

func TestNodeGetSuccess(t *testing.T) {
	second := &list.Node{Value: "Second Node"}
	first := &list.Node{Value: "First Node", Next: second}

	actual, _ := first.Get(1)
	assert.Equal(t, "Second Node", actual.Value)
}

func TestNodeGetFailed(t *testing.T) {
	second := &list.Node{Value: "Second Node"}
	first := &list.Node{Value: "First Node", Next: second}

	actual, err := first.Get(2)
	assert.Nil(t, actual)
	assert.Equal(t, "Out of index", err.Error())
}
func TestNodeGetNegativeFailed(t *testing.T) {
	second := &list.Node{Value: "Second Node"}
	first := &list.Node{Value: "First Node", Next: second}

	actual, err := first.Get(-2)
	assert.Nil(t, actual)
	assert.Equal(t, "Out of index", err.Error())
}

func TestNodeInsert(t *testing.T) {
	second := &list.Node{Value: "Second Node"}
	first := &list.Node{Value: "First Node", Next: second}

	newSecond := &list.Node{Value: "New Second"}
	first.Insert(1, newSecond)

	assert.Equal(t, []string{"First Node", "New Second", "Second Node"}, first.Values())
}

func TestNodeInsertFirst(t *testing.T) {
	second := &list.Node{Value: "Second Node"}
	first := &list.Node{Value: "First Node", Next: second}

	newHead := &list.Node{Value: "New First"}
	actual, _ := first.Insert(0, newHead)

	assert.Equal(t, []string{"New First", "First Node", "Second Node"}, actual.Values())
}

func TestNodeInsertFailed(t *testing.T) {
	second := &list.Node{Value: "Second Node"}
	first := &list.Node{Value: "First Node", Next: second}

	oops := &list.Node{Value: "Should not be in the list"}
	actual, err := first.Insert(6, oops)
	assert.NotNil(t, actual)
	assert.Equal(t, "Out of index", err.Error())
	assert.NotContains(t, actual.Values(), "Should not be in the list")
}

func TestNodeDeleteSuccess(t *testing.T) {
	second := &list.Node{Value: "Second Node"}
	first := &list.Node{Value: "First Node", Next: second}

	actual, err := first.Delete(1)
	assert.Nil(t, err)
	assert.NotContains(t, actual.Values(), "Second Node")
}

func TestNodeDeleteHead(t *testing.T) {
	second := &list.Node{Value: "Second Node"}
	first := &list.Node{Value: "First Node", Next: second}

	actual, err := first.Delete(0)
	assert.Nil(t, err)
	assert.NotContains(t, actual.Values(), "First Node")
}

func TestNodeDeleteError(t *testing.T) {
	second := &list.Node{Value: "Second Node"}
	first := &list.Node{Value: "First Node", Next: second}

	actual, err := first.Delete(5)
	assert.NotNil(t, actual)
	assert.Equal(t, "Out of index", err.Error())
}
