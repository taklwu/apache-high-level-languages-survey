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

DROP TABLE userIndexTable;
CREATE EXTERNAL TABLE userIndexTable(rowkey Int, tweetIds map<String,String>)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler' 
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key#b, t:') 
TBLPROPERTIES('hbase.table.name' = 'userTweetsIndexTable-2010-11');

set hive.enforce.bucketing=true;
set hive.merge.mapfiles=false;
set hive.merge.mapredfiles=false;
set hive.hadoop.supports.splittable.combineinputformat=false;

--FROM userIndexTable T
--INSERT OVERWRITE DIRECTORY '/tmp/testTextIndexTable/'
Select getrelatedTweetIds(tweetIds) FROM userIndexTable where rowkey=8389172;"
