#!/bin/bash

echoSel(){
	printf "\033[38;2;250;250;250m"
	printf "\033[48;2;50;100;200m"
	echo "$1"
	printf "\033[0m"
}
echoImp(){
	printf "\033[38;2;250;0;0m"
	echo "$1"
	printf "\033[0m"
}
echoImpSel(){
	printf "\033[38;2;250;0;0m"
	printf "\033[48;2;0;50;150m"
	echo "$1"
	printf "\033[0m"
}

br(){
	echo "--------------------------------------------------"
}

moveCurUp(){
	if (($1 > 0)); then
		printf "\033[$1A"
	fi
}
moveCurDown(){
	if (($1 > 0)); then
		printf "\033[$1B"
	fi
}

hideCursor(){
	printf "\033[?25l"
}

showCursor(){
	printf "\033[?25h"
}

progressBar(){
	progressLen=$(((50*$1)/$2))
	for j in $(seq 0 $((progressLen-1))); do
		printf "▓"
	done
	for j in $(seq $progressLen 49); do
		printf "░"
	done
	echo ""
}
