//*************************************************************************************
//*********************************************************************************** *
//author Aritra Dhar 																* *
//Research Engineer																  	* *
//Xerox Research Center India													    * *
//Bangalore, India																    * *
//--------------------------------------------------------------------------------- * * 
///////////////////////////////////////////////// 									* *
//The program will do the following:::: // 											* *
///////////////////////////////////////////////// 									* *
//version 1.0 																		* *
//*********************************************************************************** *
//*************************************************************************************


package monitors.hasNext;

import java.util.ArrayList;
import java.util.Iterator;

public class HasNextTest {

	
	public static void main(String[] args) {

		ArrayList<Integer> al = new ArrayList<>();
		al.add(1);
		al.add(2);
		al.add(3);
		al.add(4);
		al.add(5);
		
		Iterator<Integer> it = al.iterator();
		while(it.hasNext())
		{
			it.next();
			//it.next();
		}
		
		System.exit(0);
	}
	
}
