#!/bin/bash

# \\ Colours
greenColour="\e[0;32m\033[1m" endColour="\033[0m\e[0m" redColour="\e[0;31m\033[1m" purpleColour="\e[0;35m\033[1m" grayColour="\e[0;37m\033[1m"

ip=$1

if [[ ! $ip ]]; then # \\ Si no le pasamos argumentos, saldremos del script
  echo -e "\n\n${redColour}[!]${endColour} ${grayColour}Uso:${endColour} ${purpleColour}$0${grayColour} <ip_address>${endColour}\n"
  exit 
fi

# \\ Variables
ttl=$(ping -c 1 $ip | grep -oP 'ttl=\d{1,3}' | cut -d '=' -f2)
ip_address=$(ping -c 1 $ip | grep -oP '(\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3})' | awk 'NR==1')

if [[ $ttl -gt 0 && $ttl -le 64 ]]; then # \\ Mayor igual a 0, menor igual a 64 -> Linux
  echo -e "\n\n${purpleColour}$ip_address${endColour} ${grayColour}(ttl -> $ttl):${endColour} ${greenColour}Linux${endColour}\n"

elif [[ $ttl -ge 65 && $ttl -le 128 ]]; then # \\ Mayor igual a 65, menor igual a 128 -> Windows
  echo -e "\n\n${purpleColour}$ip_address${endColour}${grayColour} (ttl -> $ttl):${endColour}${greenColour} Windows${endColour}\n"

else
  echo -e "\n\n${purpleColour}$ip_address ${grayColour}(ttl -> $ttl):${endColour} ${redColour}Not found.${endColour}\n" # \\ Caso contrario, de que ninguno sea verdadero

fi

