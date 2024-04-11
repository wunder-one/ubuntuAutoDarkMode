#!/bin/sh

# This script queries the API and generates a JSON with the current 
# sunrise and sunset times in timestamp format, in local time
# You should add this script to cron so that it runs every day

# Thanks to Sunrise & Sunset API
# go to https://sunrise-sunset.org/api for use details

# Local coordinates. Change it at your zone
# Find local coordinates at https://www.geolocation.com/
lat="-34.603722"
lng="-58.381592"

# API URL
url="https://api.sunrise-sunset.org/json?lat=$lat&lng=$lng"

# API get
res=$(curl -s $url)

# Get sunrise and sunset from the JSON of the API
sunrise_utc=$(echo $res | jq -r '.results.sunrise')
sunset_utc=$(echo $res | jq -r '.results.sunset')

# Convert to timestamp
sunrise_ts=$(date -d"$sunrise_utc UTC" +%H:%M)
sunset_ts=$(date -d"$sunset_utc UTC" +%H:%M)

# Create JSON
json=$(jq -n \
  --arg sr "$sunrise_ts" \
  --arg ss "$sunset_ts" \
  '{sunrise: $sr, sunset: $ss}')

# Save JSON to file
echo $json > times.json
