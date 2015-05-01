-- pig kmeans with harp

-- configuration parameters 

SET default_parallel 4;
SET pig.noSplitCombination true;
-- SET mapred.child.java.opts '-Xmx900m';
SET mapred.map.tasks.speculative.execution false;
SET mapred.cache.files /tmp/centroids.txt;

-- register the udf jar
register pig-kmeans-udf-harp.jar;

-- DEFINE find_centroid FindCentroid('$centroids');
raw = load '"""+hdfsInputDir+"""' using BinaryDataLoader('$centroids','"""+str(numOfCentroids)+"""') as (datapoints);


-- line below may be the bottleneck
datapointbag = foreach raw generate FLATTEN(datapoints) as datapointInString:chararray;
datapoint = foreach datapointbag generate STRSPLIT(datapointInString, ',', 5) as splitedDP;


-- line below may be the bottleneck
grouped = Group datapoint by splitedDP.$0;
newCentroids = foreach grouped generate CalculateNewCentroids($1);

-- Illustrate datapointbag;
store newCentroids into 'output';

