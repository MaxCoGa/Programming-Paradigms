/*
 *CSI 2520 - Quiz 1 - Maxime Côté-Gagné - 8851539
 */
package main

import "fmt"

func sliceminmax(slice []int) []int{
	fmt.Println("Original array/slice:",slice)

	//VAR
	var min int = 0
	var max int = 0
	var pos int

	//MIN LOOP
	//fmt.Println("MIN LOOP")
	for i, elem := range slice {
		if i==0 || elem < min {
			min = elem	
			pos = i
			//fmt.Println("pos:",pos)
			//fmt.Println("min:",min)
		}
		
	}
	slice[pos], slice[0] = slice[0], min
	fmt.Println("After min loop:",slice)

	//MAX LOOP
	//fmt.Println("MAX LOOP")
	for i, elem := range slice {
		if i==0 || elem > max {
			max = elem
			pos = i	
			//fmt.Println("pos:",pos)
			//fmt.Println("max:",max)
		}
	}
	slice[pos], slice[1] = slice[1], max
	fmt.Println("After max loop:",slice)
	
	//fmt.Println("Minimum:",min)
	//fmt.Println("Maximum:",max)

	return slice
}

func main() {
	var tableau = [7]int{3, 4, 8, 9, 5, 2, 7}//array
	
	var slice []int = tableau[:]//slice
	
	slice = sliceminmax(slice)//function

	fmt.Println("New array/slice:",slice)
	
}