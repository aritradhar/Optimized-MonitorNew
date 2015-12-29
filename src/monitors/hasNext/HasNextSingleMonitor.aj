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
	
	public static long overhead = 0;
	
	pointcut HasNext_hasnext1(Iterator i) : (call(* Iterator.hasNext()) && target(i)) 
	&& !within(HasNextSingleMonitor) && !adviceexecution();
	after (Iterator i) : HasNext_hasnext1(i) 
	{
		long start = System.currentTimeMillis();
		
		has_next_counter++;
		if(one_state.contains(i))
		{
			overhead += System.currentTimeMillis() - start;
			return;
		}
		
		else if(two_state.contains(i))
		{
			two_state.remove(i);
			one_state.add(i);
			overhead += System.currentTimeMillis() - start;
			return;
		}
		else if(error_state.contains(i))
		{
			overhead += System.currentTimeMillis() - start;
			error_counter++;
			System.err.println(i + " in error state");
			//final_printer();
			overhead += System.currentTimeMillis() - start;
			return;
		}
		else
			one_state.add(i);
		
		
		overhead += System.currentTimeMillis() - start;
		
	}

	pointcut HasNext_next1(Iterator i) : (call(* Iterator.next()) && target(i)) 
	&& !within(HasNextSingleMonitor) && !adviceexecution();
	before (Iterator i) : HasNext_next1(i) 
	{
		long start = System.currentTimeMillis();
		
		next_counter++;
		if(one_state.contains(i))
		{
			one_state.remove(i);
			two_state.add(i);
			overhead += System.currentTimeMillis() - start;
			return;
		}
		else if(two_state.contains(i))
		{
			error_counter++;
			two_state.remove(i);
			error_state.add(i);
			System.err.println(i + " transition to error state");
			error_counter++;
			final_printer();
			overhead += System.currentTimeMillis() - start;
			return;
		}
		else if(error_state.contains(i))
		{
			error_counter++;
			System.err.println(i + " in error state");
			//final_printer();
			overhead += System.currentTimeMillis() - start;
			return;
		}
	}
	
	pointcut UnsafeIterator_exit1() : (call(* System.exit(..))) && !within(HasNextSingleMonitor) && !adviceexecution();
	before () : UnsafeIterator_exit1() 
	{
		System.out.println("next : " + next_counter);
		System.out.println("has next : " + has_next_counter);
		System.out.println("error : " + error_counter);
		System.out.println("overhead : " + overhead + " ms");
	}
	
	public static void final_printer()
	{
		System.out.println("next : " + next_counter);
		System.out.println("has next : " + has_next_counter);
		System.out.println("error : " + error_counter);
		System.out.println("overhead : " + overhead + " ms");
	}

	
}