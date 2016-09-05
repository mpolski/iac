#!/bin/bash

SERVER=192.85.181.199
USER=Administrator
PASS=passw0rd
JSONFILE=$1
EXTPROFNAME=`cat WebServ-5.json | jq -r .name`
URL="https://$SERVER"

AUTH=`curl -s -k -H "Content-Type: application/json" -d '{"userName":"'$USER'","password":"'$PASS'"}' POST $URL/rest/login-sessions | jq -r .sessionID`

echo $AUTH
echo "Trying to remove "$EXTPROFNAME  
curl -s -k -H "Content-Type: application/json" -H "Auth: $AUTH" -H "X-Api-Version: 300" -X DELETE $URL/rest/server-profiles?filter=name="'$EXTPROFNAME'"
