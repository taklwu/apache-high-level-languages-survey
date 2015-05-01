#!/bin/bash

# 200k tests
nohup java PageRank 200000 0.85 10 200k8m rerun200k8 8 > 200k8m1GB.txt
#nohup java PageRank 200000 0.85 10 200k16m run200k16 16 > 200k16m1GB.txt
#nohup java PageRank 200000 0.15 10 200k32m rerun200k32 32 > 200k32m1GB.txt

sleep 10
# 2000k tests
nohup java PageRank 2000000 0.85 10 2000k8m rerun2m8 8 > 2000k8m1GB.txt
#nohup java PageRank 2000000 0.85 10 2000k16m rerun2m16 16 > 2000k16m1GB.txt
#nohup java PageRank 2000000 0.15 10 2000k32m run2m32 32 > 2000k32m1GB.txt

sleep 10
# 1000k tests
nohup java PageRank 1000000 0.85 10 1000k8m rerun1m8 8 > 1000k8m1GB.txt
nohup java PageRank 1000000 0.85 10 1000k16m rerun1m16 16 > 1000k16m1GB.txt
#nohup java PageRank 1000000 0.85 10 1000k32m rerun1m32 32 > 1000k32m1GB.txt
