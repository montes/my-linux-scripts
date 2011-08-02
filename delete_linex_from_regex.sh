#!/bin/bash
#
# * This program is free software; you can redistribute it and/or
# * modify it under the terms of the GNU General Public License as
# * published by the Free Software Foundation; either version 2 of
# * the License, or (at your option) any later version.#
#
# * Deletes lines+1 lines from text file starting at regular expression
#
# * By Montes 2011 (http://mooontes.com)


regex='busco'
lines=2 #(it deletes total of lines + 1)
file='text.txt'

line=$(sed -nE "/$regex/=" $file)

endline=`expr $line + $lines`

sed -i "$line, $endline d" test.txt

