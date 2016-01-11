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


package trace;

public class StackTrace {

	public static long trace;
	public static int counter = 0;
	public static int traceLength = 3;
	
	synchronized public static void insertMethodID(long id)
	{
		switch (counter) 
		{
		case 0:
			id <<= 32;
			break;

		case 1:
			id <<= 16;
			
		case 2:
			id <<= 0;
			
		default:
			break;
		}
		//System.out.printf("0x%08X\n", id);
		trace |= id;
		trace &= 0xffffffffffffL;
		counter = (counter + 1) % traceLength;
	}
	
	synchronized public static void insertMethodID1(long id)
	{
		trace = trace << 16;
		trace &= 0xffffffffffffL;
		trace |= id;
		counter = (counter + 1) % traceLength;
	}
	
	public static void main(String[] args) {
		
		insertMethodID1(0xFFFFL);
		insertMethodID1(0xABEEL);
		insertMethodID1(0x1199L);
		insertMethodID1(0x0001L);
		
		System.out.printf("0x%08X", trace);
	}
}
