#!/bin/bash

source ansi.sh
source files.sh
source controller.sh

declare -a files

raceLock=""

sigStart(){
	key="e"
}

sigStep(){
	if [[ "$key" = "e" ]]; then
		key="w"
	elif [[ "$key" = "w" ]]; then
		key="s"
	fi
}

trap sigStart USR1
trap sigStep USR2

awaitInput(){
	key="-"
	awaitButton "$$" &
	pid="$!"
	while [[ "$key" = "-" ]]; do
		char1=""
		char2=""
		read -rsn1 -t 0.01 char1
		if [[ "$?" = "0" ]]; then
			if [[ "$char1" = $'\e' ]]; then
				read -rsn2 -t 0.001 char2
				if [[ "$char2" = "[A" ]]; then
					retVal="w"
					break
				elif  [[ "$char2" = "[B" ]]; then
					retVal="s"
					break
				fi
			else
				case "$char1" in
					"w"|"s")
						retVal="$char1"
						break
					;;
					" "|"")
						retVal="e"
						break
					;;
				esac
			fi
		fi
	done
	if [[ "$key" != "-" ]]; then
		sleep 0.02
		retVal="$key"
	fi
	kill -term "$pid" 2> /dev/null
}

menu(){
	pos=0
	options=("$@")
	len=$(("${#options[@]}" + 1))

	hideCursor

	while true; do
		for i in $(seq 0 $((len-2))); do
			if [[ "$pos" = "$i" ]]; then
				echoSel ">${options[$i]}"
			else
				echo " ${options[$i]}"
			fi
		done
		if [[ "$pos" = "$((len-1))" ]]; then
				echoImpSel ">exit"
		else
				echoImp "<exit"
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
				if [[ "$site" = "" ]]; then
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
				readarray -t files < ~/.config/conshk
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
				readarray -t files < ~/.config/conshk
				menu "${files[@]}"
				siteNo="$retVal"
				if [[ "$siteNo" = "${#files[@]}" ]]; then
					break
				else
					oldSite="${files[$siteNo]}"
					printf "Enter new website link to replace $oldSite or press enter to exit:"
					read -r newSite
					if [[ "$newSite" != "" ]]; then
						edit "$oldSite" "$newSite"
						echo "Edited $oldSite to $newSite"
					fi
				fi
			done
			;;
			"4")
				br
				check "-b"
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
	echo "-pb (Ping all tracked sites with progress bar)"
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
	"-pb")
		check "-b"
	;;
	"-i")
		if [[ -e "/dev/input/js0" ]]; then
			if [[ -r "/dev/input/js0" ]]; then
				echoImp "Controller detected"
			else
				echoImp "Please run \"sudo usermod -aG input <username>\" then logout and login to enable controller input"
			fi
		else
			echo "Controller not detected"
		fi

		if [[ (! -r "/dev/input/js0") && (-e "/dev/input/js0") ]]; then
			>&2 echo "Please run \"sudo usermod -aG input <username>\" then logout and login to enable controller input"
		fi
		interactive
	;;
	*)
		printHelp
	;;
esac
