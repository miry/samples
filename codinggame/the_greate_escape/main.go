package main

import (
	"fmt"
	"os"
	"math/rand"
)

const (
	VERTICAL   = "V"
	HORIZONTAL = "H"
)

type Coord struct {
	id, x, y, wallsLeft int
	parent *Coord
}

func printBoard(board [][]int, walls map[int]map[int][]string) {
	fmt.Fprintln(os.Stderr, "Board: ")
	for y, row := range board {

		for x, _ := range row {
			if walls[x][y][1] == HORIZONTAL {
				fmt.Fprint(os.Stderr, "----")
			} else {
				fmt.Fprint(os.Stderr, "    ")
			}
		}

		fmt.Fprintln(os.Stderr, "")

		for x, cell := range row {
			if walls[x][y][0] == VERTICAL {
				fmt.Fprint(os.Stderr, "|")
			} else {
				fmt.Fprint(os.Stderr, " ")
			}
			fmt.Fprintf(os.Stderr, "%2d ", cell)
		}

		fmt.Fprintln(os.Stderr, "")
	}
	fmt.Fprintln(os.Stderr, "")
}

func initBoard(h, w int) [][]int {
	result := make([][]int, h, h)
	for i, _ := range result {
		result[i] = make([]int, w, w)
		for j, _ := range result[i] {
			result[i][j] = -1
		}
	}

	return result
}

func initWalls(h, w int) (result map[int]map[int][]string) {
	result = map[int]map[int][]string{}
	for i := 0; i < h; i++ {
		result[i] = map[int][]string{}
		for j := 0; j < w; j++ {
			result[i][j] = make([]string, 2, 2)
		}
	}
	return
}

func (this Coord) availableMoves(walls map[int]map[int][]string) map[string]Coord {
	result := map[string]Coord{}

	if _, ok := walls[this.x + 1]; ok && walls[this.x+1][this.y][0] != VERTICAL {
		result["RIGHT"] = Coord{id: this.id, x: this.x+1, y: this.y, parent: &this}
	}

	if _, ok := walls[this.x - 1]; ok && walls[this.x][this.y][0] != VERTICAL {
		result["LEFT"] = Coord{id: this.id, x: this.x-1, y: this.y, parent: &this}
	}

	if _, ok := walls[this.x][this.y + 1]; ok && walls[this.x][this.y+1][1] != HORIZONTAL {
		result["DOWN"] = Coord{id: this.id, x: this.x, y: this.y+1, parent: &this}
	}

	if _, ok := walls[this.x][this.y - 1]; ok && walls[this.x][this.y][1] != HORIZONTAL {
		result["UP"] = Coord{id: this.id, x: this.x, y: this.y-1, parent: &this}
	}

	return result
}

func (this Coord) suggestMove(walls map[int]map[int][]string, w int, h int) string {
	var newCoords, prevCoords []Coord
	var found *Coord
	route := map[Coord]string{}
	newCoords = []Coord{this}

	for found == nil {
		prevCoords = newCoords
		newCoords = []Coord{}

		for _, coord := range prevCoords {
			for step, coord := range coord.availableMoves(walls) {
				if _, ok := route[coord]; ok {
					continue
				}
				route[coord] = step
				if coord.isEnd() {
					found = &coord
					break
				}


				newCoords = append(newCoords, coord)
			}
		}
	}

	if found == nil {
		return ""
	}

	result := ""

	for *found != this {
		result = route[*found]
		found = found.parent
	}

	return result
}

func (this Coord) isEnd() bool {
	switch this.id {
	case 0:
		return this.x == 8
	case 1:
		return this.x == 0
	case 2:
		return this.y == 8
	}

	return false
}

