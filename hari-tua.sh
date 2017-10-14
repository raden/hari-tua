#!/bin/bash
#Written by Muhammad Najmi Ahmad Zabidi <najmi.zabidi@gmail.com>, Oct 2017

PROGNAME=`basename $0`

usage() {
    echo "Usage:"
    echo " $PROGNAME -u <umur mula> -r <umur pencen> -k <komitmen> -d dividen " 
    echo " Contoh  - $PROGNAME -u 30 -r 55 -k 200 -d 8"
    exit 3
}

while getopts ":u:r:k:d:" opt; do 
  case $opt in
    u)
     umur_mula=$OPTARG
      ;;      
    r)
     umur_pencen=$OPTARG
      ;;	
    k)
     komitmen=$OPTARG 
     ;;      
    d)
     dividen_tahunan=$OPTARG
     ;;
    h)
      usage
     ;;
    :)
      echo "Opsyen -$OPTARG perlukan argumen." >&2
      echo ""
      exit 3  
    ;;      
  esac
done

if [ "$#" -eq 0 ]; then
        usage
        exit 3

fi

DIVIDEN=$(echo "scale=2;($dividen_tahunan/100)"|bc)
KOMITMEN_SETAHUN=$(echo "$komitmen*12"|bc)

kira_tahun() {

for ((tempoh=$umur_mula; tempoh<=$umur_pencen; tempoh++)); 

do


if [[ $tempoh -eq $umur_mula ]]; then
	dividen_tahunan[$tempoh]=$(echo "scale=2;$komitmen*12*$DIVIDEN"|bc)
	simpanan_tahunan[$tempoh]=$(echo "scale=2;($komitmen*12)+${dividen_tahunan[$tempoh]}"|bc)

        printf "\t $tempoh\t $komitmen\t\t$KOMITMEN_SETAHUN\t\t 0\t\t\t $KOMITMEN_SETAHUN \t\t ${simpanan_tahunan[tempoh]}\t${dividen_tahunan[$tempoh]} "
	printf "\n"

elif [[ $tempoh -gt $umur_mula ]]; then

	SIMPANAN_BERDIVIDEN=$(echo "${simpanan_tahunan[$tempoh-1]}+($komitmen*12)"|bc)
	dividen_tahunan[$tempoh]=$(echo "scale=2;(${simpanan_tahunan[$tempoh-1]}+($komitmen*12))*$DIVIDEN"|bc)
	simpanan_tahunan[$tempoh]=$(echo "scale=2;${simpanan_tahunan[$tempoh-1]}+($komitmen*12)+${dividen_tahunan[$tempoh]}"|bc)

        printf "\t $tempoh \t $komitmen \t\t$KOMITMEN_SETAHUN\t\t ${simpanan_tahunan[$tempoh-1]}\t\t $SIMPANAN_BERDIVIDEN \t ${simpanan_tahunan[$tempoh]}\t${dividen_tahunan[$tempoh]} "
	printf "\n"

else
	echo "Kena check balik..ada benda tak betul"
	echo ""

fi
done

}


echo '------------------------------------------------------------------------------------------------------------------------------'
printf "\tTAHUN\tK.BULANAN\tK.TAHUNAN\tSIMP AWAL\tSIMP+KOMITMEN/TAHUN\tSIMP+DIVIDEN\tDIVIDEN\n"
echo '------------------------------------------------------------------------------------------------------------------------------'

	kira_tahun

echo ""
