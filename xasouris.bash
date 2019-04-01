#!/bin/bash
 
#Xasouris-Xristidis Kwnstantinos 5684
 
if [ ! -n "$1" ]; then
echo "5684"
fi
 
 
#A
if [ "$1" = "-f" ] && [ ! -n "$3" ] ;  then #elegxos parametrwn
awk '!/#/{print;}' $2 #ektupwsh olou tou arxeiou ektos twn sxoliwn dhladh twn grammwn pou xekinoun me #
fi
 
#B
if ([ "$1" = "-f" ] || [ "$3" = "-f" ]) && ([ "$1" = "-id" ] || [ "$3" = "-id" ] ) && [ ! -n "$5" ]; then
    if [ "$1" = "-f" ]; then #elegxos etsi wste na mhn exoume problhma me to pws tha mpoune oi parametroi
        filename=$2 #thetw to arxeio sth metablhth filename
        idV=$4 #thetw ton arithmo tou id sth metablhth idV
    else
        filename=$4
        idV=$2
    fi
awk -v idv=$idV -F "|" '!/#/{if (idv == $1) print $2 " " $3 " " $5}' $filename #thetw thn metablhth idv=idV , thewroume allagh lekshs to sumbolo |,den lambanoume upopshn ta sxolia, elegxoume to id ths grammhs an einai idio me to zhtoume kai ekthpwnoume tis 2, 3, 5 steiles  me kena metaxi tous
fi
 
#C
if ( [ "$1" == "-f" ] || [ "$2" == "-f" ]  ) && ( [ "$1" == "--firstnames" ] || [ "$3" == "--firstnames" ] ); then #elegxos etsi wste na mhn exoume problhma me to pws tha mpoune oi parametroi
    if [ "$1" == "-f" ]; then
        filename=$2
    else
        filename=$3
    fi
awk -F "|" '!/#/{print $2}' $filename | sort | uniq #thewroume allagh lekshs to sumbolo |,den lambanoume upopshn ta sxolia, kai ektupwnoume thn deuterh sthlh tou arxiou me alfabhtikh seira kai kathe onoma emfanizetai mia fora
fi
 
 
#D
if ( [ "$1" == "-f" ] || [ "$2" == "-f" ] ) && ( [ "$1" == "--lastnames" ] || [ "$3" == "--lastnames" ] ); then
    if [ "$1" == "-f" ]; then #elegxos etsi wste na mhn exoume problhma me to pws tha mpoune oi parametroi
        filename=$2
    else
        filename=$3
    fi
awk -F "|" '!/#/{print $3}' $filename | sort | uniq #thewroume allagh lekshs to sumbolo |,den lambanoume upopshn ta sxolia, kai ektupwnoume thn deuterh sthlh tou arxiou me alfabhtikh seira kai kathe onoma emfanizetai mia fora
fi
 
