package main


import (
	"fmt"
	"strings"
)

func main() {
	lineWidth := 5
	symb := "x"
	lineSymb := symb
	for i:=0; i< lineWidth; i++{
		formatStr := fmt.Sprintf("%%%ds\n", lineWidth)
		fmt.Printf(formatStr, lineSymb)
		lineSymb += "x"
	}
	lineSymb = strings.TrimSuffix(lineSymb,"x")
	for i:=3; i>= 0; i--{
		lineSymb = strings.TrimSuffix(lineSymb,"x")
		formatStr := fmt.Sprintf("%%%ds\n", lineWidth)
		fmt.Printf(formatStr, lineSymb)
	}
}
