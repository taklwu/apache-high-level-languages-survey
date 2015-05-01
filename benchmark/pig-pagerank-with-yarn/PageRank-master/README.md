PageRank
========

Page Rank algorithm implementation in pig

For the ease of running on the remote server , all the files are copied in [**server**][server] directory . SCP the server directory to remote server and follow below instructions


Compilation
---------------
+  To run Pig in JAVA embeded mode , all the Pig and Hadoop jars have to be available in the java CLASSPATH . Set the classpath as below

           export CLASSPATH=$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:
           export CLASSPATH=$CLASSPATH:$HADOOP_HOME/share/hadoop/hdfs/*:
           export CLASSPATH=$CLASSPATH:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/https/*:
           export CLASSPATH=$CLASSPATH:$HADOOP_CONF_DIR:$HADOOP_HOME/share/hadoop/yarn/*:$PIG_HOME/pig-0.12.1.jar:.

+ Compile the FileUtils.java and PageRank.java 
           
           javac FileUtils.java
           javac PageRank.java

Running
---------------
+ PageRank class two script files . These two scripts need to be available in the same directory of class file .
           
   + **PageRank.pig** - PageRank algorithm implementaion
   + **Rankings.pig** - To write the pagerank values in a seperate file
+ This page rank implementation uses custom loader class . This class is compiled into PageRank.jar file . Copy this jar file into HDFS .
           
           hdfs dfs -copyFromLocal PageRank.jar .
+ The input for page rank is available at [SALSA][SALSA] webpage . Download this to your remote server and copy to HDFS . For multiple mappers , split the input file into required partions

           wget http://salsahpc.indiana.edu/csci-p434-fall-2013/apps/PageRankInput/*
           split -l <noOfLines> fileName
           hdfs dfs -copyFromLocal inputDirectory/* .

+ PageRank class accepts 5 input parameters
    + noOfUrls - total unique URLs in the input
    + df - damping Factor
    + iter - number of Iterations
    + input - HDFS input directory
    + output - HDFS output directory

                      java PageRank 100000 0.15 1 pagerank100k.input0 run1

+ After the successful execution of the program , Statistics.txt file is generated with statistics of the run.



[server]:https://github.com/abhilashkoppula/PageRank/tree/master/server
[SALSA]:http://salsahpc.indiana.edu/csci-p434-fall-2013/apps/PageRankInput/           
