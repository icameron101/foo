#!/bin/bash

get_dir() {
  echo "Enter the directory path (leave empty for current directory): "
  read dir

  if [ -z "$dir" ]; then
    dir="."
  fi

  echo "The directory path is: $dir"
  echo
}

encrypt_files() {
  echo "Enter the encryption key: "
  read -s key

  for file in $dir/*.txt; do
    openssl enc -aes-256-cbc -salt -in $file -out "$file.enc" -k $key
    echo "$file has been encrypted successfully."
  done
}

decrypt_files() {
  echo "Enter the decryption key: "
  read -s key

  for file in $dir/*.enc; do
    decrypted_file="${file%.enc}"
    openssl enc -d -aes-256-cbc -in $file -out "$decrypted_file" -k $key
    echo "$file has been decrypted as $decrypted_file successfully."
  done
}

get_dir

echo "What would you like to do? [E]ncrypt files, [D]ecrypt files, or [Q]uit?"
read -n 1 action

if [ "$action" == "E" ]; then
  encrypt_files
elif [ "$action" == "D" ]; then
  decrypt_files
else
  echo "Exiting."
fi
