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

import java.util.HashSet;
import java.util.Iterator;


public aspect HasNextSingleMonitor {

	public static volatile HashSet<Object> one_state = new HashSet<>();
	public static volatile HashSet<Object> two_state = new HashSet<>();
	public static volatile HashSet<Object> error_state = new HashSet<>();

	public static volatile int next_counter = 0;
	public static volatile int has_next_counter = 0;
	public static volatile int error_counter = 0;

	//public static volatile int f1 = 0, f2 = 0;
	
	public static long overhead = 0;

	pointcut HasNext_hasnext1(Iterator i) : (call(* Iterator.hasNext()) && target(i)) 
	&& !within(HasNextSingleMonitor) && !adviceexecution();
	after (Iterator i) : HasNext_hasnext1(i) 
	{
		//long start = System.currentTimeMillis();
		boolean flag = false;

		has_next_counter++;

		synchronized (one_state) 
		{
			if(one_state.contains(i))
			{
				//overhead += System.currentTimeMillis() - start;
				flag = true;
				return;
			}
		}

		synchronized(two_state)
		{
			if(two_state.contains(i)  && !flag)
			{
				two_state.remove(i);
				one_state.add(i);
				//overhead += System.currentTimeMillis() - start;
				flag = true;
				return;
			}
		}
		synchronized(error_state)
		{
			if(error_state.contains(i) && !flag)
			{
				//overhead += System.currentTimeMillis() - start;
				error_counter++;
				//System.err.println(i + " in error state");
				//final_printer();
				//overhead += System.currentTimeMillis() - start;
				flag = true;
				return;
			}
		}

		synchronized(one_state)
		{
			if(!flag)
			{
				one_state.add(i);
			}
		}

		//overhead += System.currentTimeMillis() - start;

	}

	pointcut HasNext_next1(Iterator i) : (call(* Iterator.next()) && target(i)) 
	&& !within(HasNextSingleMonitor) && !adviceexecution();
	before (Iterator i) : HasNext_next1(i) 
	{
		long start = System.currentTimeMillis();
		boolean flag = false;
		next_counter++;

		synchronized(one_state)
		{
			//f1++;
			if(one_state.contains(i))
			{		
				one_state.remove(i);
				two_state.add(i);
				//overhead += System.currentTimeMillis() - start;
				flag = true;
				return;
			}
		}

		synchronized(two_state)
		{
			//f2++;
			if(two_state.contains(i) && !flag)
			{
				error_counter++;
				two_state.remove(i);
				error_state.add(i);
				//System.err.println(i + " transition to error state");
				final_printer();
				flag = true;
				//overhead += System.currentTimeMillis() - start;
				return;
			}
		}
		synchronized(error_state)
		{
			if(error_state.contains(i) && !flag)
			{
				error_counter++;
				//System.err.println(i + " in error state");
				//final_printer();
				//overhead += System.currentTimeMillis() - start;
				flag = true;
				return;
			}
		}
		if(!flag)
		{
			error_state.add(i);
			error_counter++;
		}
	}

	pointcut UnsafeIterator_exit1() : (call(* System.exit(..))) && !within(HasNextSingleMonitor) && !adviceexecution();
	before () : UnsafeIterator_exit1() 
	{
		final_printer();
	}

	public static void final_printer()
	{
		System.err.println("next : " + next_counter);
		System.err.println("has next : " + has_next_counter);
		System.err.println("error : " + error_counter);
		//System.err.println("f1 : " + f1);
		//System.err.println("f2 : " + f2);
		//System.err.println("overhead : " + overhead + " ms");
	}
}
