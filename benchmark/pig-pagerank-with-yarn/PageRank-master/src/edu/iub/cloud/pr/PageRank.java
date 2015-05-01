package edu.iub.cloud.pr;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.apache.hadoop.conf.Configuration;
import org.apache.log4j.Logger;
import org.apache.pig.ExecType;
import org.apache.pig.PigServer;
import org.apache.pig.backend.executionengine.ExecException;
import org.apache.pig.tools.pigstats.PigStats;


/**
 * Implementation of PageRank in Pig Embeded in Java
 * 
 * <br>
 *  Usage : javac PageRank
 *  <br> java PageRank 	numberOfUrls dampingFactor iteration inputFile outputFile
 * 
 * @author Abhilash(akoppula@indiana.edu)
 *
 */
public class PageRank {
	
	Logger logger = Logger.getLogger("PIG_PAGE_RANK");
	FileUtils fileUtils  = null;
	PigServer pigServer = null;
	String numberOfIterations = null;
	Map<String, String> properties = null;
	
	
	
	/***
	 * Constructor with numberOfIterations as parameter
	 * 
	 * @param numberOfIterations
	 * @throws IOException
	 */
	
	public PageRank(String numberOfIterations) throws IOException {
		this.numberOfIterations = numberOfIterations;
		fileUtils = new FileUtils(numberOfIterations);		
		try {
			Configuration configuration = new Configuration();
			configuration.setBoolean("pig.noSplitCombination",true);
			configuration.setInt("default_parallel", 4);
			pigServer = new PigServer(ExecType.MAPREDUCE,configuration);
			properties = new HashMap<String, String>();
		} catch (ExecException e) {
			logger.error("Error while instantiating the PageRank object " + e.getDetailedMessage());
		}
		
	}
	
	
	/**
	 * Invokes Ranking.pig scrpit which takes the output of the final iteartion
	 * and stores URL and pagerank in the given output directory
	 * 
	 * @param iterationOutputFile - ouput of the final iteration of pagerank
	 * @param outputDirectory - output directory to write the page rank scores
	 */
	public void runOutputScript(String iterationOutputFile , String outputDirectory) {
		logger.info("Running Ranking.pig script");
		properties.put("outputFile", iterationOutputFile+numberOfIterations);
		properties.put("outputDirectory", outputDirectory);
		try {
			pigServer.registerScript("Rankings.pig", properties);
			pigServer.shutdown();
		} catch (IOException e) {
			logger.error("Error while running Ranking.pig scripg " + e.getMessage());
		}
	}
	
	/**
	 * Invokes the PageRank.pig script iteratively for given number of times . The output of each iteration
	 * becomes input of next iteration. Also after every iteration stats are written to summary file
	 * 
	 * @param inputFile - Input records
	 * @param dampingFactor - damping Factor
	 * @param numberOfURLs - number of iterations
	 */
			
	public void runPageRankScript(String inputFile,String dampingFactor, String numberOfURLs , String iterationOutputFile) {
		try {
			properties.put("noOfURLs", numberOfURLs);
			properties.put("dampingFactor", dampingFactor);
			properties.put("inputFile", inputFile);
			properties.put("outputFile", iterationOutputFile+"1");
			for (int iteration = 1; iteration <= Integer
					.parseInt(numberOfIterations); iteration++) {
				logger.info("Running PageRank for iteration - " + iteration);
				properties.put("iteration", String.valueOf(iteration-1));
				pigServer.registerScript("PageRank.pig", properties);
				logger.info("Writing stats for iteration - " + iteration);
				fileUtils.writeToFile(PigStats.get(), iteration);
				properties.put("inputFile", iterationOutputFile + iteration);
				properties.put("outputFile", iterationOutputFile + (iteration+1));	
			}
			fileUtils.writeSummary();
		} catch (Exception ex) {
			logger.error("Error while running PageRank.pig script " + ex.getMessage());
		}
	}

	
	public static void main(String[] args) throws IOException {
		if (args.length < 5) {
			System.out.println("****************************************************");
			System.out.println("Inavalid number of arguments");
			System.out.println("Usage : java PageRank <noOfURLs> <dampingFactor> <numberOfIterations> <inputFile> <outputFile>");
			System.out.println("****************************************************");
		} else {
			String numOfURLs = args[0];
			String dampingFactor = args[1];
			String numberOfIterations = args[2];
			String inputFile = args[3];
			String outputFile = args[4];
			String iterationOutputFile = outputFile+"_iter/";

			PageRank pageRank = new PageRank(numberOfIterations);
			pageRank.runPageRankScript(inputFile, dampingFactor,
					numOfURLs,iterationOutputFile);
			pageRank.runOutputScript(iterationOutputFile,outputFile);
		}
	}
}
