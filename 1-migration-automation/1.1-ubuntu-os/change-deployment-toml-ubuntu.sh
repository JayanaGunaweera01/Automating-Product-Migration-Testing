#!/bin/bash

for file in $(find $DEPLOYMENT_PATH -type f -name 'deployment.toml');
do
cat $DEPLOYMENT_AUTOMATION > $file;

done

#Below block is for local setup

#for file in $(find $DEPLOYMENT_PATH -type f -name 'deployment.toml');
#do
#awk '
#BEGIN { skip = 0 }
#{
#if ($0 ~ /^#comment_start$/) {
#skip = 1
#}
#if (!skip) {
#print $0
#}
#if ($0 ~ /^#comment_end$/) {
#skip = 0
#}
#}
#' $DEPLOYMENT_AUTOMATION > $file
#done
