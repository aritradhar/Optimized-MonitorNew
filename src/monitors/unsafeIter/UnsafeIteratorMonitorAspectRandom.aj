package monitors.unsafeIter;
/* Original JavaMOP 2.1 aspect for UnsafeIterator property*/

import java.lang.management.ManagementFactory;
import java.lang.management.MemoryPoolMXBean;
import java.lang.management.MemoryUsage;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.commons.collections.map.*;

import trace.StackTrace;


public aspect UnsafeIteratorMonitorAspectRandom {
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

	public static Random rand = new Random();
	static Map<Object, Object> indexing_lock = new HashMap<>();

	static Map<Object, Object> UnsafeIterator_c_i_Map = null;
	static Map<Object, Object> UnsafeIterator_c_Map = null;
	static Map<Object, Object> UnsafeIterator_i_Map = null;

	static long maxTimeUpdate = 0;

	static volatile Map<Long, List<Object>> monitor_trace_map = new ConcurrentHashMap<>();

	static volatile long monitor_counter = 0, next_counter = 0, update_counter = 0, error_counter = 0;

	pointcut UnsafeIterator_create1(Collection c) : (call(Iterator Collection+.iterator()) && target(c)) && !within(UnsafeIteratorMonitor) && !within(UnsafeIteratorMonitorAspectRandom) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
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

					if(rand.nextInt() % 2 == 0)
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

	pointcut UnsafeIterator_updatesource1(Collection c) : ((call(* Collection+.remove*(..)) || call(* Collection+.add*(..))) && target(c)) && !within(UnsafeIteratorMonitor) && !within(UnsafeIteratorMonitorAspectRandom) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
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

	pointcut UnsafeIterator_next1(Iterator i) : (call(* Iterator.next()) && target(i)) && !within(UnsafeIteratorMonitor) && !within(UnsafeIteratorMonitorAspectRandom) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
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