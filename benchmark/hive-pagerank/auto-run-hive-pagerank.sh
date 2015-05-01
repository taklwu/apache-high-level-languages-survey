#!/bin/bash

# 2000k tests
echo "---2000k-test1---"
time -p ./hive-pagerank.sh 2000k64m8r 64 2000000 0.85 10
echo "---2000k-test2---"
time -p ./hive-pagerank.sh 2000k64m8r 64 2000000 0.85 10
echo "---2000k-test3---"
time -p ./hive-pagerank.sh 2000k64m8r 64 2000000 0.85 10

sleep 10
# 1000k tests
echo "---1000k-test1---"
time -p ./hive-pagerank.sh 1000k64m8r 64 1000000 0.85 10
echo "---1000k-test2---"
time -p ./hive-pagerank.sh 1000k64m8r 64 1000000 0.85 10
echo "---1000k-test3---"
time -p ./hive-pagerank.sh 1000k64m8r 64 1000000 0.85 10
