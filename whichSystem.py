#!/usr/bin/env python3

import subprocess, re, sys, signal

# \\ Metemos los colores dentro de una clase
class Colored:
    red = "\u001b[0;31m"
    green = "\u001b[0;32m"
    yellow = "\u001b[0;33m"
    blue = "\u001b[0;34m"
    magenta = "\u001b[0;35m"
    cyan = "\u001b[0;36m"
    white = "\u001b[0;37m"
    underline = "\u001b[4m"
    bold = "\u001b[1m"
    inverse = "\u001b[7m"
    end = "\u001b[0m"

def handler(signal, frame):
    print(f"\n{Colored.red}[!] Saliendo...\n\n")
    sys.exit(1)

# \\ Ctrl + C
signal.signal(signal.SIGINT, handler) # \\ trap handler INT

try:
    ip = sys.argv[1]
    comando = f'/usr/bin/ping -c 1 {sys.argv[1]}'

    match = r'ttl=\d{1,3}'
    output = subprocess.run(comando, capture_output=True, shell=True)

    output = output.stdout.decode('utf-8')
    ttl = re.findall(match, output)
    ttl = str(ttl)
    ttl = re.findall(r'\d{1,3}', ttl)
    ttl = int(ttl[0])

    # \\ Conversion de la IP
    
    ip = re.findall(r'(\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3})', output)
    ip = ip[0]

    # \\ Validamos 

    if ttl >= 0 and ttl <= 64:
        print(f"\n\n{Colored.cyan}[+] {Colored.magenta}{ip}{Colored.white} (ttl -> {ttl}):{Colored.green} Linux\n") # \\ 1.1.1.1 (ttl -> 55): Linux
    elif ttl >= 65 and ttl <= 128:
        print(f"\n\n{Colored.cyan}[+] {Colored.magenta}{ip}{Colored.white} (ttl -> {ttl}):{Colored.green} Windows\n") # \\ 8.8.8.8 (ttl -> 114): Windows
    else:
        print(f"\n\n{Colored.red}[!] {ip} (ttl -> {ttl}): Not found\n")
        sys.exit(1)

except IndexError as argv_err:
    print(f"\n\n{Colored.green}[+]{Colored.white} Uso: {Colored.magenta}{sys.argv[0]}{Colored.white}: <IP_ADRESS>\n")
except subprocess.SubprocessError as sub_err:
    print(f"\n\n{Colored.red}[!] Error ocurrido: {sub_err}\n")

