-- getTweetIds with specified rowkey as #ff, timestamp isn't supported correctly
-- note that pig cannot use random access, you will need write your own UDF to do GET from HBASE with a specified rowkey

register 'udfs.py' using jython as py;
register 'pig-with-indexedhbase94.jar';
SET pig.noSplitCombination true;

rmf $outputDir;

-- parallel scanning with TweetIds partitions from HBase
foundRelatedTweetIds = LOAD '$inputDir' AS (month:chararray, tID:chararray);

-- find all the memes with this tweetID, need a UDF to use 
tweetContent = foreach foundRelatedTweetIds GENERATE hbaseudf.getTweetsWithTweetIds(tID, month) AS (content:chararray);

STORE tweetContent INTO '$outputDir';
-- illustrate memes;
