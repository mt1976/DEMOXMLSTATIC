#!/bin/bash
clear
figlet "Fetch Spot FX Rates"
echo
echo "Attempt to get 'latest' spot fx rates for processing"

endpoint="latest"
accessKey="c3811be81a6df1db0e14304d77b3a23d"
urlDest="http://data.fixer.io/api/"
baseCCY="EUR"
symbols="USD,JPY,GBP,BTC,CAD,AUD,XAU,CHF,MXN,STD,NOK,DKK,RUR,RMB,HKD"
path=$PWD
fileHDR=$(<rateFileHdr.txt)
newline="\n"

#echo $fileHDR
echo "path     =["$path"]"
echo "endpoint =["$endpoint"]"
echo "accessKey=["$accessKey"]"
echo "urlDest  =["$urlDest"]"
echo "baseCCY  =["$baseCCY"]"
echo "symbols  =["$symbols"]"
echo "fileHDR  =["$fileHDR"]"

request=$urlDest
request+=$endpoint
request+="?"
request+="access_key="$accessKey
#request+="&"
#request+="base="$baseCCY
request+="&"
request+="symbols="$symbols

echo "request  =["$request"]"

curlArgs="-sL"

result=$(curl $curlArgs "$request")

echo "result   =["$result"]"
rateDate=$(echo $result | jq -r '.date')

echo "rateDate =["$rateDate"]"

rateBase=$(echo $result | jq -r '.base')
echo "rateBase =["$rateBase"]"

rateRates=$(echo $result | jq '.rates')
echo "rateRates=["$rateRates"]"

noRates=$(echo $result | jq '.rates|length')
echo "noRates  =["$noRates"]"

outputFile=""
outputFile+=$fileHDR
outputFile+=$newline

# Now parse each currency to generate csv row data
for ((c=1;c<=$noRates;c++))
do

outputFile+="FX"
outputFile+=","
outputFile+="FXSPOT"
outputFile+=","
outputFile+="SP"
outputFile+=","
outputFile+=","
outputFile+="SIMU"
outputFile+=","
outputFile+=$rateBase
outputFile+=","

id="$(($c-1))"
echo "index    =["$id"]"

rCCY=$(echo $result | jq -r '.rates | keys | .['$id']')
echo "rCCY     =["$rCCY"] "$c" "$id

rRate=$(echo $result | jq -r '.rates.'$rCCY)
echo "rRate    =["$rRate"] "$c" "$id

outputFile+=$rCCY
outputFile+=","
outputFile+=$rRate
outputFile+=","
outputFile+=$rRate
outputFile+=",Market,0,A"
outputFile+=$newline

done

echo -e "$outputFile"

printf 'new\nline\n$outputFile'

echo "\nDONE!"
