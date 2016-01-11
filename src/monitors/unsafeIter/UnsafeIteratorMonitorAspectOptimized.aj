package monitors.unsafeIter;
/* Original JavaMOP 2.1 aspect for UnsafeIterator property*/

import java.lang.management.ManagementFactory;
import java.lang.management.MemoryPoolMXBean;
import java.lang.management.MemoryUsage;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.commons.collections.map.*;

import trace.StackTrace;

class UnsafeIteratorMonitor implements Cloneable {
	public Object clone() {
		try {
			UnsafeIteratorMonitor ret = (UnsafeIteratorMonitor) super.clone();
			return ret;
		}
		catch (CloneNotSupportedException e) {
			throw new InternalError(e.toString());
		}
	}
	int state;
	int event;

	boolean MOP_match = false;

	public UnsafeIteratorMonitor () {
		state = 0;
		event = -1;

	}
	synchronized public final void create(Collection c, Iterator i) {
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
			case 3 : state = 1; break;
			default : state = -1; break;
			}
			break;
		case 2:
			switch(event) {
			case 2 : state = 2; break;
			case 3 : state = 3; break;
			default : state = -1; break;
			}
			break;
		case 3:
			switch(event) {
			default : state = -1; break;
			}
			break;
		default : state = -1;
		}

		MOP_match = state == 3;
	}
	synchronized public final void updatesource(Collection c) {
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
			case 3 : state = 1; break;
			default : state = -1; break;
			}
			break;
		case 2:
			switch(event) {
			case 2 : state = 2; break;
			case 3 : state = 3; break;
			default : state = -1; break;
			}
			break;
		case 3:
			switch(event) {
			default : state = -1; break;
			}
			break;
		default : state = -1;
		}

		MOP_match = state == 3;
	}
	synchronized public final void next(Iterator i) {
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
			case 3 : state = 1; break;
			default : state = -1; break;
			}
			break;
		case 2:
			switch(event) {
			case 2 : state = 2; break;
			case 3 : state = 3; break;
			default : state = -1; break;
			}
			break;
		case 3:
			switch(event) {
			default : state = -1; break;
			}
			break;
		default : state = -1;
		}

		MOP_match = state == 3;
	}

	synchronized public final boolean MOP_match() {
		return MOP_match;
	}

	synchronized public final void reset() {
		state = 0;
		event = -1;

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

public aspect UnsafeIteratorMonitorAspectOptimized {
	@SuppressWarnings("unchecked")
	static Map<Object, Object> makeMap(Object key){
		if (key instanceof String) {
			return new HashMap<Object, Object>();
		} else {
			return new ReferenceIdentityMap(AbstractReferenceMap.WEAK, AbstractReferenceMap.HARD, true);
		}
	}
	static List<Object> makeList(){
		return new ArrayList<Object>();
	}

	static Map<Object, Object> indexing_lock = new HashMap<>();

	static Map<Object, Object> UnsafeIterator_c_i_Map = null;
	static Map<Object, Object> UnsafeIterator_c_Map = null;
	static Map<Object, Object> UnsafeIterator_i_Map = null;

	static long maxTimeUpdate = 0;

	static volatile Map<Long, List<Object>> monitor_trace_map = new ConcurrentHashMap<>();

	static volatile long monitor_counter = 0, next_counter = 0, update_counter = 0, error_counter = 0;

	pointcut UnsafeIterator_create1(Collection c) : (call(Iterator Collection+.iterator()) && target(c)) && !within(UnsafeIteratorMonitor) && !within(UnsafeIteratorMonitorAspectOptimized) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
	@SuppressWarnings("unchecked")
	after (Collection c) returning (Iterator i) : UnsafeIterator_create1(c) {
		boolean skipAroundAdvice = false;
		Object obj = null;

		UnsafeIteratorMonitor monitor = null;
		boolean toCreate = false;

		Map<Object, Object> m = UnsafeIterator_c_i_Map;
		if(m == null){
			synchronized(indexing_lock) {
				m = UnsafeIterator_c_i_Map;
				if(m == null) m = UnsafeIterator_c_i_Map = makeMap(c);
			}
		}

		synchronized(UnsafeIterator_c_i_Map) {
			obj = m.get(c);
			if (obj == null) {
				obj = makeMap(i);
				m.put(c, obj);
			}
			m = (Map<Object, Object>)obj;
			obj = m.get(i);

			monitor = (UnsafeIteratorMonitor) obj;
			toCreate = (monitor == null);
			if (toCreate)
			{
				//add trace info 
				long currentStackTrace = StackTrace.trace;

				if(monitor_trace_map.containsKey(currentStackTrace))
				{
					List<Object> monitors = monitor_trace_map.get(currentStackTrace);
					int creationCounter = monitors.size();
					double monitorCreationProb = UnsafeIteratorMonitor.getMonitorCreation(creationCounter);

					if(new Random().nextDouble() < monitorCreationProb)
					{
						monitor_counter++;
						monitor = new UnsafeIteratorMonitor();
						m.put(i, monitor);
						monitors.add(monitor);
						monitor_trace_map.put(currentStackTrace, monitors);
						monitor_counter++;
					}
					else
						return;
				}

				else
				{
					monitor_counter++;
					monitor = new UnsafeIteratorMonitor();
					m.put(i, monitor);
					List<Object> monitors = new ArrayList<>();
					monitors.add(monitor);	
					monitor_trace_map.put(currentStackTrace, monitors);
					monitor_counter++;
				}
			}
			if(toCreate) {
				m = UnsafeIterator_c_Map;
				if (m == null) m = UnsafeIterator_c_Map = makeMap(c);
				obj = null;
				synchronized(UnsafeIterator_c_Map) 
				{
					obj = m.get(c);
					List<Object> monitors = (List)obj;
					if (monitors == null) {
						monitors = makeList();
						m.put(c, monitors);
					}
					monitors.add(monitor);
				}//end of adding

				m = UnsafeIterator_i_Map;
				if (m == null) m = UnsafeIterator_i_Map = makeMap(i);
				obj = null;
				synchronized(UnsafeIterator_i_Map) {
					obj = m.get(i);
					List<Object> monitors = (List<Object>)obj;
					if (monitors == null) {
						monitors = makeList();
						m.put(i, monitors);
					}
					monitors.add(monitor);
				}//end of adding
			}

			if(monitor != null)
			{
				monitor.create(c,i);
				if(monitor.MOP_match()) {
					error_counter++;
					System.out.println("improper iterator usage");
				}

			}

		}
	}

	pointcut UnsafeIterator_updatesource1(Collection c) : ((call(* Collection+.remove*(..)) || call(* Collection+.add*(..))) && target(c)) && !within(UnsafeIteratorMonitor) && !within(UnsafeIteratorMonitorAspectOptimized) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
	after (Collection c) : UnsafeIterator_updatesource1(c) {

		update_counter++;
		boolean skipAroundAdvice = false;
		Object obj = null;
		Map<Object, Object> m = UnsafeIterator_c_Map;

		if(m == null){
			synchronized(indexing_lock) {
				m = UnsafeIterator_c_Map;
				if(m == null) m = UnsafeIterator_c_Map = makeMap(c);
			}
		}

		synchronized(UnsafeIterator_c_Map) {
			obj = m.get(c);

		}
		if (obj != null) {
			synchronized(obj) {
				for(UnsafeIteratorMonitor monitor : (List<UnsafeIteratorMonitor>)obj) {
					if(monitor != null)
					{
						monitor.updatesource(c);
						if(monitor.MOP_match()) {
							error_counter++;
							System.err.println("improper iterator usage");
						}
					}

				}
			}
		}

	}

	pointcut UnsafeIterator_next1(Iterator i) : (call(* Iterator.next()) && target(i)) && !within(UnsafeIteratorMonitor) && !within(UnsafeIteratorMonitorAspectOptimized) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
	before (Iterator i) : UnsafeIterator_next1(i) {

		next_counter++;

		boolean skipAroundAdvice = false;
		Object obj = null;

		Map<Object, Object> m = UnsafeIterator_i_Map;

		if(m == null){
			synchronized(indexing_lock) {
				m = UnsafeIterator_i_Map;
				if(m == null) m = UnsafeIterator_i_Map = makeMap(i);
			}
		}

		synchronized(UnsafeIterator_i_Map) {
			obj = m.get(i);

		}
		if (obj != null) {
			synchronized(obj) {
				for(UnsafeIteratorMonitor monitor : (List<UnsafeIteratorMonitor>)obj) {
					if(monitor != null)
					{
						monitor.next(i);
						if(monitor.MOP_match()) {
							error_counter++;
							System.out.println("improper iterator usage");
						}
					}	

				}
			}
		}


	}
	pointcut System_exit(): (call (* System.exit(int)));

	before(): System_exit(){
		//System.err.println("About to print the statistics--- \n");
	}

	void around(): System_exit(){
		System.err.println("Total monitors : " + monitor_counter);
		System.err.println("next counter : " + next_counter);
		System.err.println("update counter : " + update_counter);
		System.err.println("error counter : " + error_counter);
		//memory profiling
		
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

	before(): mainMethod(){

		UnsafeIterator_i_Map = null;
		UnsafeIterator_c_i_Map = null;
		UnsafeIterator_c_Map = null;
	}

}