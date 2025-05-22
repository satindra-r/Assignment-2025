#!/bin/bash

declare -a files

sp=""
cols=$(tput cols)

for i in $(seq $cols); do
	sp="$sp "
done

print(){
	printf "\033[48;2;50;150;200m"
	printf "$sp"
	printf "\033[G"
	printf "\033[38;2;255;255;255m"
	echo "$1"
	printf "\033[0m"
}
printSelec(){
	printf "\033[48;2;250;150;50m"
	printf "$sp"
	printf "\033[G"
	printf "\033[38;2;0;0;0m"
	echo "$1"
	printf "\033[0m"
}
printImp(){
	printf "\033[48;2;50;50;250m"
	for i in $(seq $cols); do
		printf " "
	done
	printf "\033[G"
	printf "\033[38;2;255;255;255m"
	echo "$1"
	printf "\033[0m"
}
printImpSelec(){
	printf "\033[48;2;250;50;50m"
	for i in $(seq $cols); do
		printf " "
	done
	printf "\033[G"
	printf "\033[38;2;0;0;0m"
	echo "$1"
	printf "\033[0m"
}

list(){
	readarray -t files < links.txt
	for i in "${files[@]}"; do
		echo "$i"
	done
}

add(){
	if [ "$1" != "" ]; then
	echo $1 >> links.txt
	fi
}

br(){
	echo "--------------------------------------------------"
}

del(){
	readarray -t files < links.txt
	> links.txt
	for i in "${files[@]}"; do
		if [ "$i" != "$1" ]; then
			echo "$i" >> links.txt
		fi
	done
}


edit(){
	readarray -t files < links.txt
	> links.txt
	for i in "${files[@]}"; do
		if [ "$i" != "$1" ]; then
			echo "$i" >> links.txt
		else
			echo "$2" >> links.txt
		fi
	done
}

check() {
	readarray -t files < links.txt
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

awaitInput(){
	while true; do
		key="-"
		char1=""
		char2=""
		read -rsn1 char1
			if [ "$char1" = $'\e' ]; then
				read -rsn2 -t 0.001 char2
				if [ "$char2" = "[A" ]; then
					key="w"
				elif  [ "$char2" = "[B" ]; then
					key="s"
				#elif  [ "$REPLY" = "[C" ]; then
				#	key="d"
				#elif  [ "$REPLY" = "[D" ]; then
				#	key="a"
				fi
			else
				key="$char1"
			fi
			case "$key" in
				"w"|"s")
					retVal="$key"
					break
				;;
				" "|"")
					retVal="e"
					break
				;;
			esac
	done
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

menu(){
	pos=0
	options=("$@")
	len=$(("${#options[@]}" + 1))

	hideCursor

	while true; do
		for i in $(seq 0 $((len-2))); do
			if [ "$pos" = "$i" ]; then
				printSelec ">${options[$i]}"
			else
				print " ${options[$i]}"
			fi
		done
		if [ "$pos" = "$((len-1))" ]; then
				printImpSelec ">exit"
		else
				printImp "<exit"
		fi

		moveCurUp "$((len-pos))"

		showCursor
		awaitInput
		hideCursor

		keyPressed="$retVal"
		moveCurUp "$pos"
		case $keyPressed in
				"w")
					((pos--))
				;;
				"s")
					((pos++))
				;;
				"e")
					break
				;;
		esac
		pos="$(((pos + len) % len))"
	done

	moveCurDown "$len"
	showCursor

	retVal="$pos"
}

interactive(){
	while true; do
		br
		options=("list" "add" "del" "edit" "ping")
		menu "${options[@]}"
		pos="$retVal"
		case "$pos" in
			"0")
			br
			list
			;;
			"1")
			while true; do
				br
				printf "Enter website link or press enter to exit:"
				read -r site
				if [ "$site" = "" ]; then
					break
				else
					add "$site"
					echo "added $site"
				fi
			done
			;;
			"2")
			while true; do
				br
				readarray -t files < links.txt
				menu "${files[@]}"
				siteNo="$retVal"
				if [[ "$siteNo" = "${#files[@]}" ]]; then
					break
				else
					site="${files[$siteNo]}"
					del "$site"
					echo "Deleted $site"
				fi
			done
			;;
			"3")
			while true; do
				br
				readarray -t files < links.txt
				menu "${files[@]}"
				siteNo="$retVal"
				if [[ "$siteNo" = "${#files[@]}" ]]; then
					break
				else
					oldSite="${files[$siteNo]}"
					printf "Enter new website link to replace $oldSite or press enter to exit:"
					read -r newSite
					if [ "$newSite" != "" ]; then
						edit "$oldSite" "$newSite"
						echo "Edited $oldSite to $newSite"
					fi
				fi
			done
			;;
			"4")
				br
				check
			;;
			"5")
				break
			;;
		esac
	done
}

printHelp(){
echo "Usage:"
echo "-h (Display this message)"
echo "-l (List all sites)"
echo "-a <site> (Add site to be tracked)"
echo "-d <site> (Remove site from tracking)>"
echo "-e <oldSite> <newSite> (Replace oldSite with newSite)"
echo "-p (Ping all tracked sites)"
echo "-i (Open in interactive mode)"
}

case "$1" in
	"-l")
		list
	;;
	"-a")
		add "$2"
	;;
	"-d")
		del "$2"
	;;
	"-e")
		edit "$2" "$3"
	;;
	"-p")
		check
	;;
	"-i")
		interactive
	;;
	*)
		printHelp
	;;
esac