func main() {
	// w: width of the board
	// h: height of the board
	// playerCount: number of players (2 or 3)
	// myId: id of my player (0 = 1st player, 1 = 2nd player, ...)
	var w, h, playerCount, myId, wallCount, wallX, wallY, moves int
	var wallOrientation string

	fmt.Scan(&w, &h, &playerCount, &myId)
	fmt.Fprintf(os.Stderr, "width = %v; height = %v; playerCount = %v; myId = %v\n", w, h, playerCount, myId)

	board := initBoard(h, w)
	walls := initWalls(h, w)
	coord := map[int]Coord{}
	strategies := map[int][]string{
		0: []string{"RIGHT", "UP", "DOWN", "LEFT"},
		1: []string{"LEFT", "UP", "DOWN", "RIGHT"},
		2: []string{"DOWN", "RIGHT", "LEFT", "UP"},
	}
	strategy := strategies[myId]

	for {
		moves++
		for i := 0; i < playerCount; i++ {
			// x: x-coordinate of the player
			// y: y-coordinate of the player
			// wallsLeft: number of walls available for the player
			var x, y, wallsLeft int
			fmt.Scan(&x, &y, &wallsLeft)
			//			fmt.Fprintf(os.Stderr, "Coord: id = %d, x = %v; y = %v; wallsLeft = %v\n", i, x, y, wallsLeft)
			if x >= 0 && x < w && y < h && y >= 0 {
				board[y][x] = i
			}
			coord[i] = Coord{id: i, x: x, y: y, wallsLeft: wallsLeft}
		}

		fmt.Scan(&wallCount)

		for i := 0; i < wallCount; i++ {
			// wallX: x-coordinate of the wall
			// wallY: y-coordinate of the wall
			// wallOrientation: wall orientation ('H' or 'V')
			fmt.Scan(&wallX, &wallY, &wallOrientation)
			//			fmt.Fprintf(os.Stderr, "Wall: id = %d, x = %v; y = %v; wallsLeft = %v\n", i, wallX, wallY, wallOrientation)

			if wallOrientation == VERTICAL {
				walls[wallX][wallY][0] = VERTICAL
				walls[wallX][wallY+1][0] = VERTICAL
			} else {
				walls[wallX][wallY][1] = HORIZONTAL
				walls[wallX+1][wallY][1] = HORIZONTAL
			}

		}

		//printBoard(board, walls)

		move := coord[myId].suggestMove(walls, w, h)
		if move != "" {
			r := rand.Intn(100)
			if coord[myId].wallsLeft > 0 && moves > 2 && r < (50 + myId*15) {

				n := rand.Intn(playerCount)

				if n != myId {
					wX := coord[n].x
					wY := coord[n].y

					if (n == 0) && (wX >= 0 && wX < w) && (wY+1 < h) && (wX+1 < w) && walls[wX+1][wY][0] != VERTICAL && walls[wX+1][wY+1][0] != VERTICAL && (walls[wX+1][wY+1][1] != HORIZONTAL) {
						fmt.Printf("%d %d %s Ping Pong\n", wX+1, wY, VERTICAL)
						continue
					}

					if (n == 1) && (wX >= 0 && wX < w) && (wY+1 < h) && walls[wX][wY][0] != VERTICAL && walls[wX][wY+1][0] != VERTICAL && (walls[wX][wY+1][1] != HORIZONTAL) {
						fmt.Printf("%d %d %s Next Time Baby\n", wX, wY, VERTICAL)
						continue
					}

					if (n == 2) && (wX >= 0 && wX < w) && (wY+1 < h) && (wX+1 < w && walls[wX+1][wY][1] != HORIZONTAL) &&
						walls[wX][wY+1][1] != HORIZONTAL &&
						walls[wX+1][wY][1] != HORIZONTAL && walls[wX+1][wY+1][1] != HORIZONTAL && walls[wX+1][wY+1][1] != HORIZONTAL &&
						walls[wX][wY+1][0] != VERTICAL && walls[wX+1][wY+1][0] != VERTICAL {
						fmt.Printf("%d %d %s I Kill You\n", wX, wY+1, HORIZONTAL)
						continue
					}
				}

			}

			fmt.Println(move) // action: LEFT, RIGHT, UP, DOWN or "putX putY putOrientation" to place a wall
			continue
		}

		moves := coord[myId].availableMoves(walls)

		for _, step := range strategy {
			if _, ok := moves[step]; ok {
				fmt.Println(step) // action: LEFT, RIGHT, UP, DOWN or "putX putY putOrientation" to place a wall
				break
			}
		}
	}
}
