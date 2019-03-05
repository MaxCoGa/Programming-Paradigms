package main

import (
	"fmt"
	"sync"
)

var wg sync.WaitGroup

func sum(a, b int, c chan int) {
	defer wg.Done()
	c <- a + b
	//wg.Done()
}

func main() {
	wg.Add(1)
	c := make(chan int)
	go func(a, b int) {
		defer wg.Done()
		c <- a + b
		//wg.Done()
	}(4, 6)

	go sum(4, 2, c)

	go func(a, b int) {
		defer wg.Done()
		c <- a + b
		//wg.Done()
	}(7, 6)
	//fmt.Println(cap(c))
	//fmt.Println(len(c))
	for i := range c {
		fmt.Println(i)
	}
	wg.Wait()

	close(c)

}
