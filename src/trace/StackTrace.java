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
	
	public static void insertMethodID(long id)
	{
		switch (counter) 
		{
		case 0:
			id <<= 32;
			//trace |= id;
			//trace &= 0xffffffffffffL;
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
		//trace &= 0xffffffffffffL;
		counter = (counter + 1) % traceLength;
	}
	
	public static void main(String[] args) {
		
		insertMethodID(0xFFL);
		insertMethodID(0xffL);
		insertMethodID(0xffL);
		
		//System.out.printf("0x%08X", trace);
	}
}
