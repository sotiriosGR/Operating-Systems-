#!/bin/bash



filename=
person_id=
born_since=
born_until=
column=
value=
am="5482"




function1="yes"
function2="no"
function3="no"
function4="no"
function5="no"
function6="no"
function7="no"
function8="no"




while [ $# -gt 0 ]
do
	case $1 in
		"-f")		
			filename=$2		
			shift
			function2="yes"
		;;
		"-id")
			person_id=$2
			shift
		;;
		"--edit")
			person_id=$2
			column=$3
			value=$4
			shift
			function8="maybe"
		;;
		"--firstnames")
			function4="maybe"
			shift
		;;
		"--lastnames") 
			function5="maybe"
			shift
		;;
		"--born-since")
			born_since=$2
			shift
		;;
		"--born-until")
			born_until=$2
			shift
		;;
		"--browsers")
			function7="maybe"
			shift
		;;
		*)
			shift
	esac
done



if [ $function2 = "yes" ] ; then
	if [ $person_id ] ; then
		function3="yes"
	fi
fi	


if [ $function2 = "yes"  -a  $function4 = "maybe" ] ; then
	function4="yes"
fi


if [ $function2 = "yes"  -a  $function5 = "maybe" ] ; then
	function5="yes"
fi

	
if [ $function2 = "yes" ] ; then 

	if [ $born_since ] ; then
		function6="since"
	fi
		
	if [ $born_until ] ; then 
		if [ $function6 = "since" ] ; then
			function6="yes"
		else
			function6="until"
		fi	
	fi
	
fi			


if [ $function2 = "yes" -a $function7 = "maybe" ] ; then
	function7="yes"
fi


if [ $function2 = "yes" -a $function8 = "maybe" ] ; then
	function8="yes"
fi





if [ $function8 = "yes" ] ; then
	if [ -f $filename ] ; then
			
		awk -v id_var=$person_id -v column_var=$column -v value_var=$value 'BEGIN{ FS = "|" ; OFS ="|";};{if( $1 == id_var && column_var < 9 && column_var > 1 ) $column_var = value_var ;print $0 ; }' $filename > temp5482.dat 
		mv temp5482.dat $filename
	fi	

elif [ $function7 = "yes" ] ; then
	
	awk 'BEGIN{ FS = "|"}!/#/{ if(!array[$8]++)};END{for(i in array)print i" "array[i]}' $filename | sort

elif [ $function5 = "yes" ] ; then
	
	 awk 'BEGIN{ FS = "|" };!/#/{print $3}' $filename | sort | uniq
	 
elif [ $function4 = "yes" ] ; then
	
	 awk 'BEGIN{ FS = "|" };!/#/{print $2}' $filename | sort | uniq
	 
elif [ $function3 = "yes" ] ; then
	
	awk -v id_var="$person_id" 'BEGIN{ FS = "|" };!/#/{ if( id_var == $1 ) print $2" "$3" "$5 }' $filename 
	
elif [ $function6 = "yes" ] ; then
	
	awk -v since_var="$born_since" -v until_var="$born_until" 'BEGIN{ FS = "|" };!/#/{ if( $5 <= until_var && $5 >= since_var) print }' $filename
	
elif [ $function6 = "since" ] ; then
	
	awk -v since_var="$born_since" 'BEGIN{ FS = "|" };!/#/{ if( $5 >= since_var ) print }' $filename

elif [ $function6 = "until" ] ; then
	
	awk -v until_var="$born_until" 'BEGIN{ FS = "|" };!/#/{ if( $5 <= until_var ) print }' $filename

elif [ $function2 = "yes" ] ; then
	
	awk '!/#/{print $0 }' $filename 
	
else
	
	echo $am
fi








