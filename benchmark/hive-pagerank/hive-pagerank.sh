#!/bin/bash

if [ $# -ne 5 ]; then
    echo "Usage: ./hive-pagerank.sh INPUTDIR_ON_HDFS MAP_SIZE numOfUrls dampingFactor Iterations"
    exit 255;
fi

INPUTDIR=$1
MAP_SIZE=$2
numOfUrls=$3
dampingFactor=$4
iteration=$5

COUNTER=0

echo "-- Run PageRank First iteration..."
hive -e "
ADD jar hive-with-scientific-apps.jar;

SET hive.exec.mode.local.auto=false;
SET hive.hadoop.supports.splittable.combineinputformat=false;
SET hive.merge.mapfiles=false;
SET hive.merge.mapredfiles=false;
SET hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;
SET mapreduce.job.reduces=$MAP_SIZE;

CREATE TEMPORARY FUNCTION InitialPageRank as 'org.apache.hive.scientific.apps.pagerank.PageRankUDF';
CREATE TEMPORARY FUNCTION CalculateCurrentPageRank as 'org.apache.hive.scientific.apps.pagerank.CalculateCurrentPageRank';

DROP TABLE IF EXISTS pageRankInput;
CREATE EXTERNAL TABLE IF NOT EXISTS pageRankInput(line String)
location '/user/taklwu/pagerankTests/$INPUTDIR';

DROP TABLE IF EXISTS PageRankComputeTable;
CREATE TABLE IF NOT EXISTS PageRankComputeTable(pagerankCell struct<source:int,pagerank:double,outLinks:array<int>>)
CLUSTERED BY(pagerankCell) INTO $MAP_SIZE BUCKETS
location '/tmp/HivePageRankResult';

SET hive.enforce.bucketing = true;
INSERT OVERWRITE TABLE PageRankComputeTable
select InitialPageRank (line, '$numOfUrls') as ret FROM pageRankInput;

SET hive.enforce.bucketing = true;
INSERT OVERWRITE TABLE PageRankComputeTable
Select named_struct('source', T1.pagerankCell.source,
             'pagerank', CalculateCurrentPageRank(T2.prv_pagerank, 0.85, 1000000),
             'outLinks', T1.pagerankCell.outLinks) as cell
FROM
PageRankComputeTable T1
LEFT OUTER JOIN
(select outlink, sum(pagerankCell.pagerank/size(pagerankCell.outlinks)) as prv_pagerank
FROM PageRankComputeTable
LATERAL VIEW explode(pagerankCell.outlinks) outLinkTable as outlink
Group by outlink) T2
ON (T1.pagerankCell.source = T2.outlink);
"

let COUNTER=COUNTER+1

while [ $COUNTER -lt $iteration ]; do
# after 1st iterations
    echo "-- Run hive PageRank iteration $COUNTER ..."    

hive -e "
ADD jar hive-with-scientific-apps.jar;

SET hive.exec.mode.local.auto=false;
SET hive.hadoop.supports.splittable.combineinputformat=false;
SET hive.merge.mapfiles=false;
SET hive.merge.mapredfiles=false;
SET hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;
SET mapreduce.job.reduces=$MAP_SIZE;
CREATE TEMPORARY FUNCTION CalculateCurrentPageRank as 'org.apache.hive.scientific.apps.pagerank.CalculateCurrentPageRank';

SET hive.enforce.bucketing = true;
INSERT OVERWRITE TABLE PageRankComputeTable
Select named_struct('source', T1.pagerankCell.source,
             'pagerank', CalculateCurrentPageRank(T2.prv_pagerank, 0.85, 1000000),
             'outLinks', T1.pagerankCell.outLinks) as cell
FROM
PageRankComputeTable T1
LEFT OUTER JOIN
(select outlink, sum(pagerankCell.pagerank/size(pagerankCell.outlinks)) as prv_pagerank
FROM PageRankComputeTable
LATERAL VIEW explode(pagerankCell.outlinks) outLinkTable as outlink
Group by outlink) T2
ON (T1.pagerankCell.source = T2.outlink);
"
    let COUNTER=COUNTER+1 
done

echo "Please check result /tmp/HivePageRankResult on HDFS"
