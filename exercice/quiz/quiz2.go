/** CSI 2520 - Quiz 2 - Maxime Côté-Gagné - 8851539 **/

/*
Le programme suivant doit être modifié de telles sortes qu’il utilise un « slice » de taille arbitraire au lieu d’un tableau fixe.
La taille soumit par l’utilisateur (variable sz) doit remplacer la valeur 32 codé en dur de la taille du tableau.
Modifiez la fonction main, ainsi que les autres fonctions si nécessaire.
Soumettez votre solution en un fichier go.
*/
package main

import "fmt"
import "math"
import "math/rand"

type Series struct {
	a, b float64
}

func (s Series) add(t, TP int) float64 {
	return s.a*math.Sin(2.0*math.Pi*float64(t)/float64(TP)) + s.b*math.Cos(2.0*math.Pi*float64(t)/float64(TP))
}

//func fourier(c [32]Series, t, TP int) (res float64) {
func fourier(c []Series, t, TP int) (res float64) {
	res = c[0].a
	//for n := 1; n < 32; n++ {
	for n := 1; n < len(c); n++ {
		res += c[n].add(t, TP)
	}
	return
}

func main() {
	TP := 4
	sz := 1
	var res float64

	// Enter size of fourier series
	//fmt.Print("Size of series (1 ... 512): ")
	fmt.Print("Size of series (positive integer) :") //CHANGE

	// Depending on your environment you may have to remove \n in the scanf
	_, err := fmt.Scanf("%d \n", &sz)

	//for err != nil || sz < 1 || sz > 512 {
	for err != nil || sz < 1 { //CHANGE
		//fmt.Println("Must be positive integer (1...512).")
		//fmt.Println("Size of series (1 ... 512): ")
		fmt.Println("Must be positive integer.")
		_, err = fmt.Scanf("%d \n", &sz)
	}
	fmt.Printf("Size: %d\n", sz)

	//var c [32]Series //Need change to sz
	var c = make([]Series, sz)

	for t := 0; t < TP; t++ {
		//for k := 0; k < 32; k++ {
		for k := 0; k < len(c); k++ {
			c[k].a = rand.Float64()
			c[k].b = rand.Float64()
		}
		res += fourier(c, t, TP)
		fmt.Printf("%f ", res)
		fmt.Println()
	}
}
