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

DROP TABLE memeIndexTable;
CREATE EXTERNAL TABLE memeIndexTable(rowkey String, tweetIds map<string,string>)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key, t:')
TBLPROPERTIES('hbase.table.name' = 'memeIndexTable-2014-10');

-- create a bucketed tables with 24 partition files stored on HDFS
DROP TABLE IF EXISTS memeInput;
CREATE TABLE IF NOT EXISTS memeInput(tweetId String)
CLUSTERED BY (tweetId) INTO 24 BUCKETS
LOCATION '/tmp/HiveMemeRelatedTweetIds201410';

set hive.enforce.bucketing=true;
set hive.merge.mapfiles=false;
set hive.merge.mapredfiles=false;
set hive.hadoop.supports.splittable.combineinputformat=false;

FROM memeIndexTable T 
INSERT OVERWRITE TABLE memeInput 
Select explode(getrelatedTweetIds(T.tweetIds)) where rowkey='#ff';"
