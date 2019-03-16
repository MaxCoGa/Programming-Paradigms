/**
* The findOptimalTransport.go program implements the transportation problem
*  that find the best path between Demand and Supply using the concurrency.
*  We are using a description and an inital solution of the problem as
*  to be use for the stepping stone method to find the optimal solution.
*
* @author  Maxime Côté-Gagné
* @id 8851539
 */

package main

import (
	"bufio"
	"container/list"
	"fmt"
	"log"
	"math"
	"os"
	"strconv"
	"sync"
)

/*
type Usine struct { //demand
	capacity int
}

type Entrepot struct { //supply
	capacity int
}
*/

/*
 *Struct of a transport(e.g. a truck) containing
 *is capacity for each cell and the costs of this cell
 * and the row and colunm use for the given matrix of the problem
 * matrix
 */
type transport struct {
	//the use of float64 is needed for the degenerate case
	capacity float64
	costCell float64
	row      int
	colunm   int
}

/*
 *Struct of the transporttation problem containing
 *a list of supply, a list of demand, an array of costs
 *and an array named matrix of transport.
 */
type problem struct {
	supply []int
	demand []int
	costs  [][]float64
	matrix [][]transport
}

/*
 *Use to check what the error is with the log function of go
 */
func check(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

/*
 * Linkedlist method of matrix Transport creating a list with a matrix
 */
func (p *problem) toList() *list.List {
	l := list.New()
	for _, m := range p.matrix {
		for _, t := range m {
			if t != routes {
				l.PushBack(t)
			}
		}
	}
	return l

}

//init the problem with the given description
/*
 * Initialize our costs matrix and our Tranportation matrix from
 * the file given by the user.
 *
 */
func read(filename string) *problem {
	file, err := os.Open(filename)
	check(err)
	defer file.Close()
	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanWords)
	scanner.Scan()
	numSupply, err := strconv.Atoi(scanner.Text())

	check(err)
	scanner.Scan()
	numDemand, err := strconv.Atoi(scanner.Text())

	check(err)

	//skip second line
	for i := 0; i < numDemand+1; i++ {
		scanner.Scan()
	}

	lineLenght := numDemand + 2
	supply := make([]int, numSupply)
	demand := make([]int, numDemand)

	//Add the supply
	for i := 0; i < numSupply; i++ {
		for j := 0; j < lineLenght; j++ {
			if j == lineLenght-1 {
				scanner.Scan()
				supply[i], err = strconv.Atoi(scanner.Text())

				check(err)
			} else {

				scanner.Scan()
			}
		}
	}
	scanner.Scan()

	//add the demand
	for i := 0; i < numDemand; i++ {
		scanner.Scan()
		demand[i], err = strconv.Atoi(scanner.Text())
		check(err)
	}

	//INIT EACH CELL with their costs
	file.Seek(0, 0) //reset the poiter of the file to the begining
	lineToSkip := numDemand + 3
	for i := 0; i < lineToSkip; i++ {
		scanner.Scan()
	}

	scanner.Scan()

	costs := make([][]float64, len(supply))
	for i := 0; i < len(supply); i++ {
		costs[i] = make([]float64, len(demand))
	}
	matrix := make([][]transport, len(supply))
	for i := 0; i < len(supply); i++ {
		matrix[i] = make([]transport, len(demand))
	}

	for i := 0; i < numSupply; i++ {
		scanner.Scan() //skip first int (index)
		for j := 0; j < numDemand; j++ {
			scanner.Scan()
			costs[i][j], err = strconv.ParseFloat(scanner.Text(), 64)
			check(err)
		}
		scanner.Scan() //skip last int(supply)
	}
	return &problem{supply, demand, costs, matrix}
}

//WRITE
/*
 * Save the different solutions of the transportation problem to the
 * solution.txt created Can save the solution of the problem using
 * the stepping stones methods.
 */
