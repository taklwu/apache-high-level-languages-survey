#!/bin/bash
echo "running"

nohup pig -p inputDir=200k8m -p totalVtx=200000 -p numMaps=8 -p partitionPerWorker=1 -p iteration=10 -p outputDir=pig200k8m -p jobID=1 pig-pagerank-harp.pig > job1.txt

nohup pig -p inputDir=200k16m -p totalVtx=200000 -p numMaps=16 -p partitionPerWorker=1 -p iteration=10 -p outputDir=pig200k16m -p jobID=2 pig-pagerank-harp.pig > job2.txt

nohup pig -p inputDir=200k32m -p totalVtx=200000 -p numMaps=32 -p partitionPerWorker=1 -p iteration=10 -p outputDir=pig200k32m -p jobID=3 pig-pagerank-harp.pig > job3.txt

nohup pig -p inputDir=1000k8m -p totalVtx=1000000 -p numMaps=8 -p partitionPerWorker=1 -p iteration=10 -p outputDir=pig1000k8m -p jobID=4 pig-pagerank-harp.pig > job4.txt

nohup pig -p inputDir=1000k16m -p totalVtx=1000000 -p numMaps=16 -p partitionPerWorker=1 -p iteration=10 -p outputDir=pig1000k16m -p jobID=5 pig-pagerank-harp.pig > job5.txt

nohup pig -p inputDir=1000k32m -p totalVtx=1000000 -p numMaps=32 -p partitionPerWorker=1 -p iteration=10 -p outputDir=pig1000k32m -p jobID=6 pig-pagerank-harp.pig > job6.txt

nohup pig -p inputDir=2000k8m -p totalVtx=2000000 -p numMaps=8 -p partitionPerWorker=1 -p iteration=10 -p outputDir=pig2000k8m -p jobID=7 pig-pagerank-harp.pig > job7.txt

nohup pig -p inputDir=2000k16m -p totalVtx=2000000 -p numMaps=16 -p partitionPerWorker=1 -p iteration=10 -p outputDir=pig2000k16m -p jobID=8 pig-pagerank-harp.pig > job8.txt

nohup pig -p inputDir=2000k32m -p totalVtx=2000000 -p numMaps=32 -p partitionPerWorker=1 -p iteration=10 -p outputDir=pig2000k32m -p jobID=9 pig-pagerank-harp.pig > job9.txt

echo "Fin"


