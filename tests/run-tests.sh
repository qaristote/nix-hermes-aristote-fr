#! /usr/bin/env nix-shell
#! nix-shell -i bash -p jq curl

function cleanup {
    echo
    echo Shutting down container ...
    sudo nixos-container stop hermes
}

echo Stopping container for update ...
sudo nixos-container stop hermes || exit 2
echo Updating container ...
sudo nixos-container update hermes --flake ..#hermes-test || exit 2
echo Starting container ...
sudo nixos-container start hermes || exit 2

trap cleanup EXIT
sleep 0.1
IP=$(nixos-container show-ip hermes)
CURL_FLAGS='--location --silent'

echo
echo Checking that all the services are running :
declare -A PORTS
PORTS[quentin]=8080
PORTS[searx]=8081
PORTS[money]=8082
PORTS[rss]=8083
PORTS[openpgpkey]=8084
for SERVICE in "${!PORTS[@]}"
do
    echo Checking connection to container version of $SERVICE.aristote.fr ...
    RESULT=$(curl "http://$IP:${PORTS[$SERVICE]}/" $CURL_FLAGS --output /dev/null --write-out '%{http_code}\n')
    if [[ ! "$RESULT" = 200 ]]
    then
        echo "Connection failed."
    fi
done
echo Done.

echo
echo Checking custom Searx engines :
declare -A QUERIES
QUERIES[alternativeto]=Searx
QUERIES[nlab]='Kan%20extension'
QUERIES[wikipediafr]=Paris
QUERIES[wikipediaen]=Paris
for ENGINE in "${!QUERIES[@]}"
do
    echo Checking engine $ENGINE ...
    REQUEST_URL="http://$IP:${PORTS[searx]}/search?q=${QUERIES[$ENGINE]}+!$ENGINE&format=json"
    JSON_RESULT=$(curl "$REQUEST_URL" $CURL_FLAGS)
    RESULTS=$(echo $JSON_RESULT | jq '.results')
    UNRESPONSIVE_ENGINES=$(echo $JSON_RESULT | jq '.unresponsive_engines')
    if [[ ! "$UNRESPONSIVE_ENGINES" = '[]' ]]
    then
        echo "Engine not responsive."
    elif [[ "$RESULTS" = [] ]]
    then
        echo "No results found."
    fi
done
echo Done.

echo
echo Checking custom RSS bridges :
BRIDGES="$(ls ../config/services/web/rss/*Bridge.php | xargs basename -s Bridge.php)"
for BRIDGE in $BRIDGES
do
    echo Checking bridge $BRIDGE ...
    RESULT=$(curl "http://$IP:${PORTS[rss]}/?action=display&bridge=$BRIDGE&format=Plaintext" $CURL_FLAGS --output /dev/null --write-out '%{http_code}\n')
    if [[ ! "$RESULT" = 200 ]]
    then
        echo "Connection failed."
    fi
done
echo Done.

echo
echo Checking web keys directory :
KEYS="$(ls ../config/services/web/webkeydirectory/hu)"
for KEY in $KEYS
do
    echo Checking key $KEY ...
    RESULT=$(curl "http://$IP:${PORTS[openpgpkey]}/.well-known/openpgpkey/aristote.vm/hu/$KEY" $CURL_FLAGS --output /dev/null --write-out '%{http_code}\n')
    if [[ ! "$RESULT" = 200 ]]
    then
        echo "Connection failed."
    fi
done
echo Checking policy file ...
RESULT=$(curl "http://$IP:${PORTS[openpgpkey]}/.well-known/openpgpkey/aristote.vm/policy" $CURL_FLAGS --output /dev/null --write-out '%{http_code}\n')
if [[ ! "$RESULT" = 200 ]]
then
    echo "Connection failed."
fi
echo Done.
