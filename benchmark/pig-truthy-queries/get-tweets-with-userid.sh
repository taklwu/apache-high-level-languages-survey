#!/bin/bash

indexType=userid
outputDir=/tmp/PigUserIds
rowKeys=8401422
startDateTime=2012-12-01
endDateTime=2012-12-31
tweetIdPerFile=22
TweetsOutputDir=/tmp/PigRelatedUserIdsTweetsContent 

hadoop fs -rm -r -f /tmp/PigTextIds
hadoop fs -rm -r -f /tmp/PigRelatedMemeTweetsContents
time pig -x mapreduce -p indexType=$indexType -p outputDir=$outputDir -p rowKeys=$rowKeys -p startDateTime=$startDateTime -p endDateTime=$endDateTime -p tweetIdPerFile=$tweetIdPerFile get-tweetId-by-index-no-multifile.pig
time pig -x mapreduce -p inputDir=$outputDir -p outputDir=$TweetsOutputDir get-tweets-with-tweetIds.pig
