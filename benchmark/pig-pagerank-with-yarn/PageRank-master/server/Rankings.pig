outFinal = LOAD '$outputFile' using PigStorage() as (source:chararray,pagerank:double);
STORE outFinal INTO '$outputDirectory';
