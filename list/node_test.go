package list_test

import (
	"testing"

	"github.com/miry/gosample/list"
	"github.com/stretchr/testify/assert"
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

func TestNodeInsert(t *testing.T) {
	second := &list.Node{Value: "Second Node"}
	first := &list.Node{Value: "First Node", Next: second}

	newSecond := &list.Node{Value: "New Second"}
	first.Insert(1, newSecond)

	assert.Equal(t, []string{"First Node", "New Second", "Second Node"}, first.Values())
}
