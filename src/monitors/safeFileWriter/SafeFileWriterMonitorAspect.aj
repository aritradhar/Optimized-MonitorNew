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


package monitors.safeFileWriter;

import java.io.*;
import java.util.*;

import org.apache.commons.collections.map.*;

import java.lang.management.ManagementFactory;
import java.lang.management.MemoryPoolMXBean;
import java.lang.management.MemoryUsage;
import java.lang.ref.WeakReference;

class SafeFileWriterMonitor_1 implements Cloneable {
	public Object clone() {
		try {
			SafeFileWriterMonitor_1 ret = (SafeFileWriterMonitor_1) super.clone();
			return ret;
		}
		catch (CloneNotSupportedException e) {
			throw new InternalError(e.toString());
		}
	}
	static int counter = 0;
	int writes = 0;
	int state;
	int event;

	boolean MOP_fail = false;
	boolean MOP_match = false;

	public SafeFileWriterMonitor_1 () {
		state = 0;
		event = -1;

	}
	synchronized public final void open(FileWriter f) {
		event = 1;

		switch(state) {
			case 0:
			switch(event) {
				case 1 : state = 1; break;
				default : state = -1; break;
			}
			break;
			case 1:
			switch(event) {
				case 2 : state = 2; break;
				default : state = -1; break;
			}
			break;
			case 2:
			switch(event) {
				case 2 : state = 2; break;
				case 3 : state = 0; break;
				default : state = -1; break;
			}
			break;
			default : state = -1;
		}

		MOP_fail = state == -1
		;
		MOP_match = state == 0;
		{
			this.writes = 0;
		}
	}
	synchronized public final void write(FileWriter f) {
		event = 2;

		switch(state) {
			case 0:
			switch(event) {
				case 1 : state = 1; break;
				default : state = -1; break;
			}
			break;
			case 1:
			switch(event) {
				case 2 : state = 2; break;
				default : state = -1; break;
			}
			break;
			case 2:
			switch(event) {
				case 2 : state = 2; break;
				case 3 : state = 0; break;
				default : state = -1; break;
			}
			break;
			default : state = -1;
		}

		MOP_fail = state == -1
		;
		MOP_match = state == 0;
		{
			this.writes++;
		}
	}
	synchronized public final void close(FileWriter f) {
		event = 3;

		switch(state) {
			case 0:
			switch(event) {
				case 1 : state = 1; break;
				default : state = -1; break;
			}
			break;
			case 1:
			switch(event) {
				case 2 : state = 2; break;
				default : state = -1; break;
			}
			break;
			case 2:
			switch(event) {
				case 2 : state = 2; break;
				case 3 : state = 0; break;
				default : state = -1; break;
			}
			break;
			default : state = -1;
		}

		MOP_fail = state == -1
		;
		MOP_match = state == 0;
	}
	synchronized public final boolean MOP_fail() {
		return MOP_fail;
	}
	synchronized public final boolean MOP_match() {
		return MOP_match;
	}
	synchronized public final void reset() {
		state = 0;
		event = -1;

		MOP_fail = false;
		MOP_match = false;
	}
	
	synchronized public static double getMonitorCreation(long count)
	{				
		if(count >= 0 && count < 1000){
			return 1;
		}

		else if(count >= 1000 && count < 5000){
			return 0.5;
		}

		else if(count >= 5000 && count < 10000){
			return 0.25;
		}

		else if(count >= 10000 && count < 200000){
			return 0.125;
		}

		else if(count >= 200000 && count < 350000){
			return 0.0625;
		}

		else if(count >= 350000 && count < 800000){
			return 0.03125;
		}

		else if(count >= 800000 && count < 1200000){
			return 0.015625;
		}

		else if(count >= 1200000 && count < 1800000){
			return 0.0078125;
		}

		else if(count >= 1800000 && count < 2000000){
			return 0.00390625;
		}

		else{
			return 0.001953125;
		}
	}
}