func (p *problem) write() {
	f, err := os.Create("solution.txt") //CREATE THE SOLUTION.TXT
	check(err)
	defer f.Close()

	//WRITE SUPPLY DEMAND
	f.WriteString(fmt.Sprint(len(p.supply)))
	f.WriteString(" ")
	f.WriteString(fmt.Sprint(len(p.demand)))
	f.WriteString("\n")

	//WRITE A B C ... SUPPLY
	var ch = 'A'
	for i := 0; i < len(p.supply); i++ {
		f.WriteString(string(ch))
		f.WriteString(" ")
		ch++
	}
	f.WriteString("Supply")
	f.WriteString("\n")

	totalCosts := 0.0
	//WRITE ROW
	for r := 0; r < len(p.supply); r++ {
		f.WriteString(fmt.Sprint(r + 1))
		f.WriteString(" ")
		for c := 0; c < len(p.demand); c++ {
			f.WriteString(fmt.Sprintf("%d", int(p.matrix[r][c].capacity)))
			totalCosts += p.matrix[r][c].capacity * p.matrix[r][c].costCell
			f.WriteString(" ")
		}
		f.WriteString(fmt.Sprint(p.supply[r]))
		f.WriteString("\n")
	}

	//WRITE DEMAND
	f.WriteString("Demand" + " ")
	for i := 0; i < len(p.demand); i++ {
		f.WriteString(fmt.Sprint(p.demand[i]))
		f.WriteString(" ")
	}
	f.WriteString(fmt.Sprint(totalCosts))

}

/*
 *Add the initial solution to the problem
 */
func (p *problem) ajusted(filename string) {
	file, err := os.Open(filename)
	check(err)
	defer file.Close()
	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanWords)

	lineToSkip := len(p.demand) + 3 //line to skip before
	for i := 0; i < lineToSkip; i++ {
		scanner.Scan()
	}
	//set the new matrix
	for r := 0; r < len(p.supply); r++ {
		scanner.Scan()
		for c := 0; c < len(p.demand); c++ {
			scanner.Scan()
			cap, err := strconv.ParseFloat(scanner.Text(), 64)
			//WARNING we only need to take the cell where the cap
			if cap != 0 {
				p.matrix[r][c] = transport{cap, p.costs[r][c], r, c}
				check(err)
			}
		}
		scanner.Scan() //skip last int(supply)
	}

}

var routes = transport{}
var wg = sync.WaitGroup{}

/*STEPPINGSTONES*/
//PAS JAPONAIS
/*
 * Using the solution from the minimal cell costs method
 * The stepping stones method search to find a path where
 * it have less costs while changing by -1(initial cell to change)
 * and +1 in a circle.
 */
var numRec = 0

func (p *problem) steppingStone() {
	p.degenerate()
	var path []transport

	for r := 0; r < len(p.supply); r++ {
		for c := 0; c < len(p.demand); c++ {
			if p.matrix[r][c] != routes {
				continue
			}
			zero := transport{0, p.costs[r][c], r, c}
			//We need to find every cell with no capacity
			path = p.findEmptyCell(zero)
			p.marginalCosts(path)
			//wg.Wait()
		}
	}
}

/*
 *Permet d'obtenir le coût marginal d'une route
 *en partance d'une cellule vide.
 */
func (p *problem) marginalCosts(path []transport) {
	defer wg.Done()
	maxReduction := 0.0
	var pas []transport
	change := routes
	reduction := 0.0
	lowCap := float64(math.MaxInt32) //doesnt work with int
	next := routes
	plus := true
	for _, t := range path {
		if plus {
			reduction += t.costCell
		} else {
			reduction -= t.costCell
			if t.capacity < lowCap {
				next = t
				lowCap = t.capacity
			}
		}
		plus = !plus
	}
	if reduction < maxReduction {
		pas = path
		change = next
		maxReduction = reduction
	}

	if pas != nil {
		q := change.capacity
		plus := true
		for _, t := range pas {
			if plus {
				t.capacity += q
			} else {
				t.capacity -= q
			}
			if t.capacity == 0 {
				p.matrix[t.row][t.colunm] = routes
			} else {
				p.matrix[t.row][t.colunm] = t
			}
			plus = !plus
		}
		numRec++ //use to debug the waitgroup
		p.steppingStone()
	}
}

