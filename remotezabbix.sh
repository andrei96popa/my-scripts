#!/bin/bash

SCRIPTNAME=$(basename ${0})

echo $SCRIPTNAME

if [ $# -eq 0 ]
then
        echo "[ WARN ] No arguments"
        echo "[ INFO ] Specifie ssh username and hostname"
        echo "[ Ex: ]"
        echo "./$SCRIPTNAME root "
        exit 1
fi

T_USER="${1}"
T_HOST="${2}"
SCRIPT="simpleinstall.sh"


ssh -l ${T_USER} ${T_HOST} 'bash -s' < ${SCRIPT}


#End
~                                                                                                                                                                                             
~                                                                                                                                                                                             
~                                                                                                                                                                                             
~                          
