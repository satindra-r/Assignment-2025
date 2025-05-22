#!/bin/bash

declare -a files

list(){
	readarray -t files < ~/.config/conshk
	for i in "${files[@]}"; do
		echo "$i"
	done
}

add(){
	if [ "$1" != "" ]; then
	echo $1 >> ~/.config/conshk
	fi
}

del(){
	readarray -t files < ~/.config/conshk
	> ~/.config/conshk
	for i in "${files[@]}"; do
		if [ "$i" != "$1" ]; then
			echo "$i" >> ~/.config/conshk
		fi
	done
}


edit(){
	readarray -t files < ~/.config/conshk
	> ~/.config/conshk
	for i in "${files[@]}"; do
		if [ "$i" != "$1" ]; then
			echo "$i" >> ~/.config/conshk
		else
			echo "$2" >> ~/.config/conshk
		fi
	done
}

check() {
	readarray -t files < ~/.config/conshk
	for i in "${files[@]}"; do
		response="$(curl -ILs $i | grep -o -E "^HTTP/[0-9.]+ [0-9]+" | grep -o -E " [0-9]+" | grep -o -E "[0-9]+"|tail -n1)"
		if [ "$response" = "200" ]; then
			echo "$i is Accessible"
		elif [ "$response" = "" ]; then
			echo "$i Does not Exist"
		else
			echo "$i Returned Status Code: $response"
		fi
	done
}
