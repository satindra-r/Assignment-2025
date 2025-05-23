#!/bin/bash

source ansi.sh

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
	len="${#files[@]}"
	if [[ "$1" = "-b"  && "$len" != "0" ]]; then
		echo ""
	fi
	for i in $(seq 0 $((len-1))); do
		site=${files[$i]}
		if [[ "$1" = "-b" ]]; then
			moveCurUp $((i+1))
			progressBar $i $len
			moveCurDown $((i+1))
		fi
		response="$(curl -ILs $site | grep -o -E "^HTTP/[0-9.]+ [0-9]+" | grep -o -E " [0-9]+" | grep -o -E "[0-9]+"|tail -n1)"
		if [ "$response" = "200" ]; then
			echo "$site is Accessible"
		elif [ "$response" = "" ]; then
			echo "$site Does not Exist"
		else
			echo "$site Returned Status Code: $response"
		fi
	done
	if [[ "$1" = "-b" && "$len" != "0" ]]; then
		moveCurUp $((len+1))
		progressBar $len $len
		moveCurDown $((len+1))
	fi
}
