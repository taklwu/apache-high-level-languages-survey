#!/bin/bash

hadoop fs -rm -r -f /tmp/memeIds
hadoop fs -rm -r -f /tmp/relatedMemeTweetsContents
pig -x mapreduce -p indexType=meme -p outputDir=/tmp/memeIds -p rowKeys=\\#ff -p startDateTime=2012-12-01 -p endDateTime=2012-12-31 -p tweetIdPerFile=65500 get-tweetId-by-index.pig 
pig -x mapreduce -p inputDir=/tmp/memeIds -p outputDir=/tmp/relatedMemeTweetsContents get-tweets-with-tweetIds-text.pig
