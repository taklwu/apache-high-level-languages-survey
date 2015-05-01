#!/usr/bin/python
import sys
from math import fabs
import os
import time
from org.apache.pig.scripting import Pig


jobStartTime = time.time();
filename = "student.txt"
initialCentroidsFile = sys.argv[1]
hdfsInputDir = sys.argv[2]
print initialCentroidsFile
k = 4
numOfCentroids = int(sys.argv[3])
numOfReducer = str(sys.argv[4])
# numOfMapper = str(sys.argv[5])
tolerance = 0.01

MAX_ITERATION = int(sys.argv[5])

initial_centroids = ""

# only support local path currently
hdfsCentroidFilePath = "/tmp/"+initialCentroidsFile
cachedCentroidFilePath = hdfsCentroidFilePath+"#"+initialCentroidsFile
Pig.fs("rm -r "+hdfsCentroidFilePath)
Pig.fs("put "+initialCentroidsFile+" " + hdfsCentroidFilePath)


#print initial_centroids

pigScript = ("""SET default_parallel """+numOfReducer+""";
                   SET pig.noSplitCombination true;
                   -- set mapred.child.java.opts '-Xmx900m';
                   set mapred.map.tasks.speculative.execution false;
                   SET mapred.cache.files """+cachedCentroidFilePath+""";
                   register pig-kmeans-udf-yarn.jar;
                   -- DEFINE find_centroid FindCentroid('$centroids');
                   raw = load '"""+hdfsInputDir+"""' using BinaryDataLoader('$centroids','"""+str(numOfCentroids)+"""') as (datapoints);
                   -- line below may be the bottleneck
                   datapointbag = foreach raw generate FLATTEN(datapoints) as datapointInString:chararray;
                   datapoint = foreach datapointbag generate STRSPLIT(datapointInString, ',', 5) as splitedDP;
                   -- centroidedDatapoints = foreach datapointbag generate find_centroid(datapoint) as centroid, datapoint;
                   -- line below may be the bottleneck
                   grouped = Group datapoint by splitedDP.$0;
		   newCentroids = foreach grouped generate CalculateNewCentroids($1); 
                   -- Illustrate datapointbag;
                   store newCentroids into 'output';
                   -- store raw into 'output2';
                """)
# not yet comuting kmeans
#print pigScript

# compile pig scripts
PC = Pig.compile(pigScript)

converged = False
iter_num = 0
noneCount = 0
while iter_num<MAX_ITERATION:
    noneCount = 0    
    start_time = time.time()
    Pig.fs("rmr output")
    Pig.fs("rmr output2")
    PCB = PC.bind({'centroids':initialCentroidsFile})
    results = PCB.runSingle()
    if results.isSuccessful() == "FAILED":
        raise "Pig job failed"
    centroids = [None] * 3
    distance_move = 0
    iter_num+=1

    print("noneCount =  " + str(noneCount))
    print("iteration " + str(iter_num) + ", takes = " + str(time.time() - start_time) + " seconds")
    
    print("getting new centroids from iterator")
    
    #Pig.fs("cat output/part-* > /tmp/tmpCentroids.txt")
    mergeStartTime=time.time()
    os.system("hadoop dfs -cat output/part-* > /tmp/tmpCentroids.txt")
    Pig.fs("rm -r "+hdfsCentroidFilePath)
    Pig.fs("put /tmp/tmpCentroids.txt " + hdfsCentroidFilePath)
    print("Merging new centroids takes = " + str(time.time() - mergeStartTime) + " seconds")



if not converged:
    print("not converge after " + str(iter_num) + " iterations")
    sys.stdout.write("Job overall execution time = " + str (time.time() - jobStartTime) + "\n")
