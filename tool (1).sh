#!/bin/bash

#ONOMATEPONYMO : ALEKSIOU SOTIRIOS
#A.M. : 5712


if [ -z "$1" ] ; then 

 echo "5712"

fi

# case (A)
if [ "$1" = "-f" ] && [ -z "$3" ]; then 
filename=$2 
awk '!/#/{print;}' $2 
#edw ektupwnetai olo to arxeio
fi

# case (B)
if ([ "$1" = "-f" ] || [ "$1" = "-id" ]) && ([ "$3" = "-f" ] ||
[ "$3" = "-id" ]) && [ -z "$5" ]; then 
  if [ "$1" = "-f" ]; then 
#bazoume oles tis pithanes periptwseis ston elegxo etsi oste na min uparxei provlima sti seira pou tha mpei i kathe parametros

    fname=$2
#thetw ws metabliti fname to arxeio kai ws idf ton arithmo tou id xristi

    idf=$4
 
  else
    fname=$4

    idf=$2
 fi
awk -v idf=$idf -F "|" '!/#/{if (idf == $1) print $3 " " $2 " " $5}' $fname
##to sumvolo | to xrisimopoioume gia na orisoume pou allazei i leksi sto personsdat
fi
#case (C)
if ([ "$1" = "-f" ] && [ "$3" = "--firstnames" ]) || ([ "$1" = "--firstnames" ] && [ "$2" = "-f" ]) ; then

 if [ "$1" = "-f" ] ; then
   
   fname=$2

 else
   
   fname=$3 
 fi

awk -F "|" '!/#/{print $3}' $fname | sort | uniq
#
fi

#case (D)
 if ([ "$1" = "-f" ] && [ "$3" = "--lastnames" ]) || ([ "$1" = "--lastnames" ] && [ "$2" = "-f" ]) ; then

 if [ "$1" = "-f" ] ; then
   
   fname=$2

 else
   
   fname=$3 
 fi

awk -F "|" '!/#/{print $2}' $fname | sort | uniq
#
fi

# case (E)
 if ([ "$1" == "-f" ] || [ "$3" == "-f" ] || [ "$5" == "-f" ]) && ([ "$1" == "--born-since" ] || [ "$3" == "--born-since" ] || [ "$5" = "--born-since" ] || [ "$1" == "--born-until" ] || [ "$3" == "--born-until" ] || [ "$5" == "--born-until" ]) ; then
#
   if [ -z "$5" ] && [ "$1" == "--born-since" ] ; then
       
      bsince=$2
      
      fname=$4
          
      buntil=$(date +'%Y-%m-%d')
#afou den uparxei alli parametros born-until kitame gia imerominies sto born util
 
 elif [ -z "$5" ] && [ "$3" == "--born-since" ] ; then
#

      bsince=$4 #
     
      fname=$2

      buntil=$(date +'%Y-%m-%d')

 elif [ -z "$5" ] && [ "$1" == "--born-until" ] ; then #
    
      bsince=$(date -d 19000101 +'%Y-%m-%d') #

      fname=$4
      
      buntil=$2

 elif [ -z "$5" ] && [ "$3" == "--born-until" ] ; then
      
      bsince=$(date -d 19000101 +'%Y-%m-%d')
     
      fname=$2
  
      buntil=$4
 elif [ "$5" == "--born-since" ] && [ "$1" == "--born-until" ] ; then
 #periptwseis opou uparxoun oloi oi parametroi

      bsince=$6

      fename=$4

      buntil=$2
 elif [ "$3" == "--born-since" ] && [ "$1" == "--born-until" ] ; then
     
      bsince=$4

      fname=$6

      buntil=$2

 elif [ "$3" == "--born-since" ] && [ "$5" == "--born-until" ] ; then
      bsince=$4

      fname=$2
      
      buntil=$6
 
 elif [ "$5" == "--born-since" ] && [ "$3" == "--born-until" ] ; then

      bsince=$6

      fname=$2

      buntil=$4

 elif [ "$1" == "--born-since" ] && [ "$3" == "--born-until" ] ; then

      bsince=$2

      fname=$6

      buntil=$4

 elif [ "$1" == "--born-since" ] && [ "$5" == "--born-until" ]; then

      bsince=$2

      fname=$4

      buntil=$6

 fi

awk -v dateA=$bsince -v dateB=$buntil -F "|" '!/#/{if ($5 >= dateA && $5 <= dateB) print;}' $fname
#
fi

# case (F)

if ([ "$1" = "-f" ] && [ "$3" = "--browsers" ]) || ([ "$1" = "--browsers" ] && [ "$2" = "-f" ]) ; then

 if [ "$1" = "-f" ] ; then
   
   fname=$2

 else
   
   fname=$3 
 fi
awk -F "|" '!/#/ {c[$8]++} END {for (b in c) print b " " c[b]}' $fname | sort
#
fi

# case (G)

if ([ "$1" = "-f" ] && [ "$3" = "--edit" ]) || ([ "$5" = "-f" ] && [ "$1" = "--edit" ]) ; then
  if [ "$1" = "-f" ] ; then
    fname=$2

    idf=$4
 
    column=$5
    
    value=$6
  else 
    fname=$6

    idf=$2

    column=$3

    value=$4
  fi
awk -v idf=$idf -v column=$column -v value=$value -F "|" '!/#/{ OFS = "|" }{ if (idf==$1) $column=value; print}' $fname > sotos.dat && mv sotos.dat $fname
fi

#links pou me voithisan stin ektelesi tou algorithmou:
 #http://unix.stackexchange.com/
 #http://www.tldp.org/LDP/Bash-Beginners-Guide/html/                                 
 #http://www.howtogeek.com/67469/the-beginners-guide-to-shell-scripting-the-basics/
                                
                        ####    #    #    ###
                        #       ##   #    #  #
                        ###     # #  #    #   #
                        #       #  # #    #  #
                        ####    #   ##    ###
