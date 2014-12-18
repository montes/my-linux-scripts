#!/bin/sh

for file in $(find /home -name "wp-config.php")
  do
    echo "comprobando: $file"

    if [ `stat -c %A $file | sed 's/.....\(.\).\+/\1/'` == "w" ]
    then
      echo "$file is writable, sending email..."
      mail -s "Wordpress writable!!" email@domain.com <<< "Found $file writable"
      echo "email sent"
    fi

    if [ `stat -c %U $file` == "www-data" ]
    then
      echo "$file has wrong owner, sending email..."
      mail -s "Wordpress writable!!" email@domain.com <<< "Found $file with wrong owner (www-data)"
      echo "email sent"
    fi
  done
