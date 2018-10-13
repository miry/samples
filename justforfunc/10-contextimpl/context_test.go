package contextimpl

import (
	"fmt"
	"testing"
	"time"
)

func TestBackgroundNotTODO(t *testing.T) {
	todo := fmt.Sprint(TODO())
	bg := fmt.Sprint(Background())

	if todo == bg {
		t.Errorf("TODO and background are equal: %q vs %q", todo, bg)
	}
}

func TestWithCancel(t *testing.T) {
	ctx, cancel := WithCancel(Background())
	if err := ctx.Err(); err != nil {
		t.Errorf("error should be nil first, got %v", err)
	}
	cancel()
	<-ctx.Done()
}

func TestWithCancelConcurent(t *testing.T) {
	ctx, cancel := WithCancel(Background())

	time.AfterFunc(1*time.Second, cancel)

	if err := ctx.Err(); err != nil {
		t.Errorf("error should be nil first, got %v", err)
	}

	<-ctx.Done()

	if err := ctx.Err(); err != Canceled {
		t.Errorf("error should be canceled now, got %v", err)
	}
}