#E
if ( [ "$1" == "-f" ] || [ "$3" == "-f" ] || [ "$5" == "-f" ] ) && ( [ "$1" == "--born-since" ] || [ "$3" == "--born-since" ] || [ "$5" == "--born-since" ] || [ "$1" == "--born-until" ] || [ "$3" == "--born-until" ] || [ "$5" == "--born-until" ] ); then  #elegxos etsi wste na mhn exoume problhma me to pws tha mpoune oi parametroi
    if [ ! -n "$5" ] && [ "$1" == "--born-since" ]; then #periptwsh opou h parametros --born-until leipei
        bornsince=$2
        filename=$4
        bornuntil=$(date +'%Y-%m-%d') #efoswn den exoume parametro born-until koitame gia hmeromhnies apo thn parametro born-since mexri kai shmera
    elif [ ! -n "$5" ] && [ "$3" == "--born-since" ]; then #periptwsh opou h parametros --born-until leipei
        bornsince=$4
        filename=$2
        bornuntil=$(date +'%Y-%m-%d') #efoswn den exoume parametro born-until koitame gia hmeromhnies apo thn parametro born-since mexri kai shmera
    elif [ ! -n "$5" ] && [ "$1" == "--born-until" ]; then #periptwsh opou h parametros --born-since leipei
        bornsince=$(date -d 19020101 +'%Y-%m-%d') #efoswn den exoume parametro born-since koitame gia hmeromhnies apo mia arketa palia hmeromhnia mexri kai thn parametro born-until 
        filename=$4
        bornuntil=$2
    elif [ ! -n "$5" ] && [ "$3" == "--born-until" ]; then #periptwsh opou h parametros --born-since leipei
        bornsince=$(date -d 19020101 +'%Y-%m-%d') #efoswn den exoume parametro born-since koitame gia hmeromhnies apo mia arketa palia hmeromhnia mexri kai thn parametro born-until
        filename=$2
        bornuntil=$4
    elif [ "$5" == "--born-since" ] && [ "$1" == "--born-until" ]; then #periptwseis opou uparxoun oloi oi parametroi
        bornsince=$6
        filename=$4
        bornuntil=$2
    elif [ "$3" == "--born-since" ] && [ "$1" == "--born-until" ]; then
        bornsince=$4
        filename=$6
        bornuntil=$2
    elif [ "$3" == "--born-since" ] && [ "$5" == "--born-until" ]; then
        bornsince=$4
        filename=$2
        bornuntil=$6
    elif [ "$5" == "--born-since" ] && [ "$3" == "--born-until" ]; then
        bornsince=$6
        filename=$2
        bornuntil=$4
    elif [ "$1" == "--born-since" ] && [ "$3" == "--born-until" ]; then
        bornsince=$2
        filename=$6
        bornuntil=$4
    elif [ "$1" == "--born-since" ] && [ "$5" == "--born-until" ]; then
        bornsince=$2
        filename=$4
        bornuntil=$6
    fi
awk -v dateA=$bornsince -v dateB=$bornuntil -F "|" '!/#/{if ($5 >= dateA && $5<=dateB) print;}' $filename
#thetw tis metablhtes dateA=bornsince dateB=bornuntil  , thewroume allagh lekshs to sumbolo |,den lambanoume upopshn ta sxolia, elegxoume poies hmeromhnies einaianamesa twn metablhtwn dateA kai dateB kai ektuponoume olklhrh thn grammh 
fi
 
#F
if ( [ "$1" == "-f" ] || [ "$2" == "-f" ] ) && ( [ "$1" == "--browsers" ] || [ "$3" == "--browsers" ] ); then
    if [ "$1" == "-f" ]; then #elegxos etsi wste na mhn exoume problhma me to pws tha mpoune oi parametroi
        filename=$2
    else
        filename=$3
    fi
awk -F "|" '!/#/ {c[$8]++} END {for (b in c) print b " " c[b]}' $filename | sort #thewroume allagh lekshs to sumbolo |,den lambanoume upopshn ta sxolia, dhmiourgoume enan pinaka c opou metraei poses fores exei emfanistei o kathe browser, afou trexei to arxeio ektupwnoume me alfabitikh seira to onoma tou browser kai poses fores emfanistike sto arxeio me ena keno metaxi tous
fi
 
 
#G 
if  ( [ "$1" = "-f" ] || [ "$5" = "-f" ] ) && ( [ "$1" = "--edit" ] || [ "$3" = "--edit" ] ) && ( [ "$5" != "1" ] && [ "$3" != "1" ] ); then #elegxos etsi wste na mhn exoume problhma me to pws tha mpoune oi parametroi kai na mhn mporei na allaksei h sthlh tou id
    if [ "$1" == "-f" ]; then
        filename=$2
        idV=$4
        columV=$5
        valueV=$6
    else
        filename=$6
        idV=$2
        columV=$3
        valueV=$4
    fi
awk -v idv=$idV -v colum=$columV -v val=$valueV -F "|" '!/#/{OFS = "|" }{if (idv==$1) $colum=val; print}' $filename > proxeiro.dat &&
mv proxeiro.dat $filename
#thetw tis metablhtes idv=idV, colum=columV kai val=valueV, thewroume allagh lekshs to sumbolo |,den lambanoume upopshn ta sxolia,elegxoume ta id kai kanoume tis katalhles allages,me to OFS kanoume to programma kathos dhmourgei to kainourgio keimeno na xreishmopoiei to shmbolo | anti gia to eno gia allagh lexis, antikahistoume to arxiko keimeno me to allagmeno
fi