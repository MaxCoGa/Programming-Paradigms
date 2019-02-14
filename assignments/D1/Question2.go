/**Question 2. Concurrence et communication - Maxime Côté-Gagné (8851539)**/
package main

import (
	"fmt"
	"sync"
	"time"
)

type Task struct {
	a, b float32      //les 2 nombres à additionner
	disp chan float32 //le channel via lequel l'Affichage se fait
}

const (
	NumRoutines = 3
	//NumRequests = 1000
)

//global semaphore monitoring the number of routines
var semRout = make(chan int, NumRoutines)

//global semaphore monitoring console
var semDisp = make(chan int, 1)

//Waitgroups to ensure that main does not exit until all done
var wgRout sync.WaitGroup
var wgDisp sync.WaitGroup

func solve(t *Task) {
	t.disp <- (t.a + t.b) //communication par le channel
	defer wgRout.Done()
	//DisplayServer() <- (<-t.disp)
}

func handleReq(t *Task) { //3 max
	wgRout.Add(3)
	go solve(t)
}

func ComputeServer() chan *Task {

	handleReq(<-channel)

	return channel

}

var channel = make(chan *Task) //testing

func main() {
	//main->computeserver->handlereq->solve0>displayserver
	//dispChan := DisplayServer()
	reqChan := ComputeServer()

	var task Task

	//channel := make(chan *Task)

	for {
		var a, b float32
		// use semDisp to make sure a result will
		// not be displayed while a user is interacting

		fmt.Print("Enter two numbers: ")
		fmt.Scanf("%f %f \n", &a, &b)
		fmt.Printf("%f %f \n", a, b)
		if a == 0 && b == 0 {
			break
		}
		task.a, task.b = a, b
		channel <- &task
		reqChan <- &task

		// Create task and send to ComputeServer
		// …

		time.Sleep(1e9)

	}
	// Don’t exit until all is done
}

/*
expected result:
Enter two numbers: 2.4 3
2.400000 3.000000
Enter two numbers: 8.0 1.5
8.000000 1.500000
-------
Result: 5.400000
-------
Enter two numbers: 0 0
0.000000 0.000000
-------
Result: 9.500000
-------
*/
