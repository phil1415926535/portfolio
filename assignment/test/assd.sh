#!/bin/bash

# Set variables
loc="./data_files"
dl_loc_html="https://cve.mitre.org/data/downloads/allitems.html"
menu="./script_files/menu.sh"
mkstrs="./script_files/makestars.sh"

## FG Colours
red="\033[31m" # text red
grn="\033[32m" # text green
ylw="\033[33m" # text yellow
dfc="\033[39m" # default text colour

## BG Colors
dkgry="\033[100m" # dark grey background
dfbkg="\033[49m" # default background colour

bold="\033[1m" # bold text
offb="\033[21m" # turn off bold
dim="\033[2m" # dim the text
blink="\033[5m"
offbl="\033[25m"
off="\033[0m" # reset all attributes

slp="sleep 0.05"
slp05="sleep 0.5"
slp1="sleep 0.1"
slp1s="sleep 1"
slp2s="sleep 2"
slp3s="sleep 3"

dateh=$(date +%H)
datem=$(date +%M)

# Option 2 Variables
thisdate=$(awk '(/Created Date:/) { print $3 }' $loc/CVEfile.txt) # to check the date the created/converted text file was created

# FUNCTIONS
intro_func()
{
    echo -e $bold$ylw
    $mkstrs 80 0
    echo
    printf "%s\n"  "This script can download the full list of CVE Vulnerabilities from the website:" "https://cve.mitre.org/data/downloads/" "Please ensure you have at least 400MB of space to run all the features of this script"
    echo
    $mkstrs 80 0.01
    echo
    echo -e $dim$grn
    read -p "Press ENTER key to continue..."
    echo -e $off
}

menu()
{
    echo
    echo -e "$dkgry$ylw$bold***************************** $red!!! OPTIONS !!!$dfc $ylw*******************************"
    $slp
    echo -e "$dkgry$ylw$bold***************************** $red!!!  $dateh$blink:$offbl$datem  !!!$dfc $ylw*******************************"
    $slp
    echo -e "*****                                                                   *****"
    $slp
    echo -e "*****$grn 1. Initial download or update to latest complete CVE list         $ylw*****"
    $slp
    echo -e "*****$grn 2. Convert downloaded html file into text file                    $ylw*****"
    $slp    
    echo -e "*****$grn 3. Number of CVE's per year                                       $ylw*****"
    $slp
    echo -e "*****$grn 4. Create CSV file from full CVEfile.txt                          $ylw*****"
    $slp
    echo -e "*****$grn 5. ***AnOtHeR_oPtIoN***                                           $ylw*****"    
    $slp
    echo -e "*****$grn 6. ***AnOtHeR_oPtIoN***                                           $ylw*****"
    $slp
    echo -e "*****$grn 7. Delete downloaded / created files                              $ylw*****"
    $slp
    echo -e "*****$grn 8. Exit program                                                   $ylw*****"
    $slp
    echo -e "*****                                                                   *****"
    $slp
    echo -e "*****************************************************************************"
    echo -e "$off"
}

option_one()
{
    if [[ $1 == 1 || $1 = "one" ]];
    then
    echo "Verifying if download location exists"
        if [[ -d "$loc" ]];
        then
            echo "Directory verification success, continuing... "
        else
            echo "Not exists ... Making directory... "
            sleep 1
            mkdir $loc
            if [ $? == 0 ];
            then 
                echo "Location successfully created, continuing... "
            else
                echo "Problem creating directory, maybe try creating it manually and retry running program, or delete existing files (option 7) and try again"
                read -p "Do you want to open a terminal to locate problem? " Answer
                case $Answer in
                [yY] | [yY][eE][sS] )
                gnome-terminal --working-directory=~
                ;;
                [nN] | [nN][oO] )
                exit 1
                ;;
                *) # default case
                exit 1
                ;;
                esac
            fi
        fi
        sleep 1

    echo "Verification of up to date files and downloading if required"

    # -S if file doesnt exist downloads initial version
    # -N checks file version of existing file and checks for newer version and only downloads if newer version exists
    # downloads html file full list of CVE items
    echo -e "\033[32;100;1m"
    wget -c -SN --output-file=$loc/log_html.txt --show-progress --progress=bar -P $loc $dl_loc_html
    echo -e "DONE!"
    echo -e "$off"
    read -p "Press ENTER to continue back to menu"
fi
return 0
}

