package main

import (
	"fmt"
	"math"
)

func main() {
	floor,ceilling := floorceilling(1.76)
	fmt.Printf("%.f,%.f", floor,ceilling)

}

func floorceilling (float float64)(float64,float64){
	x := math.Floor(float)
	y := math.Ceil(float)
	return x,y
}