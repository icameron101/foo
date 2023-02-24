#!/bin/bash

# Usage example: ./init_java_library.sh my_project my_lib com.example 2023 1 25

# Function to initialize the project using Gradle init
function initProject {
    gradle init --type java-library --dsl groovy --project-name $1 --test-framework junit-jupiter --incubating  --package com.icameron101
}

# Function to rename the 'lib' directory to the library name
function renameLibDir {
    mv lib $1
}

# Function to update the settings.gradle file with the new library name
function updateSettingsGradle {
    echo "rootProject.name = '$1'" > settings.gradle
    echo "include '$1'" >> settings.gradle
}

# Function to update the build.gradle file with the new library name
function updateBuildGradle {
    sed -i "s/archivesBaseName = 'lib'/archivesBaseName = '$1'/" $1/build.gradle
}

# Function to download a file from GitHub
function downloadFromGitHub {
    curl -O $1
}

# Function to check if the download was successful and make the downloaded file executable
function checkDownload {
    if [ $? -eq 0 ]; then
        echo "Download successful"
        chmod +x $1
    else
        echo "Download failed"
    fi
}

# Function to move files to the project resources
function moveFilesToResources {
    for file in $1; do
        mv $file ./$2
    done
}

# Function to execute a script with specified parameters
function executeScript {
    ./$1 $2 $3 $4
}

# Define vars from the params
project_name=$1
library_name=$2
year_number=$2
from_day_number=$3
to_day_number=$4

# Create project
mkdir $project_name
cd $project_name

# Initialize the java-library project using Gradle init
initProject $project_name

# Rename the 'lib' directory to the library name
renameLibDir $library_name

# Update the settings.gradle file with the new library name
updateSettingsGradle $library_name

# Update the build.gradle file with the new library name
updateBuildGradle $library_name

# Download the script from GitHub
downloadFromGitHub https://raw.githubusercontent.com/icameron101/foo/main/aoc_downloader.sh

# Check if the download was successful and execute the script with specified parameters
checkDownload aoc_downloader.sh && executeScript aoc_downloader.sh $year_number $from_day_number $to_day_number

# Download the script from GitHub
downloadFromGitHub https://raw.githubusercontent.com/icameron101/foo/main/aoc_input_encrypt.sh

# Check if the download was successful and move the script to the project resources
checkDownload aoc_input_encrypt.sh
#checkDownload aoc_input_encrypt.sh && executeScript aoc_input_encrypt.sh -ed

# Move files to the project resources
#moveFilesToResources '*.html' $library_name/src/main/resources
#moveFilesToResources '*.txt *.sh' $library_name/src/test/resources

# Build the project
gradle build
