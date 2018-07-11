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
# Called From:       Scheduler
# Author:            Matt Townsend
# Notes:
# Revsion:
# ===================================================================
#
clear
figlet -f small "MT: Get Spot FX Rates"
echo
echo "MT: Attempt to get 'latest' spot fx rates for processing"
echo
endpoint="latest"
accessKey="c3811be81a6df1db0e14304d77b3a23d"
urlDest="http://data.fixer.io/api/"
baseCCY="EUR"
symbols="USD,JPY,GBP,BTC,CAD,AUD,XAU,CHF,MXN,STD,NOK,DKK,RUR,RMB,HKD,CAD,CHF,DKK,GBP,HKD,JPY,NOK,SEK,SGD,USD,ZAR"
path=$PWD
fileHDR=$(<rateFileHdr.txt)
newline="\n"
dateID=$(date "+%Y%m%d%H%M")
rateSource="2"
outputDir="ratesData"
destFile=$path"/"$outputDir"/FXSPOTbaseline_"$dateID".csv"

#echo $fileHDR
echo "MT: path      = ["$path"]"
echo "MT: outputDir = ["$outputDir"]"
echo "MT: endpoint  = ["$endpoint"]"
echo "MT: accessKey = ["$accessKey"]"
echo "MT: urlDest   = ["$urlDest"]"
#echo "MT: baseCCY   = ["$baseCCY"]"
echo "MT: symbols   = ["$symbols"]"
echo "MT: fileHDR   = ["$fileHDR"]"
echo "MT: dateID    = ["$dateID"]"
echo "MT: destFile  = ["$destFile"]"
echo "MT: rateSource= ["$rateSource"]"

# Build URL request
request=$urlDest
request+=$endpoint
request+="?"
request+="access_key="$accessKey
#Can't request base currency quotes from the fixer.io engine (without a subscription)
#request+="&"
#request+="base="$baseCCY
request+="&"
request+="symbols="$symbols

echo "MT: request   = ["$request"]"

curlArgs="-sL"
# Execute the curl URL request
result=$(curl $curlArgs "$request")

rateDate=$(echo $result | jq -r '.date')
rateBase=$(echo $result | jq -r '.base')
rateRates=$(echo $result | jq '.rates')
noRates=$(echo $result | jq '.rates|length')

echo "MT: result    = ["$result"]"
echo "MT: rateDate  = ["$rateDate"]"
echo "MT: rateBase  = ["$rateBase"]"
echo "MT: rateRates = ["$rateRates"]"
echo "MT: noRates   = ["$noRates"]"

outputFile=""
outputFile+=$fileHDR
outputFile+=$newline

# Now parse each currency to generate csv row data
for ((c=1;c<=$noRates;c++))
do

  id="$(($c-1))"
  rCCY=$(echo $result | jq -r '.rates | keys | .['$id']')
  rRate=$(echo $result | jq -r '.rates.'$rCCY)

  echo "MT: > index      = ["$id"]"
  echo "MT: > rCCY       = ["$rCCY"] "$c" "$id
  echo "MT: > rRate      = ["$rRate"] "$c" "$id

  outputFile+="FX"
  outputFile+=","
  outputFile+=$rateSource
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
#
# File has been merged and built - Now Output File array to the destination file
#
#rm "$destFile"
echo -e "$outputFile" >> "$destFile"
figlet -f small "MT: JOB DONE"
