/**Question 1. Structures, Méthodes and Interfaces - Maxime Côté-Gagné (8851539)**/
package main

import (
	"errors"
	"fmt"
)

type Trip struct {
	destination string
	weight      float32
	deadline    int
}

//Vous devez utiliser les types embarqués afin de minimiser la duplication de code.
type Truck struct {
	_type        string
	_name        string
	_destination string
	_speed       float32 //liste
	_capacity    float32
	_load        float32
}
type Pickup struct {
	Truck     //type embarque
	isPrivate bool
}

type TrainCar struct {
	Truck   //type embarque
	railway string
}

//PTR pour changer donnée du récepteur
func NewTruck() *Truck {
	truck := new(Truck)
	truck._type = "Truck"
	//truck._name = "T"
	truck._destination = ""
	truck._speed = 40
	truck._capacity = 10
	truck._load = 0
	return truck
}

func NewPickUp() *Pickup {
	pickup := new(Pickup)
	pickup._type = "Pickup"
	//pickup._name = "P"
	pickup._destination = ""
	pickup._speed = 60
	pickup._capacity = 2
	pickup._load = 0
	pickup.isPrivate = true
	return pickup
}

func NewTrainCar() *TrainCar {
	traincar := new(TrainCar)
	traincar._type = "TrainCar"
	//traincar._name = "TC"
	traincar._destination = ""
	traincar._speed = 30
	traincar._capacity = 30
	traincar._load = 0
	traincar.railway = "CNR"
	return traincar
}

//INTERFACE
type Transporter interface {
	/*addLoad prenant un Trip en argument et retournant une error si le transporteur dépasse
	sa capacité, ou a une destination différente, ou ne peut livrer en temps. Si la destination
	courante du transporteur est vide, alors celle-ci doit être mise à jour avec la destination
	prévue pour l’item ajouté. */
	addLoad(trip Trip) error
	/*print afiichant le transporteur à la console */
	print()
}

//interface addLoad, Utilise le type embarqué Truck, donc on peut l'utiliser pour les autres type struct
func (t *Truck) addLoad(trip Trip) error {

	fmt.Println(t._type + t._name + ":")
	if trip.weight > (t._capacity - t._load) {
		errorMsg := errors.New("Error: Out of capacity")
		return errorMsg
	} else if t._destination == "Toronto" { //400km / 40km/h
		if trip.deadline < (int)(400/t._speed) {
			errorMsg := errors.New("Error: Not enough time")
			return errorMsg
		}
	} else if trip.destination == "Montreal" { //200km / 40km/h
		if trip.deadline < (int)(200/t._speed) {
			errorMsg := errors.New("Error: Not enough time")
			return errorMsg
		}
	}

	if t._destination == "" {
		t._destination = trip.destination
		errorMsg := errors.New("Error: No destination found for this transport")
		return errorMsg
	} else {
		if trip.destination != t._destination {
			errorMsg := errors.New("Error: Other destination")
			return errorMsg
		}
	}

	errorMsg := errors.New("Load Successful")
	return errorMsg
}

//interface print, utilise le type embarqué Truck
func (t *Truck) print() {
	fmt.Println(t._type, t._name, "to", t._destination, "with", t._load, "tons")
}
func (t *Pickup) print() {
	fmt.Println(t._type, t._name, "to", t._destination, "with", t._load, "tons", "(Private:", t.isPrivate, ")")
}
func (t *TrainCar) print() {
	fmt.Println(t._type, t._name, "to", t._destination, "with", t._load, "tons", "("+t.railway+")")
}

func NewTorontoTrip(weight float32, deadline int) *Trip {
	trip := new(Trip)
	trip.destination = "Toronto"
	trip.weight = weight
	trip.deadline = deadline
	return trip
}

func NewMontrealTrip(weight float32, deadline int) *Trip {
	trip := new(Trip)
	trip.destination = "Montreal"
	trip.weight = weight
	trip.deadline = deadline
	return trip
}

