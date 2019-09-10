package main

import "fmt"

func main() {
	c := make(chan string, 10)
	c <- "csi2520"
	c <- "csi3104"

	msg := <-c
	fmt.Println(msg)

}
