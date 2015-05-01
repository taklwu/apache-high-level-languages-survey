#!/bin/bash

time hive -e "set hive.exec.parallel=true;
set hive.merge.mapfiles=false;
set hive.exec.mode.local.auto=false;
set hive.merge.mapfiles=false;
set hive.merge.mapredfiles=false;
set hive.enforce.bucketing=true;


ADD JAR hive-with-indexedhbase94.jar;
CREATE TEMPORARY FUNCTION getrelatedTweetIds as 'org.apache.indexedhbase.hive.GetTweetIDsFromMemeIndexTable'; 
CREATE TEMPORARY FUNCTION getrelatedTweets as 'org.apache.indexedhbase.hive.GetTweetWithTweetID';

DROP TABLE IndexTable;
CREATE EXTERNAL TABLE IndexTable(rowkey int, tweetIds map<STRING,STRING>)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key#b, t:')
TBLPROPERTIES('hbase.table.name' = 'userTweetsIndexTable-2012-12');

--create a bucketed tables with 24 partition files stored on HDFS
DROP TABLE IF EXISTS input;
CREATE TABLE IF NOT EXISTS input(tweetId String)
LOCATION '/tmp/HiveRelatedTweetIds';

set hive.merge.mapfiles=false;
set hive.merge.mapredfiles=false;
set hive.hadoop.supports.splittable.combineinputformat=false;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;
set hive.enforce.bucketing=true;

FROM IndexTable T
INSERT OVERWRITE TABLE input 
Select explode(getrelatedTweetIds(T.tweetIds)) where rowkey=8401422;

set hive.enforce.bucketing=true;
SET hive.exec.mode.local.auto=false;
INSERT OVERWRITE DIRECTORY '/tmp/HiveRelatedTweets' 
Select getrelatedTweets(tweetId,'2012-12') as tweet FROM input;"
