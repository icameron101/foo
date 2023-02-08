#!/bin/bash

# Set the environment variables for the username and password

#export AOC_USERNAME=icameron101@icloud.com
#export AOC_PASSWORD=<replace-me>


Usage: bash aoc_downloader.sh [year_number day_number | from_day_number to_day_number]
 
#curl -c cookies.txt -d "username=$AOC_USERNAME&password=$AOC_PASSWORD" https://adventofcode.com/auth/github
#response=$(curl -H "Authorization: token $access_token" https://api.github.com/user)
#echo $response
#session_id=$(grep session cookies.txt | awk '{print $7}')
#echo $session_id

access_token=“<replace-me>”
response=$(curl -H "Authorization: Bearer $access_token" -H "Content-Type: application/json" -X POST -d "{\"type\":\"github\"}" https://adventofcode.com/auth/github)
echo $response

function fetch_content {
  local year=$1
  local day=$2

  local url=https://adventofcode.com/$year/day/$day
  echo Fetching : $url
  local html_content=$(curl "$url")
  local name=$(echo "$html_content" | awk -v RS="---" '/Day [0-9]+:.*/')
  name="$(echo -e "${name}" | tr -d '[:space:]')"
  name="${name//:/}"
  echo Fetching content for : $name 
  curl -b cookies.txt -o $year$name.html "$url"
  curl -b cookies.txt -o $year$name.txt "$url/input"
}


function check_env {
if [ -z "$AOC_USERNAME" ] || [ -z "$AOC_PASSWORD" ]; then
echo "Error: AOC_USERNAME and AOC_PASSWORD environment variables must be set."
exit 1
fi
}

function check_year {
  local year=$1

  if [[ $year -lt 2015 || $year -gt 2022 ]]; then
    echo "Year must be between 2015 and 2022 inclusive"
    exit 1
  fi
}

function check_day {
  local day=$1

  if [[ $day -lt 1 || $day -gt 25 ]]; then
    echo "Day must be between 1 and 25 inclusive"
    exit 1
  fi
}

function retrieve_single_day {
  local year=$1
  local day=$2

  check_year $year
  check_day $day
  fetch_content $year $day
}

function retrieve_range_of_days {
  local year=$1
  local from_day=$2
  local to_day=$3

  check_year $year
  check_day $from_day
  if [[ $to_day -eq 26 ]]; then
    echo "to_day_number cannot be 26"
    exit 1
  fi
  for day in $(seq $from_day $to_day)
  do
    fetch_content $year $day
  done
}

#ßcheck_env
if [ $# -eq 2 ]
then
  retrieve_single_day $1 $2
else
  retrieve_range_of_days $1 $2 $3
fi