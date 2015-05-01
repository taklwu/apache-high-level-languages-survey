#!/bin/bash

time hive -e "set hive.exec.parallel=true;
set hive.merge.mapfiles=false;
set hive.enforce.bucketing=true; set hive.exec.mode.local.auto=false;
set hive.merge.mapfiles=false;
set hive.merge.mapredfiles=false;

ADD JAR hive-with-indexedhbase94.jar;
CREATE TEMPORARY FUNCTION getrelatedTweetIds as 'org.apache.indexedhbase.hive.GetTweetIDsFromMemeIndexTable'; 
CREATE TEMPORARY FUNCTION getrelatedTweets as 'org.apache.indexedhbase.hive.GetTweetWithTweetID';

DROP TABLE textIndexTable;
CREATE EXTERNAL TABLE textIndexTable(rowkey String, tweetIds map<string,string>)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key, t:')
TBLPROPERTIES('hbase.table.name' = 'textIndexTable-2012-12');

--create a bucketed tables with 24 partition files stored on HDFS
DROP TABLE IF EXISTS input;
CREATE TABLE IF NOT EXISTS input(tweetId String)
CLUSTERED BY (tweetId) INTO 24 BUCKETS
LOCATION '/tmp/HiveRelatedTweetIds';

set hive.enforce.bucketing=true;
set hive.merge.mapfiles=false;
set hive.merge.mapredfiles=false;
set hive.hadoop.supports.splittable.combineinputformat=false;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;
FROM textIndexTable T
INSERT OVERWRITE TABLE input 
Select explode(getrelatedTweetIds(T.tweetIds)) where rowkey='nba';

SET hive.exec.mode.local.auto=false;
set hive.hadoop.supports.splittable.combineinputformat=false;
set hive.merge.mapfiles=false;
set hive.merge.mapredfiles=false;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;
set mapred.map.tasks = 24;
set mapreduce.job.reduces=24;

INSERT OVERWRITE DIRECTORY '/tmp/HiveRelatedTweets' 
Select getrelatedTweets(tweetId,'2012-12') as tweet FROM input;"
