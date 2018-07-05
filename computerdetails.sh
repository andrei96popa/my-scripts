#!/bin/bash



#System Data

function fDomain(){
	domainname
}

function fHostname() {
	hostname
}

function ffqdn(){
	hostname -f
}

function ipaddress(){
	hostname -I | cut -f 1 -d ' '
}

function fos(){
	uname -o
}

function fkernel(){
	uname -r
}

function fuptime(){
	uptime -p | cut -f 2- -d ' '
}

function flastreboot(){
	uptime -s
}


#Resource Data

function fla(){
	 uptime | cut -f 4 -d ':'
}

function fcpucores(){
	nproc	
}

function fmemorie1(){
	free -m | awk 'FNR == 2 {print $3}' 
}

function fmemorie2(){
	free -m | awk 'FNR == 2 {print $2}' 
}

function fswap1(){
	free -m | awk 'FNR == 3 {print $3}'
}

function fswap2(){
	free -m | awk 'FNR == 3 {print $2}'
}

#User Data

function fcurrentuser(){
	whoami
}

function fhowmany(){
	w -h | wc -l
}

function fprocese(){
	ps -aux | wc -l
}

function fprocesmax(){
	cat /proc/sys/kernel/pid_max
}






echo "	"$(tput setaf 3)"
===========================: System Data :================================="$(tput setaf 1)"
 -- Hostname...............: $(fHostname)
 -- Domain.................: $(fDomain) 
 -- F.Q.D.N................: `ffqdn` 
 -- IP Address.............: `ipaddress` 
 -- OS.....................: `fos`
 -- Kernel.................: `fkernel` 
 -- System uptime..........: $(fuptime) 
 -- Last reboot time.......: `flastreboot` "$(tput setaf 3)"
 ===========================: Resource Data :==============================="$(tput setaf 4)"
 -- Load averages..........: `fla` - (1, 5, 15 min)
 -- CPU Cores..............: `fcpucores` 
 -- Memory.................: Used `fmemorie1` MB out of `fmemorie2` MB 
 -- Swap...................: Used `fswap1` MB out of `fswap2` MB"$(tput setaf 3)"
 ===========================: User Data :==================================="$(tput setaf 2)"
 -- Current username.......: `fcurrentuser`
 -- Logged in users........: There are currently `fhowmany` user(s) logged in
 -- Processes..............: `fprocese` of `fprocesmax` MAX "$(tput setaf 3)"
 =========================================================================== "$(tput sgr0)"
"
