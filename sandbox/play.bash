#!/bin/bash

myarr=($(echo $PATH | awk -F: ' { for(i=1;i<=NF;i++) { print $i } } '))

echo ${myarr[1]}

for i in "${myarr[@]}"
do
	echo $i
done
