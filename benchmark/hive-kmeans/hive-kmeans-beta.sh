#!/bin/bash

if [ $# -ne 5 ]; then
    echo "Usage: ./hive-kmeans.sh INPUTDIR_ON_HDFS MAP_SIZE Local_CentroidFile_UNDER_TMP CentroidSize Iteration"
    exit 255;
fi

INPUTDIR=$1
MAP_SIZE=$2
centroidFile=$3
centroidSize=$4
iteration=$5

COUNTER=0

cp $centroidFile /tmp/hiveTmpCentroids.txt

while [ $COUNTER -lt $iteration ]; do
    
    hadoop fs -copyFromLocal -f /tmp/hiveTmpCentroids.txt /tmp/hiveTmpCentroids.txt
# for each round
    echo "run hive kmeans iteration $COUNTER"    

    time hive -e "
ADD jar hive-with-scientific-apps.jar;

DROP TABLE $INPUTDIR;
CREATE EXTERNAL TABLE $INPUTDIR (filename String) 
STORED AS INPUTFORMAT 'org.apache.hive.scientific.apps.inputformat.FilePathInputFormatH1' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/user/taklwu/kmeansTest/$INPUTDIR';

SET hive.exec.mode.local.auto=false;
SET hive.hadoop.supports.splittable.combineinputformat=false;
SET hive.merge.mapfiles=false;
SET hive.merge.mapredfiles=false;
SET hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;
SET mapreduce.job.reduces=8;
CREATE TEMPORARY FUNCTION KMeans as 'org.apache.hive.scientific.apps.kmeans.KmeansUDF';

DROP TABLE IF EXISTS interKmeansTable;
CREATE TABLE IF NOT EXISTS interKmeansTable(x double, y double, z double, beta double)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' '
STORED AS TEXTFILE
location '/tmp/hiveKmeans/';

INSERT OVERWRITE TABLE interKmeansTable
Select sum(KmeansTable.ret.x)/sum(KmeansTable.ret.count), sum(KmeansTable.ret.y)/sum(KmeansTable.ret.count), sum(KmeansTable.ret.z)/sum(KmeansTable.ret.count), 0.0
From (Select explode(Kmeans(INPUT__FILE__NAME, '/tmp/hiveTmpCentroids.txt', '$centroidSize')) as ret From $INPUTDIR T) KmeansTable
GROUP BY KmeansTable.ret.assignedcentroid;"
    echo "Combine centroids to /tmp/hiveTmpCentroids.txt"
    time hadoop fs -cat /tmp/hiveKmeans/00*_* > /tmp/hiveTmpCentroids.txt
    let COUNTER=COUNTER+1 
done
