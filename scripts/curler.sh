#!/bin/bash 

sleep=${2:-"0"}

for (( c=1; ; c++ ))
do
   echo " - attempt $c - infinite loops [ hit CTRL+C to stop]"
   date
   curl $1
   sleep $sleep
done
