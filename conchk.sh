#!/bin/bash

declare -a files

add(){
	echo "$1" >> links.txt
}

del(){
	readarray files < links.txt
	> links.txt
	for i in "${files[@]}"
	do
		site="$(echo "$i" | tr -d '\n')"
		if [ "$site" != "$1" ]; then
			echo "$site" >> links.txt
		fi
	done
}


edit(){
	readarray files < links.txt
	> links.txt
	for i in "${files[@]}"
	do
		site="$(echo "$i" | tr -d '\n')"
		if [ "$site" != "$1" ]; then
			echo "$site" >> links.txt
		else
			echo "$2" >> links.txt
		fi
	done
}

check () {
site="$(echo "$i" | tr -d '\n')"
response=$(curl -iLs $site | grep -o -E "^HTTP/[0-9.]+ [0-9]+" | grep -o -E " [0-9]+" | grep -o -E "[0-9]+"|tail -n1)
if [ "$response" = "200" ]; then
	echo "$site is Accessible"
elif [ "$response" = "" ]; then
	echo "$site Does not Exist"
else
	echo "$site Returned Status Code: $response"
fi
}

if [ "$1" = "add" ]; then
	add "$2"
elif [ "$1" = "del" ]; then
	del "$2"
elif [ "$1" = "edit" ]; then
	edit "$2" "$3"
elif [ "$1" = "ping" ]; then
	readarray files < links.txt
		for i in "${files[@]}"
		do
			check "$i"
		done
fi
