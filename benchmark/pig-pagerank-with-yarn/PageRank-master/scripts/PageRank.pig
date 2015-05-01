REGISTER PageRank.jar;
SET default_parallel $parallelism;
--SET mapred.min.split.size  3000000;
--SET mapred.max.split.size  3000000;
SET pig.noSplitCombination true;
original_data = LOAD '$inputFile' USING edu.iub.cloud.pr.CustomLoaderMatchedSplits('$noOfURLs','$iteration') as (datapoints:bag{});

datapointbag = foreach original_data generate FLATTEN(datapoints) as (source:chararray,pagerank:double,out:bag{});

-- final = FOREACH datapointbag GENERATE FLATTEN(out) as source,pagerank/SIZE(out) as pagerank;
-- STORE datapointbag INTO '$outputFile';

previous_pagerank = FOREACH datapointbag GENERATE FLATTEN(out) as source,pagerank/SIZE(out) as pagerank;
new_pagerank = FOREACH (COGROUP datapointbag by source , previous_pagerank by source OUTER) GENERATE group as source , (1-$dampingFactor)/$noOfURLs+$dampingFactor*(SUM(previous_pagerank.pagerank) IS NULL ? 0:SUM(previous_pagerank.pagerank)) as pagerank, FLATTEN(datapointbag.out) as out;
STORE new_pagerank INTO '$outputFile' ;
