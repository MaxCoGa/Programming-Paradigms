type Person struct {
		lastName string
		firstName string
		iD int
	}

func main() {
	nextId := 101
	for {
		var (
			p Person
			err error
		)
		nextId, err = inPerson(&p, nextId)
		if err != nil {
			fmt.Println("Invalid entry ... exiting")
			break
		}
		printPerson(p)
	}
}
	