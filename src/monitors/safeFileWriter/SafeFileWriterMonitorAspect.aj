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
				System.out.println("write after close");
				monitor.reset();
			}
			if(monitor.MOP_match()) {
				System.out.println((++(monitor.counter)) + ":" + monitor.writes);
			}

		}
	}

}

