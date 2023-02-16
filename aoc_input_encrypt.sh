#!/bin/bash

get_dir() {
  echo "Enter the directory path (leave empty for current directory): "
  read dir

  if [ -z "$dir" ]; then
    dir="."
  fi

  echo "The directory path is: $dir"
}

encrypt_files() {
  echo "Enter the encryption key: "
  read -s key

  if [ ! -f $dir/*.txt ]; then
    echo "No .txt files found in the directory."
    exit 1
  fi

  for file in $dir/*.txt; do
    openssl enc -aes-256-cbc -salt -in $file -out "$file.enc" -k $key
    echo "$file has been encrypted successfully."
  done
}

encrypt_and_delete_files() {
  echo "Enter the encryption key: "
  read -s key

  if [ ! -f $dir/*.txt ]; then
    echo "No .txt files found in the directory."
    exit 1
  fi

  for file in $dir/*.txt; do
    openssl enc -aes-256-cbc -salt -in $file -out "$file.enc" -k $key
    rm $file
    echo "$file has been encrypted and deleted successfully, see $file.enc."
  done
}

decrypt_files() {
  echo "Enter the decryption key: "
  read -s key

  if [ ! -f $dir/*.enc ]; then
    echo "No .enc files found in the directory."
    exit 1
  fi

  for file in $dir/*.enc; do
    decrypted_file="${file%.enc}"
    if [ -f "$decrypted_file" ]; then
      echo "$decrypted_file already exists. Please delete it and try again."
      exit 1
    fi
    openssl enc -d -aes-256-cbc -in $file -out "$decrypted_file" -k $key
    echo "$file has been decrypted as $decrypted_file successfully."
  done
}

decrypt_and_delete_files() {
  echo "Enter the decryption key: "
  read -s key

  if [ ! -f $dir/*.enc ]; then
    echo "No .enc files found in the directory."
    exit 1
  fi

  for file in $dir/*.enc; do
    decrypted_file="${file%.enc}"
    if [ -f "$decrypted_file" ]; then
      echo "$decrypted_file already exists. Please delete it and try again."
      exit 1
    fi
    openssl enc -d -aes-256-cbc -in $file -out "$decrypted_file" -k $key
    rm $file
    echo "$file has been decrypted and deleted successfully, see $decrypted_file."
  done
}


#get_dir
if [ "$1" == "-e" ] || [ "$1" == "--encrypt" ]; then
  encrypt_files
elif [ "$1" == "-ed" ] || [ "$1" == "--encrypt-and-delete" ]; then
  encrypt_and_delete_files
elif [ "$1" == "-d" ] || [ "$1" == "--decrypt" ]; then
  decrypt_files
elif [ "$1" == "-dd" ] || [ "$1" == "--decrypt-and-delete" ]; then
  decrypt_and_delete_files
else
  echo "Invalid option. Use -h or --help for usage information."
fi