//EMPTY
/*
 * Use to find where the path are closed(no neighboring cell)
 * vertically or horizontally.
 *
 */
func (p *problem) findEmptyCell(t transport) []transport {
	chemin := p.toList()

	chemin.PushFront(t)

	//remove elems without vertical or horizontal neighbors
	var next *list.Element
	for {
		remove := 0
		for elem := chemin.Front(); elem != nil; elem = next {
			next = elem.Next()
			num := p.findNearest(elem.Value.(transport), chemin)
			if num[0] == routes || num[1] == routes {
				chemin.Remove(elem)
				remove++
			}
		}
		if remove == 0 {
			break
		}
	}

	//reorder remaining elems
	stones := make([]transport, chemin.Len())
	prev := t
	for i := 0; i < len(stones); i++ {
		stones[i] = prev
		prev = p.findNearest(prev, chemin)[i%2]
	}
	return stones
}

/*
 * Find all nearest cell to the slected cell in a given path
 */
func (p *problem) findNearest(prev transport, chemin *list.List) [2]transport {
	var num [2]transport
	for element := chemin.Front(); element != nil; element = element.Next() {
		neighbor := element.Value.(transport)

		if prev != neighbor {
			if neighbor.row == prev.row && num[0] == routes {
				num[0] = neighbor
			} else if neighbor.colunm == prev.colunm && num[1] == routes {
				num[1] = neighbor
			}
			if num[0] != routes && num[1] != routes {
				break
			}
		}
	}
	return num
}

//FIX
/*
 * Test combinations of inputs that may be rare, but still possible.
 * Will expose obvious issues.
 */
func (p *problem) degenerate() {
	eps := math.SmallestNonzeroFloat64 //Need float

	if len(p.supply)+len(p.demand)-1 != p.toList().Len() {

		for r := 0; r < len(p.supply); r++ {
			for c := 0; c < len(p.demand); c++ {
				if p.matrix[r][c] == routes {
					tmp := transport{eps, p.costs[r][c], r, c}
					if len(p.findEmptyCell(tmp)) == 0 {
						p.matrix[r][c] = tmp
						return
					}
				}
			}
		}
	}
}

/*PRINT*/
/*
 * Print the result of the matrix after a transformation using minimal cost and stepping stones methods
 */
func (p *problem) printResult() {
	totalCosts := 0.0
	for r := 0; r < len(p.supply); r++ {
		for c := 0; c < len(p.demand); c++ {
			fmt.Printf(" %3d ", int(p.matrix[r][c].capacity))
			totalCosts += p.matrix[r][c].capacity * p.matrix[r][c].costCell
		}
		fmt.Println()
	}
	fmt.Println("Total:", totalCosts)
}

/*
 * Print the matrix with the cost in each cell
 */
func (p *problem) prinstCosts() {
	fmt.Println("Initial Cost per Cell:")
	for r := 0; r < len(p.supply); r++ {
		for c := 0; c < len(p.demand); c++ {
			fmt.Printf(" %3d ", int(p.costs[r][c]))
		}
		fmt.Println()
	}
	fmt.Println()
}

/*
 * Start of the findOptimalTranport program IN GO
 *
 * input file name use to find a solution to the
 * transportation problem from a description given by the user
 * and the initial solution of the given description
 */
func main() {
	//input := "3x4.txt"
	//input2 := "i3x4.txt"
	fmt.Print("Enter file name for the description: ")
	var input string
	fmt.Scanln(&input)
	p := read(input)
	p.prinstCosts()

	fmt.Print("Enter file name for the initial solution: ")
	fmt.Scanln(&input)
	p.ajusted(input)

	fmt.Println("Initial solution")
	p.printResult()

	fmt.Println("Optimal Solution")
	//use of concurrency
	done := make(chan bool)
	go func() {
		//the delta need to be a large number
		wg.Add(int(math.Pow(float64(len(p.supply)), float64(len(p.demand)))))
		p.steppingStone()
		//wg.Wait()
		done <- true
	}()
	wg.Wait()
	<-done

	p.write()
	p.printResult()
}
