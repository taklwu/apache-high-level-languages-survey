rmr $outputDirectory;
finalOut = LOAD '$outputFile' using PigStorage() as (source:chararray,pagerank:double);
STORE finalOut INTO '$outputDirectory';
