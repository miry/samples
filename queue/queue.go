package queue

type Queue struct {
	size  int
	store []string
}

func (q *Queue) Enqueue(element string) {
	q.size++
	q.store = append(q.store, element)
}

func (q *Queue) Dequeue() (result string) {
	if q.size > 0 {
		result, q.store = q.store[0], q.store[1:]
		q.size--
	}

	return
}

func (q *Queue) Empty() bool {
	return q.size == 0
}
