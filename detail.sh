#!/bin/bash

archivos=$(cat archivos.txt)
for archivo in $archivos; do
    echo $archivo
    ls -lh $archivo
done