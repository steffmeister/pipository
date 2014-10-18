# check whether whiptail or dialog is installed
read dialog <<< "$(which whiptail dialog 2> /dev/null)"

# exit if none found
[[ "$dialog" ]] || {
  echo 'neither whiptail nor dialog found' >&2
  exit 1
}

echo "using $dialog..."

TFILE="gpiowizard.$$.tmp"
answer="2"

"$dialog" --msgbox "Welcome to GPIO Wizard! Please be careful. Only use this on Raspberry Pi B or B+!" 0 0

function mainmenue {
	"$dialog" --title "GPIO Wizard" --default-item="$answer" --menu "Select the desired GPIO" 26 78 17 \
	"2" "GPIO2 / Pin 3" \
	"3" "GPIO3 / Pin 5" \
	"4" "GPIO4 / Pin 7" \
	"7" "GPIO7 / Pin 26" \
	"8" "GPIO8 / Pin 24" \
	"9" "GPIO9 / Pin 21" \
	"10" "GPIO10 / Pin 19" \
	"11" "GPIO11 / Pin 23" \
	"14" "GPIO14 / Pin 8" \
	"15" "GPIO15 / Pin 10" \
	"17" "GPIO17 / Pin 11" \
	"18" "GPIO18 / Pin 12" \
	"22" "GPIO22 / Pin 15" \
	"23" "GPIO23 / Pin 16" \
	"24" "GPIO24 / Pin 18" \
	"25" "GPIO25 / Pin 22" \
	"27" "GPIO27 / Pin 13" 2>$TFILE
}

function gpiomenue {
	DIRECTION=$(check_in_out $1)
	"$dialog" --title "GPIO$1" --menu "Select an option" 14 78 5 \
	"1" "Toggle direction (current: $DIRECTION)" 2>$TFILE
}

function check_in_out {
	GPIO_DIRECTION="/sys/class/gpio/gpio$1/direction"
#	echo $GPIO_DIRECTION
	if [ -e $GPIO_DIRECTION ]; then
		echo $(<$GPIO_DIRECTION)
	else
		echo "-1"
	fi
}

function check_if_activated {
	GPIO_DIR="/sys/class/gpio/gpio$1"
	if [ -d $GPIO_DIR ]; then
		echo "1"
	else
		echo "0"
	fi
}

quit=0
while [ $quit -ne 1 ]
do
	mainmenue
	answer=$(<$TFILE)
#	echo "answer=$answer"
	if [ -z $answer ]; then
		quit=1
	else
		activated=$(check_if_activated $answer)
		if [ $activated == "0" ]; then
			whiptail --yesno "GPIO$answer is not activated. Do you want to activate it?" 0 0
			ACTIVATEYESNO=$?
			# 0 = yes, 1 = no
			if [ $ACTIVATEYESNO == "0" ]; then
				echo $answer > /sys/class/gpio/export
				activated=$(check_if_activated $answer)
			fi
		fi
		
		
		if [ $activated == "1" ]; then
			quit_gpiomenue=0
			while [ $quit_gpiomenue -ne 1 ]
			do
				gpiomenue $answer
				gpioanswer=$(<$TFILE)
				if [ -z $gpioanswer ]; then
					quit_gpiomenue=1
				else
					# 1 = toggle
					if [ $gpioanswer == "1" ]; then
						CURRENTDIRECTION=$(check_in_out $answer)
						case "$CURRENTDIRECTION" in
							in) echo "out" > "/sys/class/gpio/gpio$answer/direction"
								;;
							out) echo "in" > "/sys/class/gpio/gpio$answer/direction"
								;;
						esac
					# 2 = set to high (1)
					elif [ $gpioanswer == "2" ]; then
						echo "1" > "/sys/class/gpio/gpio$answer/direction"
					# 3 = set to low (0)
					elif [ $gpioanswer == "3" ]; then
						echo "0" > "/sys/class/gpio/gpio$answer/direction"
					fi
				fi
			done
		fi
		
	fi
	
done


rm "$TFILE"