option_two()
{
    if [[ ! -f $loc/CVEfile.txt ]];
    then
        printf "%s\n" 'The downloaded allitems html file is now having its formatting removed and being converted into a text file' 'Please be patient as this may take a minute or two'
        sed -e 's/<[^>]*>//g' $loc/allitems.html | sed -e 's/Name:/\n======================================================\n======================================================\nName:/' | sed -n '/======================================================/,/Back to top/ p' | sed "1s/^/Created Date: $(date +%Y%m%d)\n/" | sed "s/Back to top/======================================================\nEND/" | sed 's/(&lt\;br&gt\;|&gt|&amp\;|\,)//g' > $loc/CVEfile.txt
        #sed -e 's/<[^>]*>//g' $loc/allitems.html | sed -e 's/Name:/\n======================================================\n======================================================\nName:/' | sed -n '/======================================================/,/Back to top/ p' | sed "1s/^/Created Date: $(date +%Y%m%d)\n/" | sed "s/Back to top/======================================================\nEND/" | sed 's/&lt\;br&gt\;//g' | sed 's/&gt//g' | sed "s/&amp\;/ /g" | sed 's/\,//g' > $loc/CVEfile.txt
    
    else 
        echo "This file exists already, and was converted on $thisdate"
        read -p "Are you sure you want to over-write (y/n): " owtxt
        if [[ $owtxt == y ]];
        then
            printf "%s\n" 'The downloaded allitems html file is now having its formatting removed and being converted into a text file' 'Please be patient as this may take a minute or two'
            sed -e 's/<[^>]*>//g' $loc/allitems.html | sed -e 's/Name:/\n======================================================\n======================================================\nName:/' | sed -n '/======================================================/,/Back to top/ p' | sed "1s/^/Created Date: $(date +%Y%m%d)\n/" | sed "s/Back to top/======================================================\nEND/" | sed 's/(&lt\;br&gt\;|&gt|&amp\;|\,)//g' > $loc/CVEfile.txt
            #sed -e 's/<[^>]*>//g' $loc/allitems.html | sed -e 's/Name:/\n======================================================\n======================================================\nName:/' | sed -n '/======================================================/,/Back to top/ p' | sed "1s/^/Created Date: $(date +%Y%m%d)\n/" | sed "s/Back to top/======================================================\nEND/" | sed 's/&lt\;br&gt\;//g' | sed 's/&gt//g' | sed "s/&amp\;/ /g" | sed 's/\,//g' > $loc/CVEfile.txt    
        fi
    fi

echo -e "Done! Back to menu"
$slp1s
}

option_three()
{
    while true; do

    printf "%s\n" "This will print the number per year of CVE listed in the documentation" "Valid years are from 1999 to Current year" "Type each year with a single space between each - eg: 1999 2010"
    read -p ": " cveyears
    
    if [[ $cveyears == exit ]]; 
    then 
        break
    fi

    rm -f $loc/CVEyears.txt
            
    for i in $cveyears
    do
        grep -cE "^Name: CVE-$i" $loc/CVEfile.txt | sed "s/^/$i,/" >> $loc/CVEyears.txt
    done
    
    echo
    echo
    echo -e $grn$bold"The Number of CVE's reported for years $cveyears: $off"
    awk 'BEGIN {
        FS=",";
        print "@@@@@@@@@@@@@@@@@@@@@@@@@@";
        print "@@@        |           @@@";
        print "@@@ \033[31;1mYear\033[0m   | \033[31;1m# of CVEs\033[0m @@@";
        print "@@@________|___________@@@";
    }
    {
        printf("@@@ \033[33m%-6s\033[0m | \033[35m%-9s\033[0m @@@\n", $1, $2);
    }
    END {
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@");
    }' $loc/CVEyears.txt

    echo 
    echo

    read -p "Save this data to CSV file?(y/n): " other
    if [[ $other == y ]];
    then
        read -p "Enter Directory Location to save the file: " dirloc
        if [[ -d "$dirloc" ]];
            then
                echo "Directory verification success, continuing... "
            else
                echo "Not exists ... Making directory... "
                mkdir $dirloc
                if [ $? == 0 ];
                then 
                    echo "Location successfully created, continuing... "
                else
                    echo "Problem creating directory, maybe try creating it manually and retry running program, or delete existing files (option 7) and try again"
                    read -p "Do you want to open a terminal to locate problem? " Answer
                    case $Answer in
                    [yY] | [yY][eE][sS] )
                    gnome-terminal --working-directory=~
                    ;;
                    [nN] | [nN][oO] )
                    exit 1
                    ;;
                    *) # default case
                    exit 1
                    ;;
                    esac
                fi
        fi
        sed -i "1s/^/\"Name\",\"Year\"\n/" $loc/CVEyears.txt
        cp $loc/CVEyears.txt $dirloc
        echo -e "$grn File saved to $dirloc $off"
        read -p "Press ENTER to go back to main menu"
        $slp1s
        break
    else
        break
    fi
    done
}

