REGISTER PageRank.jar;
SET default_parallel $parallelism;
SET pig.noSplitCombination true;
SET pig.SplitCombination false;
rmf $outputFile;
original_data = LOAD '$inputFile' USING edu.iub.cloud.pr.CustomLoader('$noOfURLs','$iteration') as (source:chararray,pagerank:double,out:bag{});
previous_pagerank = FOREACH original_data GENERATE FLATTEN(out) as source,pagerank/SIZE(out) as pagerank;
new_pagerank = FOREACH (COGROUP original_data by source , previous_pagerank by source OUTER) 
               GENERATE group as source , (1-$dampingFactor)/$noOfURLs+$dampingFactor*(SUM(previous_pagerank.pagerank) IS NULL ? 0:SUM(previous_pagerank.pagerank)) as pagerank, FLATTEN(original_data.out) as out;
STORE new_pagerank INTO '$outputFile' ;
