#!/bin/bash

SERVER=$1
USER=$2
PASS=$3
JSONFILE=$4
URL="https://$SERVER"

AUTH=`curl -s -k -H "X-API-Version: 300" -H "Content-Type: application/json" -d '{"userName":"'$USER'","password":"'$PASS'","loginMsgAck":"true"}' POST $URL/rest/login-sessions | jq -r .sessionID`

echo $AUTH
 
curl -s -k -H "X-API-Version: 300" -H "Content-Type: application/json" -H "Auth: $AUTH" -H "X-Api-Version: 300" -d @$JSONFILE -X POST $URL/rest/server-profiles 
