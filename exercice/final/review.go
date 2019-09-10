//Goroutine
package main

import (
	"fmt"
	"math"
	"math/rand"
	"runtime"
)

type Series struct {
	a, b float64
}

func main() {
	runtime.GOMAXPROCS(3)
	data := make(chan float64)
	defer close(data)
	var c [32]Series
	TP := 4
	for t := 0; t < TP; t++ {
		for k := 0; k < 32; k++ {
			c[k].a = rand.Float64() / 32.0
			c[k].b = rand.Float64() / 32.0
		}
		go fourier(c, t, TP, data)
	}
	// Below the results from all of the go routines need to be
	// received and printed to the console. The program is to exit
	// when all data is received.
	for t := 0; t < TP; t++ {
		fmt.Println(<-data)
	}
}

func fourier(c [32]Series, t, TP int, out chan float64) {
	res := c[0].a
	for n := 1; n < 32; n++ {
		res += c[n].a*math.Sin(2.0*math.Pi*float64(t)/float64(TP)) + c[n].b*math.Cos(2.0*math.Pi*float64(t)/float64(TP))
	}
	out <- res
	return
}

func fourier2(c []Series, t, TP int, out chan float64) {
	res := c[0].a
	for n := range c {
		res += c[n].a*math.Sin(2.0*math.Pi*float64(t)/float64(TP)) + c[n].b*math.Cos(2.0*math.Pi*float64(t)/float64(TP))
	}
	out <- res
	return
}

//////////////////////////////////////////////////////////
