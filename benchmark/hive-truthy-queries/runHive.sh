#!/bin/bash

hive -e "set hive.exec.parallel=true;
set hive.merge.mapfiles=false;
set hive.enforce.bucketing=true;
set hive.exec.mode.local.auto=false;
set hive.merge.mapfiles=false;
set hive.merge.mapredfiles=false;

ADD JAR hive-with-indexedhbase94.jar;
CREATE TEMPORARY FUNCTION getTweetIds as 'org.apache.indexedhbase.hive.IndexedHBaseIndexTableSchemaUDF'; 
CREATE TEMPORARY FUNCTION getTweets as 'org.apache.indexedhbase.hive.GetTweetWithTweetID';

-- create a bucketed tables with 8 partition files stored on HDFS
DROP TABLE IF EXISTS input;
CREATE TABLE IF NOT EXISTS input(tweetId String)
CLUSTERED BY (tweetId) INTO 8 BUCKETS
LOCATION '/tmp/relatedTweetIds';

set hive.enforce.bucketing=true;
set hive.merge.mapfiles=false;
set hive.merge.mapredfiles=false;
set hive.hadoop.supports.splittable.combineinputformat=false;
FROM test4 T
INSERT OVERWRITE TABLE input 
Select explode(getTweetIds(T.tweetIds)) where rowkey='#ff';

SET hive.exec.mode.local.auto=false;
set hive.hadoop.supports.splittable.combineinputformat=false;
set hive.merge.mapfiles=false;
set hive.merge.mapredfiles=false;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;
set mapred.map.tasks = 8;

INSERT OVERWRITE DIRECTORY '/tmp/HiveRelatedTweets' 
Select getTweets(tweetId,'2012-12') as tweet FROM input CLUSTER BY tweet;"
