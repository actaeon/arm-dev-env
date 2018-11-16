package main

// Forward declarations needed so the compiler knows they're externally linked

/*
extern void AverageTemps(char *, char *);

extern void MinMaxWrapper(char *, char *, char *);

*/
import "C"

import (
	"fmt"
	"os"
)

var (
	Avg byte
	Min byte
	Max byte
)

func main() {

	// iterate over an array of structs, each struct is a unit test
	// with a different array pattern. The test struct also has the
	// expected result values and a descriptive name
	for _, test := range []struct {
		Name        string
		Temps       []byte
		ExpectedAvg byte
		ExpectedMax byte
		ExpectedMin byte
	}{
		{
			Name: "all zeros",
			Temps: []byte{
				0x00, 0x00, 0x00, 0x00,
				0x00, 0x00, 0x00, 0x00,
				0x00, 0x00, 0x00, 0x00,
				0x00, 0x00, 0x00, 0x00,
			},
			ExpectedAvg: 0,
			ExpectedMin: 0,
			ExpectedMax: 0,
		},
		{
			Name: "all 125s",
			Temps: []byte{
				0x7D, 0x7D, 0x7D, 0x7D,
				0x7D, 0x7D, 0x7D, 0x7D,
				0x7D, 0x7D, 0x7D, 0x7D,
				0x7D, 0x7D, 0x7D, 0x7D,
			},
			ExpectedAvg: 125,
			ExpectedMin: 125,
			ExpectedMax: 125,
		},
		{
			Name: "1-16 ascending",
			Temps: []byte{
				0x01, 0x02, 0x03, 0x04,
				0x05, 0x06, 0x07, 0x08,
				0x09, 0x0A, 0x0B, 0x0C,
				0x0D, 0x0E, 0x0F, 0x10,
			},
			ExpectedAvg: 9,
			ExpectedMin: 1,
			ExpectedMax: 16,
		},
		{
			Name: "all zeros + 1",
			Temps: []byte{
				0x00, 0x00, 0x00, 0x00,
				0x00, 0x00, 0x00, 0x00,
				0x00, 0x00, 0x00, 0x00,
				0x00, 0x00, 0x00, 0x01,
			},
			ExpectedAvg: 0,
			ExpectedMin: 0,
			ExpectedMax: 1,
		},
		{
			Name: "all zeros + 125",
			Temps: []byte{
				0x00, 0x00, 0x00, 0x00,
				0x00, 0x00, 0x00, 0x00,
				0x00, 0x00, 0x00, 0x00,
				0x00, 0x00, 0x00, 0x7D,
			},
			ExpectedAvg: 8,
			ExpectedMin: 0,
			ExpectedMax: 125,
		},
		{
			Name: "all zeros + 1 and 125",
			Temps: []byte{
				0x01, 0x00, 0x00, 0x00,
				0x00, 0x00, 0x00, 0x00,
				0x00, 0x00, 0x00, 0x00,
				0x00, 0x00, 0x00, 0x7D,
			},
			ExpectedAvg: 8,
			ExpectedMin: 0,
			ExpectedMax: 125,
		},
		{
			Name: "first value 125",
			Temps: []byte{
				0x7D, 0x00, 0x00, 0x00,
				0x00, 0x00, 0x00, 0x00,
				0x00, 0x00, 0x00, 0x00,
				0x00, 0x00, 0x00, 0x03,
			},
			ExpectedAvg: 8,
			ExpectedMin: 0,
			ExpectedMax: 125,
		},
	} {
		// convert Golang native slice into C array for compatibility with linked in external objects
		tempsPtr := C.CBytes(test.Temps)

		// call our AverageTemps array
		C.AverageTemps((*C.char)(tempsPtr), (*C.char)(&Avg))

		// check if we got what we were expecting, compain and halt if not
		if Avg != test.ExpectedAvg {
			fmt.Printf("Test %s failed: expected average value of %v, got %v\n", test.Name, test.ExpectedAvg, Avg)
			os.Exit(-1)
		}

		// call our min-max routine
		C.MinMaxWrapper((*C.char)(tempsPtr), (*C.char)(&Min), (*C.char)(&Max))

		// check if we got what we were expecting, compain and halt if not
		if Min != test.ExpectedMin {
			fmt.Printf("Test %s failed: expected minimum value of %v, got %v\n", test.Name, test.ExpectedMin, Min)
			os.Exit(-1)
		}

		// check if we got what we were expecting, compain and halt if not
		if Max != test.ExpectedMax {
			fmt.Printf("Test %s failed: expected maximum value of %v, got %v\n", test.Name, test.ExpectedMax, Max)
			os.Exit(-1)
		}

		// if no complaints, this test passes
		fmt.Printf("Test %s pass\n", test.Name)
	}

	// if not halted, then all tests pass
	fmt.Println("All tests pass")

}
