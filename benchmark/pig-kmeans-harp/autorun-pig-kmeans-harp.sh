#!/bin/bash

inputDir=kmeansTest/100m500for128mappers
centroidsFile=500centroids.txt
centroidsSize=500
pointsPerFile=785000
mapSize=128
iteration=10
outputDir=PigHarpKmeans128m500c
jobID=1
time -p pig -p inputDir=$inputDir -p initialCentroidFileOnHDFS=$centroidsFile -p numOfCentroids=$centroidsSize -p pointsPerFile=$pointsPerFile -p numOfCenPartitions=$mapSize -p iteration=$iteration -p outputDir=$outputDir -p jobID=$jobID pig-kmeans-harp.pig

time -p pig -p inputDir=$inputDir -p initialCentroidFileOnHDFS=$centroidsFile -p numOfCentroids=$centroidsSize -p pointsPerFile=$pointsPerFile -p numOfCenPartitions=$mapSize -p iteration=$iteration -p outputDir=$outputDir -p jobID=$jobID pig-kmeans-harp.pig

time -p pig -p inputDir=$inputDir -p initialCentroidFileOnHDFS=$centroidsFile -p numOfCentroids=$centroidsSize -p pointsPerFile=$pointsPerFile -p numOfCenPartitions=$mapSize -p iteration=$iteration -p outputDir=$outputDir -p jobID=$jobID pig-kmeans-harp.pig

echo "5000 centroids start...."
inputDir=kmeansTest/100m500for128mappers
centroidsFile=5000centroids.txt
centroidsSize=5000
pointsPerFile=785000
mapSize=128
iteration=10
outputDir=PigHarpKmeans128m5000c
jobID=2

time -p pig -p inputDir=$inputDir -p initialCentroidFileOnHDFS=$centroidsFile -p numOfCentroids=$centroidsSize -p pointsPerFile=$pointsPerFile -p numOfCenPartitions=$mapSize -p iteration=$iteration -p outputDir=$outputDir -p jobID=$jobID pig-kmeans-harp.pig

time -p pig -p inputDir=$inputDir -p initialCentroidFileOnHDFS=$centroidsFile -p numOfCentroids=$centroidsSize -p pointsPerFile=$pointsPerFile -p numOfCenPartitions=$mapSize -p iteration=$iteration -p outputDir=$outputDir -p jobID=$jobID pig-kmeans-harp.pig

time -p pig -p inputDir=$inputDir -p initialCentroidFileOnHDFS=$centroidsFile -p numOfCentroids=$centroidsSize -p pointsPerFile=$pointsPerFile -p numOfCenPartitions=$mapSize -p iteration=$iteration -p outputDir=$outputDir -p jobID=$jobID pig-kmeans-harp.pig

