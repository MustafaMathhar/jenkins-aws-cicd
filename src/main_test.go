package main

import (
	"testing"

	"gotest.tools/assert"
)

type intMinTest struct {
	arg1, arg2, expected int
}

func TestIntMin(t *testing.T) {
	intMinTests := []intMinTest{
		{5, 6, 5},
		{7, 3, 3},
	}
	for _, test := range intMinTests {
		res := IntMin(test.arg1, test.arg2)
		assert.Equal(t, res, test.expected)
	}
}
