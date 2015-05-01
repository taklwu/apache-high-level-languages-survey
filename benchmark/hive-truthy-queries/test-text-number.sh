#!/bin/bash

hive -e "set hive.exec.parallel=true;
set hive.merge.mapfiles=false;
set hive.enforce.bucketing=true;
set hive.exec.mode.local.auto=false;
set hive.merge.mapfiles=false;
set hive.merge.mapredfiles=false;

ADD JAR hive-with-indexedhbase94.jar;
CREATE TEMPORARY FUNCTION getrelatedTweetIds as 'org.apache.indexedhbase.hive.GetTweetIDsFromTextIndexTable'; 
CREATE TEMPORARY FUNCTION getrelatedTweets as 'org.apache.indexedhbase.hive.GetTweetWithTweetID';

DROP TABLE textIndexTable;
CREATE EXTERNAL TABLE textIndexTable(rowkey String, tweetIds map<String,String>)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler' 
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key, t:') 
TBLPROPERTIES('hbase.table.name' = 'textIndexTable-2012-11');

-- create a bucketed tables with 24 partition files stored on HDFS
DROP TABLE IF EXISTS textInput;
CREATE TABLE IF NOT EXISTS textInput(tweetId String)
CLUSTERED BY (tweetId) INTO 24 BUCKETS
LOCATION '/tmp/HiveTextRelatedTweetIds';

set hive.enforce.bucketing=true;
set hive.merge.mapfiles=false;
set hive.merge.mapredfiles=false;
set hive.hadoop.supports.splittable.combineinputformat=false;

FROM textIndexTable T
Select getrelatedTweetIds(tweetIds) where rowkey='smart';"
