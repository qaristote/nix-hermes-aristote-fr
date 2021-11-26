#! /usr/bin/env nix-shell
#! nix-shell -i bash -p jq curl

function cleanup {
    echo
    echo Shutting down container ...
    sudo nixos-container stop hermes
}

sudo nixos-container update hermes --config-file ./vm.nix || exit 2
echo Starting container ...
sudo nixos-container start hermes || exit 2

trap cleanup EXIT
sleep 0.1
IP=$(nixos-container show-ip hermes)

echo
echo Checking that all the services are running :
declare -A PORTS
PORTS[quentin]=8080
PORTS[searx]=8081
PORTS[money]=8082
CURL_FLAGS='--location --silent'
for SERVICE in "${!PORTS[@]}"
do
    echo Checking connection to container version of $SERVICE.aristote.fr ...
    RESULT=$(curl "http://$IP:${PORTS[$SERVICE]}/" $CURL_FLAGS --output /dev/null --write-out '%{http_code}\n')
    if [[ ! "$RESULT" = 200 ]]
    then
        echo "Connection failed."
        exit 2
    fi
done
echo Done.

echo
echo Checking custom Searx engines :
declare -A QUERIES
QUERIES[alternativeto]=Searx
QUERIES[emojipedia]=',,,,,,,,,,,,' #'Thinking%20face'
QUERIES[nlab]='Kan%20extension'
QUERIES[wikipediafr]=Paris
QUERIES[wikipediaen]=Paris
for ENGINE in "${!QUERIES[@]}"
do
    echo Checking engine $ENGINE ...
    JSON_RESULT=$(curl "http://$IP:${PORTS[searx]}/search?q=${QUERIES[$ENGINE]}+\!$ENGINE&format=json" $CURL_FLAGS)
    RESULTS=$(echo $JSON_RESULT | jq '.results')
    UNRESPONSIVE_ENGINES=$(echo $JSON_RESULT | jq '.unresponsive_engines')
    if [[ ! "$UNRESPONSIVE_ENGINES" = '[]' ]]
    then
        echo "Engine not responsive."
        exit 2
    elif [[ "RESULTS" = [] ]]
    then
        echo "No results found."
        exit 2
    fi
done
echo Done.
