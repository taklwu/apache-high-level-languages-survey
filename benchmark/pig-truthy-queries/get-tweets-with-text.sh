#!/bin/bash

indexType=text
outputDir=/tmp/PigTextIds
rowKeys=nba
startDateTime=2012-12-01
endDateTime=2012-12-31
tweetIdPerFile=8600
TweetsOutputDir=/tmp/PigRelatedMemeTweetsContent 

hadoop fs -rm -r -f /tmp/PigTextIds
hadoop fs -rm -r -f /tmp/PigRelatedMemeTweetsContents
time pig -x mapreduce -p indexType=$indexType -p outputDir=$outputDir -p rowKeys=$rowKeys -p startDateTime=$startDateTime -p endDateTime=$endDateTime -p tweetIdPerFile=$tweetIdPerFile get-tweetId-by-index.pig 
time pig -x mapreduce -p inputDir=$outputDir -p outputDir=$TweetsOutputDir get-tweets-with-tweetIds.pig
