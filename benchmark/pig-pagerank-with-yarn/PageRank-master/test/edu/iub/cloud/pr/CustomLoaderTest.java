package edu.iub.cloud.pr;

import static org.junit.Assert.*;



import org.apache.pig.data.Tuple;
import org.junit.Test;


public class CustomLoaderTest {

	@Test
	public void testValidInput() throws Exception {
		MockReader reader = new MockReader("sampledata.tsv");
		CustomLoader custLoader = new CustomLoader("100", "1");
		custLoader.prepareToRead(reader, null);

		Tuple tuple = custLoader.getNext();
		assertNotNull(tuple);
		assertEquals("1", (String) tuple.get(0));
		assertEquals(0.2d, (double) tuple.get(1));

	}

}
