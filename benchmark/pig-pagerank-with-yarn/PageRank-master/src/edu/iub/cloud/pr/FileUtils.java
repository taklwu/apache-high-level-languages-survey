package edu.iub.cloud.pr;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.apache.pig.tools.pigstats.JobStats;
import org.apache.pig.tools.pigstats.PigStats;



/**
 * 
 * File Utills class to write the summary to a file
 * 
 * @author Abhilash(akoppula@indiana.edu)
 *
 */
public class FileUtils {

	static final String FILE_NAME = "Statistics.txt"; 
	Logger logger = Logger.getLogger("PIG_PAGE_RANK");
	String numberOfIterations = null;
	 long numberOfRecords = 0;
	 long totalTimeTaken = 0;
	 

	 
	 public FileUtils(String numberOfIterations) {
		this.numberOfIterations = numberOfIterations;
		
	}
	 
	/**
	 * Writes the stats of the given iteration.
	 * 
	 * @param stats - PigStats object after the execution
	 * @param iteration - current iteration number
	 */
	public void writeToFile(PigStats stats, int iteration) {
		List<JobStats> jobStats = null;
		try (BufferedWriter fileWriter = new BufferedWriter(new FileWriter(FILE_NAME , true));) {
			if(iteration == 1){
				fileWriter.write("********************************** BEGIN STATS -"+ getCurrentTime() + "  *************************************");
				fileWriter.write("\n");
				numberOfRecords = stats.getRecordWritten();
			}
			fileWriter.write("^^^^^^^^^^^^^^^^^^^^^^^^ Stats for iteration -"
					+ iteration + " ^^^^^^^^^^^^^^^^^^^^^^^^");
			fileWriter.write("\n");
			fileWriter.write("Time taken for this iteration :: "
					+ stats.getDuration());
			fileWriter.write("\n");
			 totalTimeTaken += stats.getDuration();
			jobStats = stats.getJobGraph().getJobList();
			for (JobStats jobStat : jobStats) {
				fileWriter.write("### Stats for Job :: " + jobStat.getJobId() + " ###");
				fileWriter.write("\n");
				fileWriter.write("Avg Map Time :: " + jobStat.getAvgMapTime());
				fileWriter.write("\n");
				fileWriter.write("Avg Redue Time :: " + jobStat.getAvgREduceTime());
				fileWriter.write("\n");
				fileWriter.write("Feature  :: " + jobStat.getFeature());
				fileWriter.write("\n");
				fileWriter.write("Max Map Time :: " + jobStat.getMaxMapTime());
				fileWriter.write("\n");
				fileWriter.write("Max Reduce Time :: " + jobStat.getAvgMapTime());
				fileWriter.write("\n");
				fileWriter.write("Number of Maps :: " + jobStat.getNumberMaps());
				fileWriter.write("\n");
				fileWriter.write("Number of Reduces :: "
						+ jobStat.getNumberReduces());
				fileWriter.write("\n");
			}

		} catch (Exception ex) {
			logger.error("Error while writing stats" + ex.getMessage());
		}

	}
	
	/**
	 * Write the summary of the execution like total time taken , data size and number of iterations.
	 */
	public void writeSummary() {		
		try (BufferedWriter fileWriter = new BufferedWriter(new FileWriter(FILE_NAME,true));) {
			
			fileWriter.write("********************************** SUMMARY OF PAGE RANK ********************************************");
			fileWriter.write("\n");
			fileWriter.write("TOTAL TIME TAKEN  :: " + totalTimeTaken);
			fileWriter.write("\n");
			fileWriter.write("DATA SIZE IN RECORDS  :: " + numberOfRecords);
			fileWriter.write("\n");
			fileWriter.write("NUMBER OF ITERATIONS:: " + numberOfIterations);
			fileWriter.write("********************************************* END OF STATS *****************************************");
			
		} catch (Exception ex) {
			logger.error("Error while writing stats summary to file " + ex.getMessage());
		}

	}
	
	 /** Returns the current time in the  format YYYY-M-dd-HH-mm-SSS
	 * 
	 * @return - returns date in the above mentioned format
	 */
	private String getCurrentTime() {
		Date date = new Date(System.currentTimeMillis());
		SimpleDateFormat dateFormat = new SimpleDateFormat(
				"YYYY-M-dd-HH-mm-SSS");
		return dateFormat.format(date);

	}

}
