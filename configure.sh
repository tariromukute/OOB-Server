#!/bin/bash

# Setup the bind9
./setup.sh

for j in {1..200}
do
  for i in {1..200}
    do
    ./configure_domain.sh open${j}${i}lan.mk 172.19.${j}.${i}
    done
done