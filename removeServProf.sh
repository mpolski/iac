#!/bin/bash

SERVER=192.168.78.10
USER=Administrator
PASS=passw0rd
JSONFILE=$1
EXTPROFNAME=`cat WebServ-5.json | jq -r .name`
URL="https://$SERVER"

AUTH=`curl -s -k -H "X-API-Version: 300" -H "Content-Type: application/json" -d '{"userName":"'$USER'","password":"'$PASS'","loginMsgAck":"true"}' POST $URL/rest/login-sessions | jq -r .sessionID`

echo $AUTH
echo "Trying to remove "$EXTPROFNAME  
curl -s -k -H "X-API-Version: 300" -H "Content-Type: application/json" -H "Auth: $AUTH" -X DELETE $URL/rest/server-profiles?filter=name="'$EXTPROFNAME'"
