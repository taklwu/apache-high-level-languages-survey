register 'udfs.py' using jython as py;
register 'pig-with-indexedhbase94.jar';
rmf $outputDir

TweetIds = load '/tmp/baseIndexTableName.txt' using org.apache.pig.backend.hadoop.hbase.IndexedHBaseStorage('-index=$indexType -rowKeys=$rowKeys -startDateTime=$startDateTime -endDateTime=$endDateTime') AS (relatedTweetIds);

-- extract all tuples with a single bag
tmpResult = foreach TweetIds GENERATE FLATTEN(relatedTweetIds) as (tableNameAndRelatedTweetId);

-- making alias
databag = foreach tmpResult GENERATE FLATTEN(STRSPLIT(tableNameAndRelatedTweetId, '_', 2)) as (tableName, relatedTweetId);

-- store to HDFS outputDir
STORE databag INTO '$outputDir' USING hbaseudf.MultiFilesStorage('$outputDir', '\\t', '$tweetIdPerFile') ;

