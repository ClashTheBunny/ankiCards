#!/bin/bash
fd=/proc/$1/fd/$2
fdinfo=/proc/$1/fdinfo/$2
name=$(readlink $fd)
size=$(wc -c $fd | awk '{print $1}')
while [ -e $fd ]; do
  progress=$(cat $fdinfo | grep ^pos | awk '{print $2}')
  echo $((100*$progress / $size))
  sleep 1
done | dialog --gauge "Progress reading $name" 7 100
