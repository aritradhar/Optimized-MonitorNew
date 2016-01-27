/* Original JavaMOP 2.1 aspect for HasNext property */

package test;

import java.lang.management.ManagementFactory;
import java.lang.management.MemoryPoolMXBean;
import java.lang.management.MemoryUsage;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.commons.collections.map.*;

import trace.StackTrace;

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

public aspect HasNextMonitorAspectOptimized {
	@SuppressWarnings("unchecked")
	static Map<Object, Object> makeMap(Object key){
		if (key instanceof String) {
			return new HashMap();
		} else {
			return new ReferenceIdentityMap(AbstractReferenceMap.WEAK, AbstractReferenceMap.HARD, true);
		}
	}
	static List<Object> makeList(){
		return new ArrayList();
	}

	static long max_hasnext = 0, max_next = 0 , max_create=0;
	static long min_hasnext = Long.MAX_VALUE, min_next = Long.MAX_VALUE, min_create = Long.MAX_VALUE;

	static volatile Map<Object, Object> indexing_lock = new HashMap();

	static volatile Map<Object, Object> HasNext_i_Map = null;

	static volatile Map<Long, List<Object>> monitor_trace_map = new ConcurrentHashMap();
	
	static volatile Map<Object, Object> iterContextMap = new HashMap();
	
	static volatile Set<Object> errorContext = new HashSet();
	
	static volatile long prob_created = 0;

	pointcut HasNext_create1() : (call(Iterator Collection+.iterator())) && !within(HasNextMonitor_1) && !within(HasNextMonitorAspectOptimized)  && !within(trace.StackTrace) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
	@SuppressWarnings("rawtypes")
	after () returning (Iterator i) : HasNext_create1() {
		
		long startTime = System.currentTimeMillis();
		//creation_logged++;
		
		boolean skipAroundAdvice = false;
		Object obj = null;

		HasNextMonitor_1 monitor = null;
		boolean toCreate = false;

		Map<Object, Object> m = HasNext_i_Map;
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
				
				long currentStackTrace = StackTrace.trace;
				if(monitor_trace_map.containsKey(currentStackTrace))
				{
					List<Object> monitors = monitor_trace_map.get(currentStackTrace);
					int creationCounter = monitors.size();
					double monitorCreationProb = HasNextMonitor_1.getMonitorCreation(creationCounter);
					
					if(new Random().nextDouble() < monitorCreationProb)
					{
						prob_created++;
						monitor = new HasNextMonitor_1();
						m.put(i, monitor);
						monitors.add(monitor);
						monitor_trace_map.put(currentStackTrace, monitors);
						iterContextMap.put(i, currentStackTrace);
						//monitor_counter++;
					}
				}
				
				else
				{
					monitor = new HasNextMonitor_1();
					m.put(i, monitor);
					List<Object> monitors = new ArrayList();
					monitors.add(monitor);	
					monitor_trace_map.put(currentStackTrace, monitors);
					iterContextMap.put(i, currentStackTrace);
					//monitor_counter++;
				}
			}

		}
		if(monitor!=null)
		{
			monitor.create(i);
			if(monitor.MOP_fail()) {
				//System.err.println("! hasNext() has not been called" + " before calling next() for an" + " iterator");
				errorContext.add(iterContextMap.get(i));
				//error_counter++;
				monitor.reset();
			}

		}

	    long duration = (System.currentTimeMillis() - startTime);  
	    //System.out.println("Duration: " + duration);

	    if(duration > max_create && duration > 0)
	    {
	    	max_create = duration;
	    }

	    if(duration < min_create && duration > 0)
	    {
	    	min_create = duration;
	    }
	}

	@SuppressWarnings("rawtypes")
	pointcut HasNext_hasnext1(Iterator i) : (call(* Iterator.hasNext()) && target(i)) && !within(trace.StackTrace) && !within(HasNextMonitor_1) && !within(HasNextMonitorAspectOptimized) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
	after (Iterator i) : HasNext_hasnext1(i) {
		
		//has_next_counter++;
		long startTime = System.currentTimeMillis();

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
				//error_counter++;
				//System.err.println("! hasNext() has not been called" + " before calling next() for an" + " iterator");
				errorContext.add(iterContextMap.get(i));
				monitor.reset();
			}

		}

	    long duration = (System.currentTimeMillis() - startTime);  
	    //System.out.println("Duration: " + duration);

	    if(duration > max_hasnext && duration > 0)
	    {
	    	max_hasnext = duration;
	    }

	    if(duration < min_hasnext && duration > 0)
	    {
	    	min_hasnext = duration;
	    }


	}

	pointcut HasNext_next1(Iterator i) : (call(* Iterator.next()) && target(i)) && !within(HasNextMonitor_1) && !within(trace.StackTrace) && !within(HasNextMonitorAspectOptimized) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
	before (Iterator i) : HasNext_next1(i) {
		
		//next_counter++;
		long startTime = System.currentTimeMillis();

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
				//error_counter++;
				//System.err.println("! hasNext() has not been called" + " before calling next() for an" + " iterator");
				errorContext.add(iterContextMap.get(i));
				monitor.reset();
			}

		}

	    long duration = (System.currentTimeMillis() - startTime);  
	    //System.out.println("Duration: " + duration);

	    if(duration > max_next && duration > 0)
	    {
	    	max_next = duration;
	    }

	    if(duration < min_next && duration > 0)
	    {
	    	min_next = duration;
	    }

	}

	pointcut System_exit(): (call (* System.exit(int)));
	before(): System_exit(){
		//System.err.println("About to print the statistics--- \n");
		//System.err.println("The number of monitors created are : " + monitor_counter);
		//System.err.println("HasNext counter : " + has_next_counter);
		//System.err.println("next counter : " + next_counter);
	}

	void around(): System_exit()
	{
		System.out.println("Max create : "+ max_create);
		System.out.println("Max hasnext : "+ max_hasnext);
		System.out.println("Max next : "+ max_next);
		System.out.println("Min create : "+ min_create);
		System.out.println("Min hasnext : "+ min_hasnext);
		System.out.println("Min next : "+ min_next);
		
	}

	pointcut mainMethod(): execution (public static void main(String[]));

	after(): mainMethod(){
		HasNext_i_Map = null;
	}
}