func main() {
	tripList := make([]Trip, 0)
	//VAR
	t1 := NewTruck()
	t1._name = "A"
	t2 := NewTruck()
	t2._name = "B"
	p1 := NewPickUp()
	p1._name = "A"
	p2 := NewPickUp()
	p2._name = "B"
	p3 := NewPickUp()
	p3._name = "C"
	tc1 := NewTrainCar()
	tc1._name = "A"

	tl := make([]Truck, 0)
	tl = append(tl, *t1)
	tl = append(tl, *t2)
	pl := make([]Pickup, 0)
	pl = append(pl, *p1)
	pl = append(pl, *p2)
	pl = append(pl, *p3)
	tcl := make([]TrainCar, 0)
	tcl = append(tcl, *tc1)

	//TEST
	/*
		fmt.Println(tripList)
		fmt.Println(tl)
		fmt.Println(pl)
		fmt.Println(tcl)
		t1.print()
		p1.print()
		tc1.print()
	*/
	//END TEST

	var dest string
	var weight float32
	var dead int
	var j int //use to iterate trough trips

	for dest != "t" || dest != "m" {
		fmt.Printf("Destination: (t)oronto, (m)ontreal, else exit?")
		fmt.Scanf("%s \n", &dest)
		if dest == "t" { //toronto
			dest = "Toronto"
			fmt.Printf("Weight:")
			fmt.Scanf("%f \n", &weight)

			fmt.Printf("Deadline (in hours):")
			fmt.Scanf("%d \n", &dead)

			trt := NewTorontoTrip(weight, dead)
			tripList = append(tripList, *trt)

			//LOOP
			use := false

			for {
				for i := 0; i < len(tl); i++ {
					fmt.Println(tl[i].addLoad(tripList[j])) //error check
					if (tl[i]._capacity-tl[i]._load) >= tripList[j].weight && (tl[i]._destination == "" || tl[i]._destination == tripList[j].destination) {

						tl[i]._destination = tripList[i].destination
						tl[i]._load += tripList[j].weight

						use = true
						break
					}

				}
				if use == true {
					break
				}

				for i := 0; i < len(pl); i++ {
					fmt.Println(pl[i].addLoad(tripList[j])) //error check
					if (pl[i]._capacity-pl[i]._load) >= tripList[j].weight && (pl[i]._destination == "" || pl[i]._destination == tripList[j].destination) {

						pl[i]._destination = tripList[j].destination
						pl[i]._load += tripList[j].weight

						use = true
						break
					}
				}
				if use == true {
					break
				}

				for i := 0; i < len(tcl); i++ {
					fmt.Println(tcl[i].addLoad(tripList[j])) //error check
					if (tcl[i]._capacity-tcl[i]._load) >= tripList[j].weight && (tcl[i]._destination == "" || tcl[i]._destination == tripList[j].destination) {

						tcl[i]._destination = tripList[j].destination
						tcl[i]._load += tripList[j].weight

						use = true
						break
					}
				}
				if use == true {
					break
				}
				break
			}

			j++

		} else if dest == "m" { //montreal
			dest = "Montreal"
			fmt.Printf("Weight:")
			fmt.Scanf("%f \n", &weight)

			fmt.Printf("Deadline (in hours):")
			fmt.Scanf("%d \n", &dead)

			mtl := NewMontrealTrip(weight, dead)
			tripList = append(tripList, *mtl)

			//LOOP
			use := false

			for {
				for i := 0; i < len(tl); i++ {

					fmt.Println(tl[i].addLoad(tripList[j])) //error check
					if (tl[i]._capacity-tl[i]._load) >= tripList[j].weight && (tl[i]._destination == "" || tl[i]._destination == tripList[j].destination) {

						tl[i]._destination = tripList[i].destination
						tl[i]._load += tripList[j].weight

						use = true
						break
					}

				}
				if use == true {
					break
				}

				for i := 0; i < len(pl); i++ {
					fmt.Println(pl[i].addLoad(tripList[j])) //error check
					if (pl[i]._capacity-pl[i]._load) >= tripList[j].weight && (pl[i]._destination == "" || pl[i]._destination == tripList[j].destination) {

						pl[i]._destination = tripList[j].destination
						pl[i]._load += tripList[j].weight

						use = true
						break
					}
				}
				if use == true {
					break
				}

				for i := 0; i < len(tcl); i++ {
					fmt.Println(tcl[i].addLoad(tripList[j])) //error check
					if (tcl[i]._capacity-tcl[i]._load) >= tripList[j].weight && (tcl[i]._destination == "" || tcl[i]._destination == tripList[j].destination) {

						tcl[i]._destination = tripList[j].destination
						tcl[i]._load += tripList[j].weight

						use = true
						break
					}
				}
				if use == true {
					break
				}
				break
			}

			j++

		} else {
			fmt.Println("Not going to Toronto or Montreal, bye!")
			fmt.Println("Trips:", tripList)
			fmt.Println("Vehciules:")
			for i := range tl {
				tl[i].print()
			}
			for i := range pl {
				pl[i].print()
			}
			for i := range tcl {
				tcl[i].print()
			}
			break
		}

	}

}
