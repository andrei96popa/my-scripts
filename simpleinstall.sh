#!/bin/bash


# Variables

 Server="Server=zabbix.hq.bpmwave.ch"                   # you can change with
 ServerActive="ServerActive=zabbix.hq.bpmwave.ch"       # IP address of zabbix
 Hostname="Hostname=`hostname -f`"                      # The FQDN of machine
 file="/etc/zabbix/zabbix_agentd.conf"                  # The path of zabbix installation folder (default)





# Check if script is executed by 'root' user
# else force exit

 if (( EUID != 0 ));
then
    echo "[ WARN ] You must be root to run this script." 1>&2
    exit 1
fi

 apt-get update
 apt-get install zabbix-agent -y


 systemctl stop zabbix-agent.service


 if ls /etc/zabbix/zabbix_agentd.conf.bkp* 1> /dev/null 2>&1;
then
        echo "The Backup file exist!"
else
        cat /etc/zabbix/zabbix_agentd.conf >> /etc/zabbix/zabbix_agentd.conf.bkp.$(date +%F.%R)
        echo "The Backup file was created!"
fi


sed -i "s/Server=127.0.0.1/${Server}/g"  /etc/zabbix/zabbix_agentd.conf
sed -i "s/ServerActive=127.0.0.1/${ServerActive}/g"  /etc/zabbix/zabbix_agentd.conf
sed -i "s/Hostname=Zabbix server/${Hostname}/g"  /etc/zabbix/zabbix_agentd.conf

systemctl start zabbix-agent.service
systemctl status zabbix-agent.service

