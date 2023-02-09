#!/bin/bash


# Set the environment variables for GitHub Personal Access Token
#export ACCESS_TOKEN=<replace-me>

Usage:  aoc_downloader.sh year_number day_number 
        aoc_downloader.sh year_number from_day_number to_day_number
 

response=$(curl -H "Authorization: token $ACCESS_TOKEN" https://api.github.com/user)
echo "Response from GitHub API: $response"

response=$(curl -H "Authorization: Bearer $ACCESS_TOKEN" -H "Content-Type: application/#json" -X POST -d "{\"type\":\"github\"}" https://adventofcode.com/auth/github)
echo "Response from Advent of Code API: $response"


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
if [ -z "$ACCESS_TOKEN" ]; then
  echo "Error: You GitHub personal ACCESS_TOKEN environment variables must be set."
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

function download_single_day {
  local year=$1
  local day=$2

  check_year $year
  check_day $day
  fetch_content $year $day
}

function download_range_of_days {
  local year=$1
  local from_day=$2
  local to_day=$3

  check_year $year
  check_day $from_day
  if [[ $to_day -gt 25 ]]; then
    echo "to_day_number cannot be greater than 25"
    exit 1
  fi
  for day in $(seq $from_day $to_day)
  do
    fetch_content $year $day
  done
}

check_env
if [ $# -eq 2 ] 
then
  download_single_day $1 $2
else
  download_range_of_days $1 $2 $3
fi
