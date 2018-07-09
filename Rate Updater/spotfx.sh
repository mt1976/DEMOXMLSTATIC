#!/bin/bash
#
# ===================================================================
# Purpose:           Fetches Spot FX Rates from fixer.io
# Parameters:        one ; two ; three
#                    ---------------------------
#                    $one = (enum) load, unload
#                    $two = (string) second parameter
#                    $three = (num) expected
#                    ---------------------------
# Called From:
# Author:            Matt Townsend
# Notes:
# Revsion:
# ===================================================================
#
clear
figlet "Fetch Spot FX Rates"
echo
echo "Attempt to get 'latest' spot fx rates for processing"

endpoint="latest"
accessKey="c3811be81a6df1db0e14304d77b3a23d"
urlDest="http://data.fixer.io/api/"
baseCCY="EUR"
symbols="USD,JPY,GBP,BTC,CAD,AUD,XAU,CHF,MXN,STD,NOK,DKK,RUR,RMB,HKD,CAD,CHF,DKK,GBP,HKD,JPY,NOK,SEK,SGD,USD,ZAR"
path=$PWD
fileHDR=$(<FXSPOTbaseline.csv)
newline="\n"
destFile=$path"/""FXSPOTbaseline.csv"

#echo $fileHDR
echo "path     =["$path"]"
echo "endpoint =["$endpoint"]"
echo "accessKey=["$accessKey"]"
echo "urlDest  =["$urlDest"]"
echo "baseCCY  =["$baseCCY"]"
echo "symbols  =["$symbols"]"
echo "fileHDR  =["$fileHDR"]"
echo "destFile =["$destFile"]"

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

rateDate=$(echo $result | jq -r '.date')
rateBase=$(echo $result | jq -r '.base')
rateRates=$(echo $result | jq '.rates')
noRates=$(echo $result | jq '.rates|length')

echo "result   =["$result"]"
echo "rateDate =["$rateDate"]"
echo "rateBase =["$rateBase"]"
echo "rateRates=["$rateRates"]"
echo "noRates  =["$noRates"]"

outputFile=""
outputFile+=$fileHDR
outputFile+=$newline

# Now parse each currency to generate csv row data
for ((c=1;c<=$noRates;c++))
do

  id="$(($c-1))"
  rCCY=$(echo $result | jq -r '.rates | keys | .['$id']')
  rRate=$(echo $result | jq -r '.rates.'$rCCY)

  echo "index    =["$id"]"
  echo "rCCY     =["$rCCY"] "$c" "$id
  echo "rRate    =["$rRate"] "$c" "$id


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
  outputFile+=$rCCY
  outputFile+=","
  outputFile+=$rRate
  outputFile+=","
  outputFile+=$rRate
  outputFile+=",Market,0,A"
  outputFile+=$newline

done

rm "$destFile"
echo -e "$outputFile" >> "$destFile"
echo "DONE!"
