package monitors.hasNextOriginal;
/* Original JavaMOP 2.1 aspect for HasNext property */
import java.io.*;
import java.util.*;

import org.apache.commons.collections.map.*;

import java.lang.management.ManagementFactory;
import java.lang.management.MemoryPoolMXBean;
import java.lang.management.MemoryUsage;
import java.lang.ref.WeakReference;

class HasNextMonitor_1 implements Cloneable {
	public Object clone() {
		try {
			HasNextMonitor_1 ret = (HasNextMonitor_1) super.clone();
			return ret;
		}
		catch (CloneNotSupportedException e) {
			throw new InternalError(e.toString());
		}
	}
	int state;
	int event;

	boolean MOP_fail = false;

	public HasNextMonitor_1 () {
		state = 0;
		event = -1;

	}
	synchronized public final void create(Iterator i) {
		event = 1;

		switch(state) {
		case 0:
			switch(event) {
			case 1 : state = 3; break;
			default : state = -1; break;
			}
			break;
		case 1:
			switch(event) {
			default : state = -1; break;
			}
			break;
		case 2:
			switch(event) {
			case 3 : state = 3; break;
			case 2 : state = 2; break;
			default : state = -1; break;
			}
			break;
		case 3:
			switch(event) {
			case 3 : state = 1; break;
			case 2 : state = 2; break;
			default : state = -1; break;
			}
			break;
		default : state = -1;
		}

		MOP_fail = state == -1;
	}
	synchronized public final void hasnext(Iterator i) {
		event = 2;

		switch(state) {
		case 0:
			switch(event) {
			case 1 : state = 3; break;
			default : state = -1; break;
			}
			break;
		case 1:
			switch(event) {
			default : state = -1; break;
			}
			break;
		case 2:
			switch(event) {
			case 3 : state = 3; break;
			case 2 : state = 2; break;
			default : state = -1; break;
			}
			break;
		case 3:
			switch(event) {
			case 3 : state = 1; break;
			case 2 : state = 2; break;
			default : state = -1; break;
			}
			break;
		default : state = -1;
		}

		MOP_fail = state == -1;
	}
	synchronized public final void next(Iterator i) {
		event = 3;

		switch(state) {
		case 0:
			switch(event) {
			case 1 : state = 3; break;
			default : state = -1; break;
			}
			break;
		case 1:
			switch(event) {
			default : state = -1; break;
			}
			break;
		case 2:
			switch(event) {
			case 3 : state = 3; break;
			case 2 : state = 2; break;
			default : state = -1; break;
			}
			break;
		case 3:
			switch(event) {
			case 3 : state = 1; break;
			case 2 : state = 2; break;
			default : state = -1; break;
			}
			break;
		default : state = -1;
		}

		MOP_fail = state == -1;
	}
	synchronized public final boolean MOP_fail() {
		return MOP_fail;
	}
	synchronized public final void reset() {
		state = 0;
		event = -1;

		MOP_fail = false;
	}
}

public aspect HasNextMonitorAspectOriginal {
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

	static Map HasNext_i_Map = null;
	static volatile long monitor_counter = 0, has_next_counter = 0, next_counter = 0, error_counter = 0;
	static volatile boolean first_event = false;
	static volatile long starting_free_memory = 0, end_free_memory = 0;


	pointcut HasNext_create1() : (call(Iterator Collection+.iterator())) && !within(HasNextMonitor_1) && !within(HasNextMonitorAspectOriginal) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
	after () returning (Iterator i) : HasNext_create1() {

		//		if(!first_event)
			//		{
			//			first_event = true;
		//			starting_free_memory = Runtime.getRuntime().freeMemory();
		//		}

		boolean skipAroundAdvice = false;
		Object obj = null;

		HasNextMonitor_1 monitor = null;
		boolean toCreate = false;

		Map m = HasNext_i_Map;
		if(m == null){
			synchronized(indexing_lock) {
				m = HasNext_i_Map;
				if(m == null) m = HasNext_i_Map = makeMap(i);
			}
		}

		synchronized(HasNext_i_Map) {
			obj = m.get(i);

			monitor = (HasNextMonitor_1) obj;
			toCreate = (monitor == null);
			if (toCreate){

				monitor_counter++;
				monitor = new HasNextMonitor_1();
				m.put(i, monitor);

			}

		}
		if(monitor!=null)
		{
			monitor.create(i);
			if(monitor.MOP_fail()) {
				error_counter++;
				//System.err.println("! hasNext() has not been called" + " before calling next() for an" + " iterator");
				monitor.reset();
			}

		}
	}

	pointcut HasNext_hasnext1(Iterator i) : (call(* Iterator.hasNext()) && target(i)) && !within(HasNextMonitor_1) && !within(HasNextMonitorAspectOriginal) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
	after (Iterator i) : HasNext_hasnext1(i) {

		has_next_counter++;

		boolean skipAroundAdvice = false;
		Object obj = null;

		Map m = HasNext_i_Map;

		if(m == null){
			synchronized(indexing_lock) {
				m = HasNext_i_Map;
				if(m == null) m = HasNext_i_Map = makeMap(i);
			}
		}

		synchronized(HasNext_i_Map) {
			obj = m.get(i);

		}
		HasNextMonitor_1 monitor = (HasNextMonitor_1)obj;
		if(monitor != null) {
			monitor.hasnext(i);
			if(monitor.MOP_fail()) {
				error_counter++;
				//System.err.println("! hasNext() has not been called" + " before calling next() for an" + " iterator");
				monitor.reset();
			}

		}


	}

	pointcut HasNext_next1(Iterator i) : (call(* Iterator.next()) && target(i)) && !within(HasNextMonitor_1) && !within(HasNextMonitorAspectOriginal) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
	before (Iterator i) : HasNext_next1(i) {

		next_counter++;

		boolean skipAroundAdvice = false;
		Object obj = null;

		Map m = HasNext_i_Map;


		if(m == null){
			synchronized(indexing_lock) {
				m = HasNext_i_Map;
				if(m == null) m = HasNext_i_Map = makeMap(i);
			}
		}

		synchronized(HasNext_i_Map) {
			obj = m.get(i);

		}
		HasNextMonitor_1 monitor = (HasNextMonitor_1)obj;
		if(monitor != null) {
			monitor.next(i);
			if(monitor.MOP_fail()) {
				error_counter++;
				//System.err.println("! hasNext() has not been called" + " before calling next() for an" + " iterator");
				monitor.reset();
			}

		}

	}

	pointcut System_exit(): (call (* System.exit(int)));
	before(): System_exit(){
		//System.err.println("About to print the statistics--- \n");
	}

	void around(): System_exit()
	{
		System.err.println("The number of monitors created are : " + monitor_counter);
		System.err.println("hasNext counter : " + has_next_counter);
		System.err.println("next counter : " + next_counter);
		//System.err.println("error counter : " + error_counter);

		try {
			String memoryUsage = new String();
			List<MemoryPoolMXBean> pools = ManagementFactory.getMemoryPoolMXBeans();
			
			for (MemoryPoolMXBean pool : pools) 
			{
				MemoryUsage peak = pool.getPeakUsage();
				memoryUsage += String.format("Peak %s memory used: %,d%n", pool.getName(),peak.getUsed());
				memoryUsage += String.format("Peak %s memory reserved: %,d%n", pool.getName(), peak.getCommitted());
			}

			System.err.println(memoryUsage);

		} 
		catch (Throwable t) 
		{
			System.err.println("Exception in agent: " + t);
		}


	}

	pointcut mainMethod(): execution (public static void main(String[]));

	after(): mainMethod(){
		HasNext_i_Map = null;
	}
}

