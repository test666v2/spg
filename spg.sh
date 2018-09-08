#!/bin/bash

###################################################

# Simple password generator from urandom

# adapt as needed

###################################################

# DISCLAIMER

# Use this script at your own risk
# You, as a user, have no right to support even if implied
# Carefully read the script and then interpret, modify, correct, fork, disdain, whatever

###################################################

#Copyright (c) <2018> <test666v2>
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

###################################################

spg_help()
{
   echo "spg.sh : simple pasword generator (from urandom)"
   echo "      defaults to (press <ENTER> 3x to quickly go through them)"
   echo "            $password_default_size characters"
   echo "            alphanumeric & non-alphanumeric (p4\$\$W0rD)"
   echo "            1 password"
   echo "      can output"
   echo "            more than $password_default_size characters"
   echo "            only alphanumeric characters (p4s5W0rD)"
   echo "            several passwords"
   echo "Be \"reasonable\" with the values entered to avoid clogging the terminal"
   echo
   exit
}

##########################
password_default_size=12

echo
[ -z $1 ] || spg_help

password_size=0
while (( password_size == 0 )) # keep looping until password size >= $password_default_size ($password_default_size is "hardcoded" for a decent password length)
   do
      read -r $special_characters -p "Password size (>=8) or press <ENTER> for the default length of $password_default_size ? > " password_size
      password_size=$(
            case "$password_size" in
               "") echo $password_default_size ;;
               *) [ -z "${password_size##*[!0-9]*}" ] && echo 0 || echo "$password_size";;  # accept only integers>0
            esac)
      (( $password_size >= $password_default_size )) || password_size=0
   done

how_many_passwords=0
while (( how_many_passwords == 0 )) # keep looping until $how_many_passwords>0
   do
      read -r $special_characters -p "How many passwords to generate, press <ENTER> for 1 > " how_many_passwords
      how_many_passwords=$(
            case "$how_many_passwords" in
               "") echo 1 ;;
               *) [ -z "${how_many_passwords##*[!0-9]*}" ] && echo 0 || echo "$how_many_passwords";; # accept only integers
            esac)
   done

while [[ $special_characters  == "" ]] #  keep looping for all entered keywords other than "Y" "N" or "empty"
   do
      read -r -p "Password with non-alphanumeric characters (Y,N,<ENTER> for YES) ? > " special_characters
      special_characters=$(
            case $special_characters in
               "Y") echo "Y" ;;
               "y") echo "Y" ;;
               "") echo "Y" ;;
               "N") echo "N" ;;
               "n") echo "N" ;;
               *) echo "" ;;
            esac)
   done

echo
for (( i  = 1; i <= $how_many_passwords ; i++ )) # output password(s)
   do
      case $special_characters in
         "Y") echo $(cat /dev/urandom | tr -dc '!-~' | head -c $password_size) ;;
         "N") echo $(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c $password_size) ;;
      esac
      echo
   done

echo "Press <ENTER> to exit"
read
