#!/bin/bash

# Define the character classes to use
lower='abcdefghijklmnopqrstuvwxyz'
upper='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
digits='0123456789'
special='!@#$%^&*()_-+=[]{}|;:,.<>?'

# Parse command-line arguments
while getopts ":l:u:d:s:" opt; do
  case ${opt} in
    l ) length="$OPTARG" ;;
    u ) use_upper=true; upper_count="$OPTARG" ;;
    d ) use_digits=true; digit_count="$OPTARG" ;;
    s ) use_special=true; special_count="$OPTARG" ;;
    \? ) echo "Usage: generate-password.sh [-l LENGTH] [-u COUNT] [-d COUNT] [-s COUNT]"
         echo "    -l LENGTH: the length of the password (default: 16)"
         echo "    -u COUNT: the number of uppercase letters to include (default: 2)"
         echo "    -d COUNT: the number of digits to include (default: 2)"
         echo "    -s COUNT: the number of special characters to include (default: 2)"
         exit 1 ;;
  esac
done

# Set default values for missing options
length="${length:-16}"
use_upper="${use_upper:-true}"
upper_count="${upper_count:-2}"
use_digits="${use_digits:-true}"
digit_count="${digit_count:-2}"
use_special="${use_special:-true}"
special_count="${special_count:-2}"

# Check that the length and complexity requirements are valid
total_count=$(( upper_count + digit_count + special_count ))
if (( total_count > length )); then
  echo "Error: the number of required characters is greater than the password length"
  exit 1
fi

# Generate the password
password=$(openssl rand -base64 "$((length * 3 / 4))" | tr -d '\n' | tr -d '=')

# Add uppercase letters
if $use_upper; then
  for i in $(seq 1 "$upper_count"); do
    index=$(( RANDOM % length ))
    password="${password:0:index}${upper:$(( RANDOM % ${#upper} )):1}${password:index+1}"
  done
fi

# Add digits
if $use_digits; then
  for i in $(seq 1 "$digit_count"); do
    index=$(( RANDOM % length ))
    password="${password:0:index}${digits:$(( RANDOM % ${#digits} )):1}${password:index+1}"
  done
fi

# Add special characters
if $use_special; then
  for i in $(seq 1 "$special_count"); do
    index=$(( RANDOM % length ))
    password="${password:0:index}${special:$(( RANDOM % ${#special} )):1}${password:index+1}"
  done
fi

echo "$password"