public aspect SafeFileWriterMonitorAspect {
	static Map makeMap(Object key){
		if (key instanceof String) {
			return new HashMap();
		} else {
			return new ReferenceIdentityMap(AbstractReferenceMap.WEAK, AbstractReferenceMap.HARD, true);
		}
	}
	static List makeList(){
		return new ArrayList();
	}

	static Map indexing_lock = new HashMap();

	static Map SafeFileWriter_f_Map = null;
	
	public static int monitor_counter = 0, write_counter = 0, close_counter = 0, error_counter = 0; 

	pointcut SafeFileWriter_open1() : (call(FileWriter.new(..))) && !within(SafeFileWriterMonitor_1) && !within(SafeFileWriterMonitorAspect) && !adviceexecution();
	after () returning (FileWriter f) : SafeFileWriter_open1() {
		boolean skipAroundAdvice = false;
		Object obj = null;

		SafeFileWriterMonitor_1 monitor = null;
		boolean toCreate = false;

		Map m = SafeFileWriter_f_Map;
		if(m == null){
			synchronized(indexing_lock) {
				m = SafeFileWriter_f_Map;
				if(m == null) m = SafeFileWriter_f_Map = makeMap(f);
			}
		}

		synchronized(SafeFileWriter_f_Map) {
			obj = m.get(f);

			monitor = (SafeFileWriterMonitor_1) obj;
			toCreate = (monitor == null);
			if (toCreate){
				monitor = new SafeFileWriterMonitor_1();
				m.put(f, monitor);
			}

		}

		{
			monitor.open(f);
			if(monitor.MOP_fail()) {
				System.out.println("write after close");
				monitor.reset();
			}
			if(monitor.MOP_match()) {
				System.out.println((++(monitor.counter)) + ":" + monitor.writes);
			}

		}
	}

	pointcut SafeFileWriter_write1(FileWriter f) : (call(* write(..)) && target(f)) && !within(SafeFileWriterMonitor_1) && !within(SafeFileWriterMonitorAspect) && !adviceexecution();
	before (FileWriter f) : SafeFileWriter_write1(f) {
		
		write_counter++;
		boolean skipAroundAdvice = false;
		Object obj = null;

		SafeFileWriterMonitor_1 monitor = null;
		boolean toCreate = false;

		Map m = SafeFileWriter_f_Map;
		if(m == null){
			synchronized(indexing_lock) {
				m = SafeFileWriter_f_Map;
				if(m == null) m = SafeFileWriter_f_Map = makeMap(f);
			}
		}

		synchronized(SafeFileWriter_f_Map) {
			obj = m.get(f);

			monitor = (SafeFileWriterMonitor_1) obj;
			toCreate = (monitor == null);
			if (toCreate){
				monitor = new SafeFileWriterMonitor_1();
				m.put(f, monitor);
			}

		}

		{
			monitor.write(f);
			if(monitor.MOP_fail()) {
				
				error_counter++;
				System.out.println("write after close");
				monitor.reset();
			}
			if(monitor.MOP_match()) {
				System.out.println((++(monitor.counter)) + ":" + monitor.writes);
			}

		}
	}

	pointcut SafeFileWriter_close1(FileWriter f) : (call(* close(..)) && target(f)) && !within(SafeFileWriterMonitor_1) && !within(SafeFileWriterMonitorAspect) && !adviceexecution();
	after (FileWriter f) : SafeFileWriter_close1(f) {
		
		close_counter++;
		boolean skipAroundAdvice = false;
		Object obj = null;

		SafeFileWriterMonitor_1 monitor = null;
		boolean toCreate = false;

		Map m = SafeFileWriter_f_Map;
		if(m == null){
			synchronized(indexing_lock) {
				m = SafeFileWriter_f_Map;
				if(m == null) m = SafeFileWriter_f_Map = makeMap(f);
			}
		}

		synchronized(SafeFileWriter_f_Map) {
			obj = m.get(f);

			monitor = (SafeFileWriterMonitor_1) obj;
			toCreate = (monitor == null);
			if (toCreate){
				monitor = new SafeFileWriterMonitor_1();
				m.put(f, monitor);
			}

		}

		{
			monitor.close(f);
			if(monitor.MOP_fail()) {
				error_counter++;
				System.out.println("write after close");
				monitor.reset();
			}
			if(monitor.MOP_match()) {
				System.out.println((++(monitor.counter)) + ":" + monitor.writes);
			}

		}
	}
	
	pointcut System_exit(): (call (* System.exit(int)));

	before(): System_exit(){
		//System.err.println("About to print the statistics--- \n");
	}

	void around(): System_exit(){
		
		int m_counter = (SafeFileWriter_f_Map == null) ? 0 : SafeFileWriter_f_Map.size();
		System.err.println("Total monitors : " + m_counter);
		System.err.println("write counter : " + write_counter);
		System.err.println("close counter : " + close_counter);
		System.err.println("error counter : " + error_counter);
		//memory profiling
//		
//		try {
//			String memoryUsage = new String();
//			List<MemoryPoolMXBean> pools = ManagementFactory.getMemoryPoolMXBeans();
//			
//			for (MemoryPoolMXBean pool : pools) 
//			{
//				MemoryUsage peak = pool.getPeakUsage();
//				memoryUsage += String.format("Peak %s memory used: %,d%n", pool.getName(),peak.getUsed());
//				memoryUsage += String.format("Peak %s memory reserved: %,d%n", pool.getName(), peak.getCommitted());
//			}
//
//			System.err.println(memoryUsage);
//
//		} 
//		catch (Throwable t) 
//		{
//			System.err.println("Exception in agent: " + t);
//		}
		
	}

}

