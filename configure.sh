#!/bin/bash

# Setup the bind9
./setup.sh

for j in {10..99}
do
  for i in {10..99}
    do
    ./configure_domain.sh open${j}${i}lan.mk 172.19.${j}.${i}
    done
done