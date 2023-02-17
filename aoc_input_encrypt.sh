#!/bin/bash

TXT_EXTENSION=".txt"
ENC_EXTENSION=".enc"

check_files() {
  if [ ! -f "$1" ]; then
    echo "No .$2 files found in the directory, $1"
    exit 1
  fi
}

check_dir() {
  if [ ! -d "$1" ]; then
    echo "$1 is not a directory"
    exit 1
  fi
}

encrypt_files() {
  echo "Enter the encryption key: "
  read -s key

  check_files "$dir/*$TXT_EXTENSION" "$TXT_EXTENSION"

  for file in "$dir/*$TXT_EXTENSION"; do
    openssl enc -aes-256-cbc -salt -in "$file" -out "${file%.$TXT_EXTENSION}$ENC_EXTENSION" -k $key
    echo "$file has been encrypted successfully."
  done
}

encrypt_and_delete_files() {
  echo "Enter the encryption key: "
  read -s key

  check_files "$dir/*$TXT_EXTENSION" "$TXT_EXTENSION"

  for file in "$dir/*$TXT_EXTENSION"; do
    openssl enc -aes-256-cbc -salt -in "$file" -out "${file%.$TXT_EXTENSION}$ENC_EXTENSION" -k $key
    rm "$file"
    echo "$file has been encrypted and deleted successfully, see ${file%.$TXT_EXTENSION}$ENC_EXTENSION."
  done
}

decrypt_files() {
  echo "Enter the decryption key: "
  read -s key

  check_files "$dir/*$ENC_EXTENSION" "$ENC_EXTENSION"

  for file in "$dir/*$ENC_EXTENSION"; do
    decrypted_file="${file%.$ENC_EXTENSION}"
    if [ -f "$decrypted_file" ]; then
      echo "$decrypted_file already exists. Please delete it and try again."
      exit 1
    fi
    openssl enc -d -aes-256-cbc -in "$file" -out "$decrypted_file" -k $key
    echo "$file has been decrypted as $decrypted_file successfully see $decrypted_file."
  done
}

decrypt_and_delete_files() {
  echo "Enter the decryption key: "
  read -s key

  check_files "$dir/*$ENC_EXTENSION" "$ENC_EXTENSION"

  for file in "$dir/*$ENC_EXTENSION"; do
    decrypted_file="${file%.$ENC_EXTENSION}"
    if [ -f "$decrypted_file" ]; then
      echo "$decrypted_file already exists. Please delete it and try again."
      exit 1
    fi
    openssl enc -d -aes-256-cbc -in "$file" -out "$decrypted_file" -k $key
    rm "$file"
    echo "$file has been decrypted and deleted successfully, see $decrypted_file."
  done
}

#MAIN
dir="${2:-.}"
check_dir "$dir"

if [ "$1" == "-e" ] || [ "$1" == "--encrypt" ]; then
  encrypt_files 
elif [ "$1" == "-ed" ] || [ "$1" == "--encrypt-and-delete" ]; then
  encrypt_and_delete_files
elif [ "$1" == "-d" ] || [ "$1" == "--decrypt" ]; then
  decrypt_files
elif [ "$1" == "-dd" ] || [ "$1" == "--decrypt-and-delete" ]; then
  decrypt_and_delete_files
else
  echo "Invalid option"
fi
