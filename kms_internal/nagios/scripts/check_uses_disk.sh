#!/bin/bash

calculate_disk_uses(){
	local RETURN_FLAG=0;
	local WARNING_ARR=();
	local CRITICAL_ARR=();
	USED_DISK_SPACE_LINE=$(df -h -x tmpfs -x squashfs | grep -v 'Filesystem' | awk '{ print "["$1"]="$5 }' | sed 's/\%//g' )
	declare -A USED_DISK_SPACE_ARR="($USED_DISK_SPACE_LINE)"
	
	for partition in "${!USED_DISK_SPACE_ARR[@]}"
	do
		if ((  "${USED_DISK_SPACE_ARR[$partition]}" >= ${CRITICAL_THRESHOLD} ))
		then
			CRITICAL_ARR+=($partition)
			continue
		elif (( "${USED_DISK_SPACE_ARR[$partition]}" >= ${WARNING_THRESHOLD} ))
		then
			WARNING_ARR+=($partition)
			continue
		fi	
	done
	if [ ${#CRITICAL_ARR[@]} -ne 0 ]
	then
		return_msg=$(IFS=","; echo "CRITICAL - This partition has reached its critical threshold ${CRITICAL_ARR[*]}")	
		#for partition in "${!CRITICAL_ARR[@]}"
		#do
		#	return_msg+="\n${CRITICAL_ARR[$partition]} "
		#done
		echo $return_msg
		exit 2
	elif [ ${#WARNING_ARR[@]} -ne 0 ]
	then
		return_msg=$(IFS=","; echo "WARNING - This partition has reached its warning threshold! : ${WARNING_ARR[*]}")
		#for partition in "${!WARNING_ARR[@]}"
		#do
		#	return_msg+="\n ${WARNING_ARR[$partition]}"
		#done
		echo $return_msg
		exit 1
	else
		echo "OK - All disks are healthy"
		exit 0
	fi


	
}

usage(){
	echo 'Usage: check_uses_disk -w <percentage> -c <percentage> EX: check_uses_disk -w 40 -c 60 '
} 
while getopts ":w:c:" arg; do
	case "${arg}" in
		w)
			WARNING_THRESHOLD=${OPTARG}
			;;
		c)
			CRITICAL_THRESHOLD=${OPTARG}
			;;
		*)
			usage
			exit 3
			;;
		esac
	done

if [[ -z ${WARNING_THRESHOLD}  || -z ${CRITICAL_THRESHOLD}  ]] 
then
	usage
	exit 3
fi

calculate_disk_uses
