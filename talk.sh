#!/bin/bash
###
FASTMODE=0
###
# T1="‎"
# if [[ $T1 = *[![:ascii:]]* ]]; then
#   echo "Contain Non-ASCII"
# fi
# echo "a|$T1|b"
# exit


getname() {
	src=$(curl -Ls https://www.behindthename.com/random/random.php?gender=both&number=1&sets=1&surname=&norare=yes&all=yes)
	T1=$(echo "$src" | grep plain)
	T2="${T1%%</a>*}"
	NAME="${T2##*>}"
	echo $NAME
}

getquote() {
	one=$(curl -Ls "http://www.quotationspage.com/random.php")
	T1=$(echo "$one" | sed 's/<p>/\n/g' | grep '.html">' | cat -n | head -n 5 | tail -n 1)
	T2="${T1%%</a>*}"
	QUOTE="${T2#*.html\">}"
	echo $QUOTE
}

printmsg() {
	if [[ $FASTMODE -eq 1 ]]; then
		echo $1
		return
	fi
	for (( i=0; i<${#1}; i++ )); do
  	echo -n "${1:$i:1}"
	sleep 0.05
	done
}

rmbalise() {
	stt="."
	if [[ "$1" == *"<"* ]]; then
		BEFORE="${1%%<*}"
		AFTER="${1##*>}"
		RES="$BEFORE$AFTER"
		if [[ -z "${RES// }" ]]; then
			echo "\033[35mWhat ?\033[0m"
			stt="*"
		else
			echo $RES
		fi
	else
		echo $1
	fi
}

rep() {
	INPUT="$1"
	SUB="$2"
	if [[ "$INPUT" == *"$SUB"* ]]; then
		INPUT="\033[35m$(getquote)\033[0m"
		stt="*"
	fi
}

blacklist_string() {
	name=$2
	rep "$1" "I love to chat to people."
	rep "$1" "Image from www.youtube.com"
	rep "$1" "Most men are pretty rude to me."
	rep "$1" "Image from www.expedia.com"
	rep "$1" "You would do that for me?"
	rep "$1" "The saying is money doesnt grow on trees."
	rep "$1" "Treaclecake"
	rep "$1" "A little is not a lot."

	splited=$(echo $INPUT | awk -F. '{print $1}')
	local nsub=$(( $RANDOM % 5 ))
	if [[ $nsub -eq 0 ]]; then
		splited=$(echo $INPUT | awk -F. '{print $1}')
	fi
	if [[ $nsub -eq 1 ]]; then
		splited=$(echo $INPUT | awk -F. '{print $1 FS $2}')
	fi
	if [[ $nsub -eq 2 ]]; then
		splited=$(echo $INPUT | awk -F. '{print $1 FS $2 FS $3}')
	fi
	if [[ ${splited:0:1} = *[![:ascii:]]* ]]; then
		splited="$(echo $INPUT | cut -d'.' -f2)"
	fi
	if [[ ${splited:0:1} = *[![:ascii:]]* ]]; then
		splited="$(echo $INPUT | cut -d'.' -f3)"
	fi
	local nsub=$(( $RANDOM % 800 ))
	if [[ $nsub -eq 0 ]]; then
		splited="$(getquote)"
	fi
	if [[ $nsub -eq 1 ]]; then
		splited="Do you know eamar 42 ? He is a high quality programmer."
	fi
	if [[ $nsub -eq 2 ]]; then
		splited="Do you know sloquet 42 ? He is a high quality programmer."
	fi
	if [[ ${#splited} -le 3 ]]; then
		splited="$(getquote)"
	fi
	if [[ ${#splited} -eq 0 ]]; then
		splited="$(getquote)"
	fi
	echo -e $splited | sed "s/Kuki/${name}/g" | sed "s/Treaclecake/${name}/g"
}

waiting_sc() {
	if [[ $FASTMODE -eq 1 ]]; then
		return 
	fi
	for i in {1..2}; do
		echo -n "."; sleep 0.1; echo -en "\033[2K\r"
		echo -n ".."; sleep 0.1; echo -en "\033[2K\r"
		echo -n "..."; sleep 0.1; echo -en "\033[2K\r"
		echo -n ".."; sleep 0.1; echo -en "\033[2K\r"
	done
	echo -n "."; sleep 0.1; echo -en "\033[2K\r"
}

space() {
	nbspace=$1
	for (( k = 0; k < $nbspace; k++ )); do
		echo -n " "
	done
}
󠃩󠃩
boxmsg() {
	local msg="$1"
	local color="$2"
	local name="$3"
	local side=$4
	local xmax=$(($COLUMNS / 3 + $COLUMNS / 3))
	local posx=0

	if [[ ${#msg} -le $xmax ]]; then
		xmax=${#msg}
	fi
	if [[ $side -eq 2 ]]; then
		posx=$(($COLUMNS - $xmax - 4))
	fi
	# space $posx; echo DEBUG: COLUMNS $COLUMNS XMAX $xmax POSX $posx

	space $posx
	echo -ne $color
	if [[ $side -eq 1 ]]; then
		echo -n " ╭"; for (( i = 0; i < $xmax; i++ )); do echo -n "─"; done; echo "╮"
	else
		echo -n " ╭"; for (( i = 0; i < $xmax; i++ )); do echo -n "─"; done; echo "╮"
	fi

	local lock=0
	for (( c = 0; c < ${#msg};)); do
		space $posx
		if [[ $c -eq 0 && $side -eq 1 ]]; then
				echo -n "◥│"
		else
			echo -n " │"
		fi
		for (( i = 0; i < $xmax; i++ )); do
			if [[ ${msg:$c:1} = *[![:ascii:]]* ]]; then
				echo -n " "
			else
				echo -n "${msg:$c:1}"
				sleep 0.03
			fi
			if [[ $c -eq ${#msg} ]]; then
				for (( i; i < $xmax; i++ )); do
					echo -n " "
				done
			fi
			c=$(($c + 1));
		done
		if [[ $lock -eq 0 && $side -eq 2 ]]; then
			echo "│◤"
			lock=1
		else
			echo "│"
		fi
	done
	space $posx
	echo -n " ╰"; for (( i = 0; i < $xmax; i++ )); do echo -n "─"; done; echo "╯"
	echo -ne "\033[0m"
	date=$(date '+%H:%M:%S');
	if [[ $side -eq 1 ]]; then
		echo -e "\033[2m $color $date @$name\033[22m\033[0m";
	else
		local timestamp=$(echo -e "$color $date @$name")
		posx=$(($COLUMNS - ${#timestamp} + 2))
		# space $posx; echo POSX $posx
		space $posx
		echo -e "\033[2m $timestamp\033[22m\033[0m";
	fi

	# arrows 25e4 / 25e5
	# ◤╭────╮◥
	#  │    │
	#  ╰────╯
	#  <date> @<name>
}

### INITIALISATION
clear
stt=">"
K1_NAME=$(getname)
K2_NAME=$(getname)

P1=$(cat k1p)
P2=$(cat k2p)
FILENAME="conv-$(date +'%m-%d-%Y')-$(date +%H-%M-%S)-$(date +%s)"
SAVE="./conversations/$FILENAME"
K1_IN="$1"
if [[ -z "$K1_IN" ]]; then
	K1_IN=$(getquote)
fi
date=$(date '+%H:%M:%S %d-%m-%Y')
echo -e "$date [ $K1_NAME & $K2_NAME ] >> \033[95m$FILENAME\033[0m"; echo
echo -e "$date [ $K1_NAME & $K2_NAME ] >> $FILENAME\n" >> $SAVE

# echo -en "\033[2m$date [${stt}] $K1_NAME : \033[22m"; echo -en "\033[32m"; printmsg "$K1_IN"; echo -ne "\033[0m"
boxmsg "$K1_IN" "\033[32m" "$K1_NAME" 1
echo
date=$(date '+%H:%M:%S');
echo -e "$date [${stt}] $K1_NAME : $K1_IN" >> $SAVE; echo >> $SAVE

# BOUCLE PRINCIPALE
while true
do
	### K1
	K1P="input=${K1_IN}${P1}"
	K1_OUT=$(curl -s -X POST -d "${K1P}" https://icap.iconiq.ai/talk)
	# echo K1_OUT; echo $K1_OUT; echo
	T1=${K1_OUT%[*}
	# echo T1; echo $T1; echo
	T2=${T1%]*}
	# echo T2; echo $T2; echo
	T3=${T2##*[}
	# echo T3; echo $T3; echo
	T4=${T3:1:-1}
	T5=$(echo $T4 | tr -d '\\' | tr -d '/' | tr -d '"' | tr -d "'")
	T6=$(rmbalise "$T5")
	K2_IN=$(blacklist_string "$T6" "$K2_NAME")
	waiting_sc
	echo

	# echo -en "\033[2m$date [${stt}] $K2_NAME : \033[22m"; echo -en "\033[34m"; printmsg "$K2_IN"; echo -ne "\033[0m"
	boxmsg "$K2_IN" "\033[34m" "$K2_NAME" 2
	echo
	date=$(date '+%H:%M:%S');
	echo -e "$date [${stt}] $K2_NAME : $K2_IN" >> $SAVE; echo >> $SAVE

	### K2
	K2P="input=${K2_IN}${P2}"
	K2_OUT=$(curl -s -X POST -d "${K2P}" https://icap.iconiq.ai/talk)
	# echo K2_OUT; echo $K2_OUT; echo
	T1=${K2_OUT%[*}
	# echo T1; echo $T1; echo
	T2=${T1%]*}
	# echo T2; echo $T2; echo
	T3=${T2##*[}
	# echo T3; echo $T3; echo
	T4=${T3:1:-1}
	T5=$(echo $T4 | tr -d '\\' | tr -d '/' | tr -d '"' | tr -d "'")
	T6=$(rmbalise "$T5")
	K1_IN=$(blacklist_string "$T6" "$K1_NAME")
	waiting_sc
	echo
	date=$(date '+%H:%M:%S');

	# echo -en "\033[2m$date [${stt}] $K1_NAME : \033[22m"; echo -en "\033[32m"; printmsg "$K1_IN"; echo -ne "\033[0m"
	boxmsg "$K1_IN" "\033[32m" "$K1_NAME" 1
	echo
	echo -e "$date [${stt}] $K1_NAME : $K1_IN" >> $SAVE; echo >> $SAVE
done
