SET pig.noSplitCombination true;

SET mapred.cache.files /tmp/$initialCentroidFileOnHDFS#$initialCentroidFileOnHDFS

register pigudf.jar

rmf $outputDir;
-- we need $inputDir, $initialCentroidFileOnHDFS, $numOfCentroids, $pointsPerFile, $numOfCenPartitions, $iteration, $outputDir
-- A = LOAD 'input3' using TestMapObject('50000centroids.txt', '50000', '24' ,'41664', '10') as (datapoints);

A = LOAD '$inputDir' using HarpKmeans('$initialCentroidFileOnHDFS', '$numOfCentroids', '$pointsPerFile', '$numOfCenPartitions', '$iteration', '$jobID') as (datapoints);
-- B = foreach A generate $0 as id;
STORE A into '$outputDir';
