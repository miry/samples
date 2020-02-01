package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestAvailableMoves(t *testing.T) {
	subject := Coord{x: 3, y: 8}

	board := initBoard(9, 9)
	walls := initWalls(9, 9)

	walls[4][7][0] = VERTICAL
	walls[4][8][0] = VERTICAL
	walls[2][8][1] = HORIZONTAL
	walls[3][8][1] = HORIZONTAL

	printBoard(board, walls)

	actual := subject.availableMoves(walls)
	for s, v := range map[string]bool{"LEFT": true, "RIGHT": false, "UP": false, "DOWN": false} {
		_, ok := actual[s]
		assert.Equal(t, v, ok)
	}
}

func TestAvailableMovesCase2(t *testing.T) {
	subject := Coord{x: 6, y: 0}

	board := initBoard(9, 9)
	walls := initWalls(9, 9)

	walls[7][0][0] = VERTICAL
	walls[7][1][0] = VERTICAL
	walls[7][5][1] = HORIZONTAL
	walls[8][5][1] = HORIZONTAL

	printBoard(board, walls)

	actual := subject.availableMoves(walls)
	for s, v := range map[string]bool{"LEFT": true, "RIGHT": false, "UP": false, "DOWN": true} {
		_, ok := actual[s]
		assert.Equal(t, v, ok)
	}
}

func TestSuggestMoveBegin(t *testing.T) {
	subject := Coord{x: 0, y: 0}

	board := initBoard(9, 9)
	walls := initWalls(9, 9)

	printBoard(board, walls)

	actual := subject.suggestMove(walls, 9, 9)
	assert.Equal(t, "RIGHT", actual)
}

func TestSuggestMoveMiddle(t *testing.T) {
	/*
	Coord: id = 0, x = 6; y = 3; wallsLeft = 3
	Coord: id = 1, x = 3; y = 8; wallsLeft = 5
	Coord: id = 2, x = 4; y = 6; wallsLeft = 5
	Walls count on the board: 5
	Wall: id = 0, x = 2; y = 7; wallsLeft = V
	Wall: id = 1, x = 5; y = 7; wallsLeft = H
	Wall: id = 2, x = 2; y = 8; wallsLeft = H
	Wall: id = 3, x = 1; y = 7; wallsLeft = H
	Wall: id = 4, x = 3; y = 7; wallsLeft = H

	9 9 3 1
	6 3 3
	3 8 5
	4 6 5
	5
	2 7 V
	5 7 H
	2 8 H
	1 7 H
	3 7 H
	*/
	subject := Coord{id: 1, x: 3, y: 8}

	board := initBoard(9, 9)
	walls := initWalls(9, 9)

	walls[2][7][0] = VERTICAL
	walls[2][8][0] = VERTICAL
	walls[5][7][1] = HORIZONTAL
	walls[6][7][1] = HORIZONTAL
	walls[2][8][1] = HORIZONTAL
	walls[3][8][1] = HORIZONTAL
	walls[1][7][1] = HORIZONTAL
	walls[2][7][1] = HORIZONTAL
	walls[3][7][1] = HORIZONTAL
	walls[4][7][1] = HORIZONTAL

	printBoard(board, walls)

	actual := subject.suggestMove(walls, 9, 9)
	assert.Equal(t, "RIGHT", actual)
}
