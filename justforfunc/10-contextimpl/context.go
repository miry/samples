package contextimpl

import "time"

type Context interface {
	Deadline() (deadline time.Time, ok bool)
	Done() <-chan struct{}
	Err() error
	Value(key interface{}) interface{}
}

type emptyCtx int

func (ctx emptyCtx) Deadline() (deadline time.Time, ok bool) { return }
func (ctx emptyCtx) Done() <-chan struct{}                   { return nil }
func (ctx emptyCtx) Err() error                              { return nil }
func (ctx emptyCtx) Value(key interface{}) interface{}       { return nil }

func Background() Context {
	return new(emptyCtx)
}

func TODO() Context {
	return new(emptyCtx)
}
