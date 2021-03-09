#!/bin/bash
# Simple tester shell script
# run : ./checker.sh valid.* user.* checker.* numberOfTestcases

#TODO : fix bug when two java classes have same name in different files

validCode=$1
userCode=$2
checkerCode=$3
testCount=$4

# Create new files
if [ -f "testcase.txt" ]
then
	rm testcase.txt
fi
touch testcase.txt

if [ -f "test_out.txt" ]
then
        rm test_out.txt
fi
touch test_out.txt

# Check for error
if [ $# -ne 4 ]
then
	echo "run : ./checker.sh valid.* user.* checker.* numberOfTestcases"
	exit
fi

# Compile the code
if [ ${validCode: -5} == ".java" ]
then
	javac $validCode
fi

if [ ${validCode: -2} == ".c" ]
then
	gcc $validCode -o executableValidC
fi
	
if [ ${validCode: -4} == ".cpp" ]
then
	g++ $validCode -o executableValidCPP
fi

if [ ${userCode: -5} == ".java" ]
then
	javac $userCode
fi

if [ ${userCode: -2} == ".c" ]
then
	gcc $userCode -o executableUserC
fi
	
if [ ${userCode: -4} == ".cpp" ]
then
	g++ $userCode -o executableUserCPP
fi

# Run tests
flag=1
for ((i=1 ; i<=testCount ; i++))
do
	# Create testcase using checker
	python3 $checkerCode $i
	cat input.txt >> testcase.txt
	# First file
	if [ ${validCode: -3} == ".py" ]
	then
		validOutput=`python3 $validCode < input.txt`
	fi
	
	if [ ${validCode: -5} == ".java" ]
	then
		validOutput=`java ${validCode::-5} < input.txt`
	fi
	
	if [ ${validCode: -2} == ".c" ]
	then
		validOutput=`./executableValidC < input.txt`
	fi
		
	if [ ${validCode: -4} == ".cpp" ]
	then
		validOutput=`./executableValidCPP < input.txt`
	fi
	# Second file
	if [ ${userCode: -3} == ".py" ]
	then
		userOutput=`python3 $userCode < input.txt`
	fi
	
	if [ ${userCode: -5} == ".java" ]
	then
		userOutput=`java ${userCode::-5} < input.txt`
	fi
	
	if [ ${userCode: -2} == ".c" ]
	then
		userOutput=`./executableUserC < input.txt`
	fi
		
	if [ ${userCode: -4} == ".cpp" ]
	then
		userOutput=`./executableUserCPP < input.txt`
	fi
	# Add output to file
	echo "$validOutput"  | tee -a test_out.txt > /dev/null
	# Break condition
	diff --strip-trailing-cr <(echo "$validOutput") <(echo "$userOutput")
	if [ $? -ne 0 ]
	then
		flag=0
		echo "### Different Output On Test $i ###"
		break
	fi
done
# Show results and clean up
if [ $flag -eq 1 ]
then 
	echo "### Passed Testing ###"
fi

echo "Added All Testcases to testcase.txt"
echo "Added Output to test_out.txt"

if [ ${validCode: -2} == ".c" ]
then
	rm executableValidC
fi

if [ ${validCode: -4} == ".cpp" ]
then
	rm executableValidCPP
fi

if [ ${userCode: -2} == ".c" ]
then
	rm executableUserC
fi

if [ ${userCode: -4} == ".cpp" ]
then
	rm executableUserCPP
fi

rm input.txt

