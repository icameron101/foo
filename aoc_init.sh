#!/bin/bash

#mvn archetype:generate \
#                "-DgroupId=com.icameron101" \
#                "-DartifactId=$1" \
#                "-DarchetypeArtifactId=maven-archetype-quickstart" \
#                "-DinteractiveMode=false"

mkdir $1
cd $1
//TODO use --type app or lib?
gradle init --type java-library --dsl groovy --project-name $1 --package com.icameron101 --test-framework junit-jupiter  --incubating


# Download the script from GitHub using wget
curl -O https://raw.githubusercontent.com/icameron101/foo/main/aoc_downloader.sh


# Check if the download was successful
if [ $? -eq 0 ]; then
  echo "Download successful"
  # Make the downloaded file executable
  chmod +x aoc_downloader.sh
  # Execute the script with the specified parameters, year start_day, end_day
  ./aoc_downloader.sh $2 $3 $4
  #move files to project resources
  mv aoc_downloader.sh ./lib/src/main/resources
  mv *.html ./lib/src/main/resources
  mv *.txt ./lib/src/test/resources
  rm ./lib/src/test/resources/cookies.txt
  rm ./lib/src/test/resources/headers.txt
else
  echo "Download failed"
fi

# Download the script from GitHub using wget
curl -O https://raw.githubusercontent.com/icameron101/foo/main/aoc_input_encrypt.sh

# Check if the download was successful
if [ $? -eq 0 ]; then
  echo "Download successful"
  # Make the downloaded file executable
  chmod +x aoc_input_encrypt.sh
  # Execute the script with the specified parameters, --encrypt-and-delete, 
  #./aoc_input_encrypt.sh -ed ./lib/src/test/resources
  mv aoc_input_encrypt.sh ./lib/src/test/resources
else
  echo "Download failed"
fi

gradle build

