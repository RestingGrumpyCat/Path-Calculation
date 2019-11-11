#!/bin/bash
#Student Name:Shiyu Wang

#This shell script takes points coordinates as arguments and calculate the longest distance, average distance, total distance and it tells if the first and last points are the same

number=$#   #I store the number of arguments in number in case I want to use it
longest=0.00 #initialize variables that will come in use later
sum=0.00
average=0.00
status=

if test $# -lt 4; then 	#error checking for 1)not enough argument; 2)odd number of arguments given; 3)argument given is not integer; 
	echo "Error: Need at least 4 arguments." 

elif [ $(($number % 2)) -ne 0 ]; then
	echo "Error: Need an even number of arguments."

else 
	for arg in "$@" #loop over $@ allows us to look at each argument and check if they are integer
	do
		test $arg -gt 0 2>/dev/null #redirect the standard error to the null, so it doesn't show
		if test "$?" -eq 2; then
			echo "Error: $arg is not an integer."
			exit 2
		fi
	done				


	x1=$1  #record the coordinate of the first point for comparison to the last point later
	y1=$2
	counter=0

	while [ $# -gt 0 ]; do #we calculate the distance between each two consecutive points using shift, loop ends when all arguments are shifted
		path=`echo "scale=2; sqrt(($1- $3)^2+($2- $4)^2)" | bc -l` #formula to calculate distance with a two-decimal result
		if [ $(echo "$path > $longest" | bc) -eq 1 ]; then #find the longest path by comparing numbers
			longest=$path
		fi
		sum=`echo "scale=2; $sum+$path" | bc -l` #final the total path by adding each path
		counter=$((counter+1))
		shift #shift to calculate distance between another two consecutive numbers
		shift
		if [ $# -eq 2 ]; then #when there is only one point left, we shift to end the loop, also check if the last point is at the same position as the first point 
			if [ $1 -eq $x1 ] && [ $2 -eq $y1 ]; then
				status=1
			else
				x2=$1
				y2=$2
				status=0
			fi					
			shift
			shift
		fi
	done

	average=`echo "scale=2; $sum/($counter)" | bc -l` #calculate the average by dividing the sum by the counter, which is the number of paths
	
	echo "Total path length: $sum"
	echo "Longest distance between two points: $longest"
	echo "Average distance between two points: $average"
	if [ $status -eq 1 ]; then 
		echo "Path leads back to start."
	else
		distance=`echo "scale=2; sqrt(($x1- $x2)^2+($y1- $y2)^2)" | bc -l`
		echo "Path leads $distance distance from start."
	fi 
fi
