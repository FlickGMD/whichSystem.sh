#!/bin/bash
source ./Colors.sh

if [[ -z "$1" ]]; then
  echo -e "\n[+] Usage: $0 127.0.0.1\n"
  return 1
fi

function ctrl_c(){
  echo -e "\n${bright_red}[!] Deteniendo programa...${end}\n\n"
  exit 1
}

trap ctrl_c INT

IP_ADRESS="$1"


function Get_TTL(){
  IP_ADRESS="$1"

  ttl=$(/usr/bin/ping -c 1 "$IP_ADRESS" | grep -oP "ttl=\K\d{1,3}")

  if [ -z "$ttl" ]; then
    echo -e "\n${bright_red}[!] No se pudo obtener el TTL de la dirección: ${IP_ADRESS}\n${end}"
    exit 1
  fi
  
  echo "$ttl"
}

function Get_OS(){
  ttl="$1"
  
  if [[ "$ttl" -ge 1 && "$ttl" -le 64 ]]; then
    echo "Linux"
  elif [[ "$ttl" -ge 65 && "$ttl" -le 128 ]]; then
    echo "Windows"
  else
    echo "Desconocido"
  fi
}

ttl=$(Get_TTL "$IP_ADRESS")
os_System=$(Get_OS "$ttl")

echo -e "\n\n${bright_cyan}[+] ${bright_magenta}${IP_ADRESS}${bright_white} (ttl -> ${ttl}):${bright_green} $os_System${end}\n"

