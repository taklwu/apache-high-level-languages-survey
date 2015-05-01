-- pig pagerank on harp script 
SET pig.noSplitCombination true;

rmf $outputDir

register pig-harp-apps.jar

A = LOAD '$inputDir' using HarpPageRank('$totalVtx', '$numMaps', '$partitionPerWorker', '$iteration', '$jobID') as (datapoints);
-- B = foreach A generate $0 as id;
STORE A into '$outputDir';
