#!/bin/bash
#save as .sh file
# to execute file in unix: ./name
# no .sh needed
#argrujci; Grujicic Aleksa; 500969648; 08
#z2amla; Amla Zaiba; 500943055; 08

seed=$(head -n 1 testInput)
echo $seed
#Imports test file
value=$(<testInput)
#This prints the matrix with NO SEED
arry1=$"L  I  N  U  X"
arry2="$(tail -n +2 testInput)"

#function to check if the board is inputed incorrectly 
inputCheck () {
    if [ ! -f "$testInput" ]; then
        echo "input file missing or unreadable" >&2
        exit 1
    fi
    lineCount=$(wc -l < $1)

    if ! [ "$lineCount" -eq 5 ]#SWITCH TO -EQ 6 IN THE ACTUAL SUBMISSION, CHECK IN MOON 
    then
        echo "input file must have 6 lines">&2
        exit 2
    
    fi
    #Checks every char in seed against re (numbers 0-9)
    for (( i=0; i<${#seed}; i++ )); do
    re='^[0-9]+$'
    if ! [[ "${seed:$i:1}" =~ $re ]]; then
        echo "seed line is incorrect (contains one or more non-digit characters)">&2
        exit 3
        fi
    done
    #exit 4 = card has incorrect layout and/or number(s):
}

used_numbers=() #stores all previously rolled values to avoid rolling the same number twice 
#function to pick a random, non-dupe integer from given array
pickRandom () {
    rolled_number=${vals[RANDOM%${#vals[@]}]}
    if [[ " ${used_numbers[*]} " =~ " ${rolled_number} " ]]; #if used_numbers already contains rolled_num, roll again
    then
        pickRandom 
    else #else, add this newly rolled number to used_numbers, that way it cant be rolled again 
        used_numbers+=($rolled_number)
    fi
}

#function to display the rolled number to the user with its coresponding letter
display_Num () {
    if [ "$1" -le 15 ]
    then
        leadingChar="L"
    fi
    if [ "$1" -ge 16 -a "$1" -le 30 ]
    then
        leadingChar="I"
    fi
    if [ "$1" -ge 31 -a "$1" -le 45 ]
    then
        leadingChar="N"
    fi
    if [ "$1" -ge 46 -a "$1" -le 60 ]
    then
        leadingChar="U"
    fi
    if [ "$1" -ge 61 -a "$1" -le 75 ]
    then
        leadingChar="X"
    fi
    echo "$leadingChar$1"
    call_card+="$leadingChar$1 "
}
sed -i "s/00/00m/" testInput
#function to display the current board the the user
display_board () {
    filename=testInput
    MARKED=m
    search=$rolled_number 
    replace=$rolled_number$MARKED
    if [[ $search != "" && $replace != "" ]]; then
        sed -i "s/$search/$replace/" $filename
    fi
    value=$(<testInput)
    #This prints the matrix with NO SEED
    arry1=$"L  I  N  U  X"
    arry2="$(tail -n +2 testInput)"
    #To have LINUX board 
    n=${#arry1[@]}
    for (( i=0; i<n; i++ )); do
        DISPLAY_NAME[$i]=${arry1[$i]}"\n"${arry2[$i]}
        printf "%b\n" "${DISPLAY_NAME[$i]}\n"
    done
        MARKED=m
        markedNum="$rolled_number$MARKED"
        DISPLAY_NAME="${DISPLAY_NAME/$rolled_number/"$markedNum"}"  
}
#Function to check if the user won by a complete row by counting the number of Ms in each row. 
checkRowWin () {
    rowNum=2
    count=0
    for j in {1..6..1} 
        do
        testing=$(sed "${rowNum}q;d" testInput)
        comp=$(echo "$testing" | sed 's/ //g')
        for (( i=0; i<${#comp}; i++ )); do
            re='^[0-9]+$'
            if ! [[ "${comp:$i:1}" =~ $re ]]; then
                let count++
                fi
        done
        if [ "$count" -eq 5 ];
        then
            echo "winner by row">&2
            exit 6
        fi
        count=0
        let rowNum++
done
}
vals=($(seq -s " " -w 01 75))
#inputCheck

RANDOM=seed #before $RANDOM is set equal to seed, seed needs to be checked against boardCheck to make sure its a proper number 

for i in ${!vals[@]} ##main loop for the game potentially 
do
    printf "%b\n" "Call card is currently : ${call_card[@]}\n"
    display_board 
    pickRandom 
    display_Num "$rolled_number" 

    read -n1 -s -r -p $'Press any key to continue... q to quit\n' key 
    if [ "$key" = 'q' ]; then
        printf '\nThanks for playing!\n'
        exit 0
    else
        checkRowWin
        printf "\033c"
        printf "Something else pressed: \n" #continue program    
    fi  
done 

echo "Rolled Every single Number">&2
exit 5