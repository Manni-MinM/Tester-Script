import sys
import random

# Gets ID of testcase and return the testcase
def func(ID) :
	inputFile = open("input.txt" , "w")
	# Write checker program here
	val = ID * 3 + 11
	inputFile.write(str(val) + "\n")
	# End of checker code
	inputFile.close()

# Get ID of testcase
args = sys.argv
ID = int(args[1])

# write test to file
func(ID)

