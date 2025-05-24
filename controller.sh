#!/bin/bash

term(){
	exit="1"
}

trap term TERM

awaitButton(){
	exit="0"
	isB0Clicked="0"
	isB1Clicked="0"
	isB2Clicked="0"
	if [[ -e "/dev/input/js0" ]]; then
		while [[ "$exit" = "0" && "$isB0Clicked" = "0" && "$isB1Clicked" = "0" && "$isB2Clicked" = "0" ]]; do
			controllerInput=$(xxd -b -len 192 -cols 8 /dev/input/js0)
			isB0Clicked=$(echo "$controllerInput" | grep -c -E ": [0-1]+ [0-1]+ [0-1]+ [0-1]+ 00000001 00000000 00000001 00000001")
			isB1Clicked=$(echo "$controllerInput" | grep -c -E ": [0-1]+ [0-1]+ [0-1]+ [0-1]+ 00000001 00000000 00000001 00000000")
			isB2Clicked=$(echo "$controllerInput" | grep -c -E ": [0-1]+ [0-1]+ [0-1]+ [0-1]+ 00000001 00000000 00000001 00000011")
		done
		if [[ "$isB0Clicked" != "0" ]]; then
			kill -USR1 "$1"
		elif [[ "$isB1Clicked" != "0" ]]; then
			kill -USR1 "$1"
			kill -USR2 "$1"
			sleep 0.001
			kill -USR2 "$1"
		elif [[ "$isB2Clicked" != "0" ]]; then
			kill -USR1 "$1"
			kill -USR2 "$1"
		fi
	fi
}
