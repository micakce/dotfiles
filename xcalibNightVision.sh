#!/bin/zsh
# redscreen.sh Fri Feb 28 11:36 EST 2020 Alan Formy-Duval
# Turn screen red - Useful to Astronomers
# Inspired by redscreen.csh created by Jeff Jahr 2014
# (http://www.jeffrika.com/~malakai/redscreen/index.html)

# This program is free software: you can redistribute it
# and/or modify it under the terms of the GNU General
# Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any
# later version.

# This program is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
# PURPOSE.  See the GNU General Public License for
# more details.

# You should have received a copy of the GNU General Public
# License along with this program.
# If not, see <http://www.gnu.org/licenses/>.

case $1 in
            on)
            # adjust color, gamma, brightness, contrast
            xcalib -green .1 0 1 -blue .1 0 1 -red 0.5 1 40 -alter
            exit 1
        ;;
        off)
                xcalib -clear
            exit 1
            ;;
        inv)
            # Invert screen
                xcalib -i -a
                    exit 1
        ;;
        dim)
            # Make the screen darker
                xcalib -clear
            xcalib -co 30 -alter
            exit 1
        ;;
        *)
                echo "$0 [on | dim | inv | off]"
                    exit 1
        ;;
esac
