/** CSI 2520 Quiz 3 - Maxime Côté-Gagné - 8851539**/
package main

import (
	"fmt"
)

const max = 10

func parallelMergesort1(s []int) {
	len := len(s)

	if len > 1 {
		if len <= max { // Sequential
			mergesort(s)
		} else { // Parallel
			middle := len / 2

			//var wg sync.WaitGroup

			done := make(chan bool)

			//wg.Add(2)

			go func() {
				//defer wg.Done()
				parallelMergesort1(s[:middle])

				done <- true
			}()
			<-done

			go func() {
				//defer wg.Done()
				parallelMergesort1(s[middle:])

				done <- true
			}()
			<-done

			close(done)
			merge(s, middle)
		}
	}
}

func merge(s []int, middle int) {
	helper := make([]int, len(s))
	copy(helper, s)

	helperLeft := 0
	helperRight := middle
	current := 0
	high := len(s) - 1

	for helperLeft <= middle-1 && helperRight <= high {
		if helper[helperLeft] <= helper[helperRight] {
			s[current] = helper[helperLeft]
			helperLeft++
		} else {
			s[current] = helper[helperRight]
			helperRight++
		}
		current++
	}

	for helperLeft <= middle-1 {
		s[current] = helper[helperLeft]
		current++
		helperLeft++
	}
}

/* Sequential */

func mergesort(s []int) {
	if len(s) > 1 {
		middle := len(s) / 2
		mergesort(s[:middle])
		mergesort(s[middle:])
		merge(s, middle)
	}
}

/*main*/
func main() {
	s := []int{5, 8, 9, 5, 0, 10, 1, 16, 3, 2, 11, 6}
	mergesort(s)
	fmt.Println(s)
	//assert.Equal(t, []int{0, 1, 5, 5, 6, 8, 9, 10}, s)

	p := []int{5, 8, 9, 5, 0, 10, 1, 16, 3, 2, 11, 6}
	parallelMergesort1(p)
	fmt.Println(p)
	//assert.Equal(t, []int{0, 1, 5, 5, 6, 8, 9, 10}, s1)
}
