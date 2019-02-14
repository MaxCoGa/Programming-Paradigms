/**Question 3. Traitement concurrent - Maxime Côté-Gagné (8851539)**/

package main

import (
	"fmt"
	"math"
	"math/rand"
	"sync"
)

type Point struct {
	x float64
	y float64
}

type Triangle struct {
	A Point
	B Point
	C Point
}

//Test function to generate an array
func triangles10000() [10000]Triangle {

	var tableau [10000]Triangle
	rand.Seed(2120)

	for i := 0; i < 10000; i++ {
		tableau[i].A = Point{rand.Float64() * 100., rand.Float64() * 100.}
		tableau[i].B = Point{rand.Float64() * 100., rand.Float64() * 100.}
		tableau[i].C = Point{rand.Float64() * 100., rand.Float64() * 100.}
	}
	return tableau
}

//Perimeter formula
func (t Triangle) Perimeter() float64 {

	var A float64 = distanceBetweenTwoPoints(t.A, t.B)
	var B float64 = distanceBetweenTwoPoints(t.B, t.C)
	var C float64 = distanceBetweenTwoPoints(t.C, t.A)

	var Perimeter float64 = (A + B + C)

	return Perimeter
}

//Heron's Area formula
func (t Triangle) Area() float64 {
	//area=sqrt(s(s-a)(s-b)(s-c)) where s=(a+b+c)/2

	var A float64 = distanceBetweenTwoPoints(t.A, t.B)
	var B float64 = distanceBetweenTwoPoints(t.B, t.C)
	var C float64 = distanceBetweenTwoPoints(t.C, t.A)

	var S float64 = ((A + B + C) / 2)

	var Area float64 = math.Sqrt(S * (S - A) * (S - B) * (S - C))

	return Area
}

//Give the distance between two points
func distanceBetweenTwoPoints(p1 Point, p2 Point) float64 {
	//d(P, Q) = √ (x2 − x1)2 + (y2 − y1)2
	var D float64 = math.Sqrt(math.Pow((p1.x-p2.x), 2) + math.Pow((p1.y-p2.y), 2))
	return D
}

//Ratio of a triangle give by his perimeter divided by his area
func (t Triangle) Ratio() float64 {
	var ratio float64 = (t.Perimeter() / t.Area())
	return ratio
}

type Stack struct {
	done  sync.Mutex //thread safety try out
	stack []Triangle
}

func NewStack() *Stack {
	return &Stack{sync.Mutex{}, make([]Triangle, 0)}
}

func (s *Stack) Push(v Triangle) {
	s.done.Lock()
	defer s.done.Unlock()

	s.stack = append(s.stack, v)
}

func (s *Stack) Pop() Triangle { //, error
	s.done.Lock()
	defer s.done.Unlock()

	l := len(s.stack)
	/*
		if l == 0 {
			return Triangle{Point{0, 0}, Point{0, 0}, Point{0, 0}}, errors.New("Empty Stack")
		}*/

	res := s.stack[l-1]
	s.stack = s.stack[:l-1]
	return res //, nil
}

func classifyTriangle(highRatio *Stack, lowRatio *Stack, ratioThreshold float64, triangles []Triangle, ch1 chan<- Stack, ch2 chan<- Stack, wg *sync.WaitGroup) {
	for i := 0; i < 1000; i++ {
		if triangles[i].Ratio() > ratioThreshold {
			highRatio.Push(triangles[i])
		}
		if triangles[i].Ratio() <= ratioThreshold {
			lowRatio.Push(triangles[i])
		}
	}
	ch1 <- *lowRatio
	ch2 <- *highRatio

	defer wg.Done()
}

func main() {
	/*
		fmt.Println("Test triangle formula")
		var t Triangle
		t.A = Point{0, 0}
		t.B = Point{5, 4}
		t.C = Point{5, 0}

		fmt.Println(t)
		fmt.Println("Perimeter: ", t.Perimeter())
		fmt.Println("Area: ", t.Area())
		fmt.Println("Ratio: ", t.Ratio())
	*/

	fmt.Println("Question 3")
	var array = triangles10000()
	var slice = array[:]

	highRatio := NewStack() //ratio>1.0
	lowRatio := NewStack()  //ratio<=1.0

	/*
		for i := 0; i < 10000; i++ {
			if slice[i].Ratio() > 1 {
				highRatio.Push(slice[i])
			}
			if slice[i].Ratio() <= 1 {
				lowRatio.Push(slice[i])
			}
		}
	*/
	ch1 := make(chan Stack, 20)
	ch2 := make(chan Stack, 20)
	wg := new(sync.WaitGroup)

	for i := 0; i < 10; i++ { //10 threads
		wg.Add(10)
		go classifyTriangle(highRatio, lowRatio, 1.0, slice, ch1, ch2, wg)
	}

	quit := make(chan bool)
	go func() {
		wg.Wait()
		quit <- true
	}()
	for i := 0; i < 10; i++ {
		<-ch1
		<-ch2
	}
	close(ch1)
	close(ch2)
	//fmt.Println("HR: ", highRatio)
	fmt.Println("Number of elem with High Ratio: ", len(highRatio.stack))
	fmt.Println("Element on top of High Ratio Stack: ", highRatio.Pop())
	//fmt.Println("LR: ", lowRatio)
	fmt.Println("Number of elem with Low Ratio: ", len(lowRatio.stack))
	fmt.Println("Element on top of Low Ratio Stack: ", lowRatio.Pop())

}