option_four()
{
    echo -e "A CSV file CVEfile.csv will be created from text file CVEfile.txt"
    read -p "Press enter to continue or type exit: " csvcreate
    
    if [[ $csvcreate == exit ]]; then break; fi

    sed 's/Reference:/ \| /' $loc/CVEfile.txt | sed -Ee ':a $!N;s/\n(Description:|Status:|Phase:)/,/;ta P;D' | sed -Ee ':a $!N;s/\n \| / \| /;ta P;D' | sed -Ee '/./s/ \| /,/' | grep -E "Name:" | sed 's/Name: //' | sed '1s/^/\"Name\",\"Description\",\"Phase\",\"Status\",\"Reference\"\n/' > $loc/CVEfile.csv

    echo -e "$grn Done! File CVEfile.csv can be located in the $loc directory $off"
    read -p "Press ENTER to go back to the main menu"

}


option_five()
{
    sed -i "1s/^/\"Name\",\"Status\",\"Description\",\"References\",\"Phase\",\"Votes\",\"Comments\"\n/" CVEfile.txt #adds in csv column labels at start of file
}

option_seven()
{
while true; do    
    clear
    echo -e "$red$bold"
    echo -e "******$blink DELETION SUB-MENU $offbl************************************************"
    echo -e "*** 1. Delete the downloaded file allitems.html                       ***"
    echo -e "*** 2. Delete the created text file CVEfile.TXT                       ***"
    echo -e "*** 3. Delete the wget logfile from the ./data_files directory        ***"
    echo -e "*** 4. Delete the CVEyears.TXT file from ./data_files directory       ***"
    echo -e "*** 5. Delete the CVEfile.CSV file from ./data_files directory        ***"
    echo -e "*** 6. Delete the entire data_files directory and everything in it    ***"
    echo -e "*** 7. EXIT Back to main menu                                         ***"
    echo -e "*************************************************************************"
    read -p "Choose an option: " yn
    case $yn in
    1) rm -f $loc/allitems.html
        $mkstrs 68 0.007
        echo "Done!"
        $slp1s;;
    2) rm -f $loc/CVEfile.txt
        $mkstrs 68 0.007
        echo "Done!"
        $slp1s;;
    3) rm -f $loc/log.log
        $mkstrs 68 0.007
        echo "Done!"
        $slp1s;;
    4) rm -f $loc/CVEyears.txt
        $mkstrs 68 0.007
        echo "Done!"
        $slp1s;;
    5) rm -f $loc/CVEyears.txt
        $mkstrs 68 0.007
        echo "Done!"
        $slp1s;;
    6) rm -R $loc
        $mkstrs 68 0.02
        echo "Done!"
        $slp1s;;
    *) echo "Back to Main Menu!"
        break;;
    esac
done

}

option_eight ()
{
    echo "Goodbye"
    echo
    exit 0  
}

option_default()
{
    echo -e $red$bold
    printf "%s\n" "***ERROR:" "$choice" "Does not compute..." "Please try again!" " " "Example for option 5: enter numerical: 5 or text: five"
    echo -e $offb
    echo -e "\033[7m"
    read -p "Press ENTER to continue back to menu"
}


# PROGRAM STARTS HERE

clear

intro_func

# while loop to loop menu, script runs its operations in here
while true;
do

clear
$slp1
menu

echo -e "$bold$grn"
read -p "Choose an option: " choice
echo
echo -e "Implementing option number $choice"
    
$mkstrs 77 0.005
echo -e "$off"

case $choice in
    [1] | [oO][nN][eE] )
    option_one $choice
    ;;
    [2] | [tT][wW][oO] )
    option_two
    ;;
    [3] | [tT][hH][rR][eE][eE] )
    option_three  
    ;;
    [4] | [fF][oO][uU][rR] )
    option_four  
    ;;
    [5] | [fF][iI][vV][eE] )
    # function goes here    
    ;;
    [6] | [sS][iI][xX] )
    # function goes here    
    ;;
    [7] | [sS][eE][vV][eE][nN] )
    option_seven
    ;;
    [8] | [eE][iI][gG][hH][tT] | [eE][xX][iI][tT] )
    option_eight
    ;;
    *) 
    option_default
    ;;
esac



done