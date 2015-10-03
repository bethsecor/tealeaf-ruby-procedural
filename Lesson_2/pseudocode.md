1. a method that returns the sum of two integers
START
SET number1 = a number
SET number2 = another number

SET added = number1 + number2

PRINT added
END

2. a method that takes an array of strings, and returns a string that is all those strings concatenated together
START
# Given an array of strings
iterator = 1
WHILE iterator < length of numbers
SET string = previous string plus current string in array

PRINT string

END

3. a method that takes an array of integers, and returns a new array with every other element
START
# Given an array of integers
iterator = 1
WHILE iterator < length of numbers
IF iterator = 0 or iterator is even
SET new_array = previous new_array + number
ELSE
do nothing

END
