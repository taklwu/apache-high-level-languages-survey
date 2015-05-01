#!/bin/bash

# 2000k tests
nohup time -p java -cp $CLASSPATH PageRank 2000000 0.85 10 pagerankTests/2000k64m8r run1k64m8r 64 > ~/BookChapter-2015-04/pagerank/2000k64m8r-run1.log
nohup time -p java -cp $CLASSPATH PageRank 2000000 0.85 10 pagerankTests/2000k64m8r run1k64m8r 64 > ~/BookChapter-2015-04/pagerank/2000k64m8r-run2.log
nohup time -p java -cp $CLASSPATH PageRank 2000000 0.85 10 pagerankTests/2000k64m8r run1k64m8r 64 > ~/BookChapter-2015-04/pagerank/2000k64m8r-run3.log

sleep 10
# 1000k tests
nohup time -p java -cp $CLASSPATH PageRank 1000000 0.85 10 pagerankTests/1000k64m8r run1k64m8r 64 > ~/BookChapter-2015-04/pagerank/1000k64m8r-run1.log
nohup time -p java -cp $CLASSPATH PageRank 1000000 0.85 10 pagerankTests/1000k64m8r run1k64m8r 64 > ~/BookChapter-2015-04/pagerank/1000k64m8r-run2.log
nohup time -p java -cp $CLASSPATH PageRank 1000000 0.85 10 pagerankTests/1000k64m8r run1k64m8r 64 > ~/BookChapter-2015-04/pagerank/1000k64m8r-run3.log
