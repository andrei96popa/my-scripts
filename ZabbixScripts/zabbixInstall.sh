#!/bin/bash
#
#########################################################
#   	                			        #							
#    Description:  Script for installing and		#
#		   autoconfiguration zabbix-agent       #
# Zabbix Version:  3.0.12				#  		        	
#         Author:  Andrei Popa 			        #
#        Created:  03/07/2018				#
#							#
#	    THIS IS SCRIPT IS VALID JUST FOR		#
#	       	   zabbix.hq.bpm.ch			#
#							#
# 	If you have another server you need		#
#	 to modify Server and ServerActive		#
#							#
#########################################################


# Variables

 Server="Server=zabbix.hq.bpmwave.ch"		 	# you can change with
 ServerActive="ServerActive=zabbix.hq.bpmwave.ch"       # IP address of zabbix
 Hostname="Hostname=`hostname -f`"			# The FQDN of machine
 file="/etc/zabbix/zabbix_agentd.conf"			# The path of zabbix installation folder (default)





# Check if script is executed by 'root' user
# else force exit

 if (( EUID != 0 )); then
    echo "[ WARN ] You must be root to run this script." 1>&2
    exit 1
 fi





#Here is a menu, is better to choose 1) because you will be sure the zabbix-agent will be configured corectly
echo "
			Options:

1)Install zabbix-agent and let the script do all

2)Remove the present zabbix-agent and let the script do all(recomanded)

3)Continue with the present zabbix version, but you must check the config after.

4)Exit
"

echo "Select a option: 1 / 2 / 3 / 4  :  "

select i in InstallandConfig Reinstall Configure Exit
do
        case $i in

	InstallandConfig)
	echo "You choose $i !"
	echo "----------------------------------"
	tput setaf 6
	     if service --status-all | grep zabbix-agent 1> /dev/null 2>&1;
        then
         echo "The Zabbix-agent is already installed, will start the configuration!"
        else
	 apt-get update
	 apt-get install zabbix-agent -y
	 tput sgr0
 	fi
	 break
	;;

        Reinstall)
        echo "You choose $i !"
        echo "----------------------------------"
	tput setaf 6
	    if service --status-all | grep zabbix-agent 1> /dev/null 2>&1;
        then
         echo "The Zabbix-agent is already installed and will be removed!"
        else
         echo "The zabbix-agent is not installed!"
	 exit 1
        fi
	tput sgr0	
	apt purge zabbix-agent -y
	rm -r /etc/zabbix
	tput setaf 1
	echo "Zabbix-agent was totally removed!"
	tput sgr0
	tput setaf 6
	apt-get update
	apt-get install zabbix-agent -y
	tput sgr0
	break
        ;;

        Configure)
        echo "You choose $i !"
        echo "----------------------------------"
	tput setaf 6
	 if service --status-all | grep zabbix-agent 1> /dev/null 2>&1;
 	then
         echo "The Zabbix-agent is already installed!"
 	else
         echo "The zabbix-agent is not installed!"
	 exit 1
 	fi
	tput sgr0
	break
        ;;

        Exit)
        echo "Goodbye"
        exit 1
        ;;

        *)
        echo "Please select a valid solution !"
        ;;

        esac
done





# Check if zabbix-agent is configured and if it is, force exit
# Else start configuration

var=`grep -e ${Server} -e ${ServerActive} -e ${Hostname} ${file} -c` 

tput setaf 3
if [ "$var" -eq "4" ];# 1< /dev/null 1>&2;
then
    echo "Zabbix-agent was configured on this machine!"
    echo "
	  Check if the values are the same!
	 "
    tput setaf 123
    echo "That are values from config:"
    cat /etc/zabbix/zabbix_agentd.conf | grep -v "#" | grep -v -e '^$' | grep -e Server -e Hostname
    tput sgr0

    echo "$(tput setaf 2)"" 
	  That are values that must be in config:
Server must be: ${Server}
ServerActive must be: ${ServerActive}
Hostname must be: ${Hostname}
      	"

    tput sgr0
    exit 1
fi
tput sgr0





# Stop zabbix-agent for configuration

systemctl stop zabbix-agent.service





# If exist a backup copy, don't make another one, else
# Create a backup copy

tput setaf 5
if ls /etc/zabbix/zabbix_agentd.conf.bkp* 1> /dev/null 2>&1;
then
        echo "The Backup file exist!"
else
        cat /etc/zabbix/zabbix_agentd.conf >> /etc/zabbix/zabbix_agentd.conf.bkp.$(date +%F.%R)
        echo "The Backup file was created!"
fi
tput sgr0





# Configure the zabbix.conf

sed -i "s/Server=127.0.0.1/${Server}/g"  /etc/zabbix/zabbix_agentd.conf
sed -i "s/ServerActive=127.0.0.1/${ServerActive}/g"  /etc/zabbix/zabbix_agentd.conf
sed -i "s/Hostname=Zabbix server/${Hostname}/g"  /etc/zabbix/zabbix_agentd.conf





# Check if the variables are corectly

echo "Check if the values are the same!"

echo "That are values from config:"

tput setaf 123
cat /etc/zabbix/zabbix_agentd.conf | grep -v "#" | grep -v -e '^$' | grep -e Server -e Hostname
tput sgr0

echo "$(tput setaf 2)""
      That are values that must be in config:

Server must be: ${Server}
ServerActive must be: ${ServerActive}
Hostname must be: ${Hostname}
     "$(tput sgr0)""





# Start zabbix-agent

systemctl start zabbix-agent.service
systemctl status zabbix-agent.service

# Happy end



