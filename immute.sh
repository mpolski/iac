#!/bin/bash

SERVER=$1
USER=$2
PASS=$3
PROFILE=$4
#Get the exact profile name from the supplied .json file
EXTPROFNAME=`cat "$PROFILE" | jq -r .name`
URL="https://$SERVER"

#Authenticate to HPE OneView API
AUTH=`curl -s -k -H "Content-Type: application/json" -d '{"userName":"'$USER'","password":"'$PASS'"}' POST $URL/rest/login-sessions | jq -r .sessionID`

#Gets the existing profile names (currently expected to work with 1 profile only) 
SPNAME=`curl -s -k -H "Content-Type: application/json" -H "Auth: $AUTH" -X GET $URL/rest/server-profiles | jq -r '.members | .[].name'`

#Compares whether the profile we want to add is already running
#if yes, then it destroys the profile by calling an external script, waits 1 minute for the profile to be destroyed and applies the new version of the profile
#if no, applies the new version of the profile by calling an external script
if [ "$SPNAME" == "$EXTPROFNAME" ]; 
 then
   echo "Destroying profile $EXTPROFNAME"
   echo "`/bin/sh ./removeServProf.sh $PROFILE`";
   echo "`sleep 65`"
   echo "Pushing profile $EXTPROFNAME to HPE OneView"
   echo "`/bin/sh ./push2ov.sh $PROFILE`";
 else
   echo "Pushing profile $EXTPROFNAME to HPE OneView"
   echo "`/bin/sh ./push2ov.sh $PROFILE`";
fi

