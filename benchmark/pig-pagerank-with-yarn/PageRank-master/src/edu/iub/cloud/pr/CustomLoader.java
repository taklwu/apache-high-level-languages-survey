package edu.iub.cloud.pr;

import java.io.IOException;

import org.apache.hadoop.io.Text;
import org.apache.pig.backend.executionengine.ExecException;
import org.apache.pig.builtin.PigStorage;
import org.apache.pig.data.BagFactory;
import org.apache.pig.data.DataBag;
import org.apache.pig.data.Tuple;
import org.apache.pig.data.TupleFactory;

/**
 * 
 * Custom loader class to load the cluWeb09 dataset for
 * implementing page rank algorithm . This custom loader 
 * is used only in the first iteration as the input is raw and from 
 * next iterations it is redirected to used default pig storage.
 * 
 * 
 * @author Abhilash(akoppula@indiana.edu)
 *
 */
public class CustomLoader extends PigStorage {

	/**
	 * Number of URLs in the input
	 */
	private int noOfURLs = 0; 
	/**
	 * To indicate the iteration
	 */
	private boolean intialLoading = false;
	private TupleFactory tupleFactory = null;
	

	public CustomLoader(String noOfURLs, String iteration) {
		super();
		tupleFactory = TupleFactory.getInstance();
		this.noOfURLs = Integer.parseInt(noOfURLs);
		this.intialLoading = Integer.parseInt(iteration) > 0 ? false : true;
	}

	/**
	 * Overriding to output the tuple as 
	 * (source:int , pagerank:double , out:bag{}) .
	 * <br>
	 * Pagerank is calculated as 1/numberOfURLs.
	 * <br><br>
	 * <b> Eg : </b> If input line is (1 2 3 4) the output tuples is (1,1/4,(2,3,4))
	 * <br>
	 * <br>
	 * <b>Note : </b> This method only for the 0th iteration.
	 * 
	 */

	@Override
	public Tuple getNext() throws IOException {
		if (intialLoading) {
			Tuple tuple = tupleFactory.newTuple(3);
			double pageRank = (double) 1 / noOfURLs;
			try {
				if (!in.nextKeyValue()) {
					return null;
				}
				Text value = (Text) in.getCurrentValue();
				String valueString = value.toString();
				String[] splitString = valueString.split(" ");
				DataBag dataBag = BagFactory.getInstance().newDefaultBag();
				Tuple subTuple = null;
				tuple.set(0, splitString[0]);
				tuple.set(1, pageRank);
				for (int i = 1; i <= splitString.length - 1; i++) {
					subTuple = tupleFactory.newTuple(1);
					subTuple.set(0, splitString[i]);
					dataBag.add(subTuple);
				}
				tuple.set(2, dataBag);

			} catch (Exception ex) {
				 int errCode = 6018;
			     String errMsg = "Error while reading input";
			    throw new ExecException(errMsg, errCode, (byte)16, ex);
				
			}

			return tuple;
		} else {
			return super.getNext();
		}
	}
}
