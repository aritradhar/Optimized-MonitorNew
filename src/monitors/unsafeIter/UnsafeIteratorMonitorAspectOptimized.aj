package monitors.unsafeIter;
/* Original JavaMOP 2.1 aspect for UnsafeIterator property*/

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import org.apache.commons.collections.map.*;

import trace.StackTrace;

class UnsafeIteratorMonitor_1 implements Cloneable {
	public Object clone() {
		try {
			UnsafeIteratorMonitor_1 ret = (UnsafeIteratorMonitor_1) super.clone();
			return ret;
		}
		catch (CloneNotSupportedException e) {
			throw new InternalError(e.toString());
		}
	}
	int state;
	int event;

	boolean MOP_match = false;

	public UnsafeIteratorMonitor_1 () {
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
		if(count >= 0 && count < 10){
			return 1;
		}

		else if(count >= 10 && count < 50){
			return 0.5;
		}

		else if(count >= 50 && count < 100){
			return 0.25;
		}

		else if(count >= 100 && count < 500){
			return 0.125;
		}

		else if(count >= 500 && count < 1000){
			return 0.0625;
		}

		else if(count >= 1000 && count < 2000){
			return 0.03125;
		}

		else if(count >= 2000 && count < 4000){
			return 0.015625;
		}

		else if(count >= 4000 && count < 7000){
			return 0.0078125;
		}

		else if(count >= 7000 && count < 10000){
			return 0.00390625;
		}

		else{
			return 0;
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
	
	static volatile long monitor_counter = 0, next_counter = 0, update_counter = 0;

	pointcut UnsafeIterator_create1(Collection c) : (call(Iterator Collection+.iterator()) && target(c)) && !within(UnsafeIteratorMonitor_1) && !within(UnsafeIteratorMonitorAspectOptimized) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
	@SuppressWarnings("unchecked")
	after (Collection c) returning (Iterator i) : UnsafeIterator_create1(c) {
		boolean skipAroundAdvice = false;
		Object obj = null;

        UnsafeIteratorMonitor_1 monitor = null;
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

			monitor = (UnsafeIteratorMonitor_1) obj;
			toCreate = (monitor == null);
			if (toCreate){
				
				monitor_counter++;
				//add trace info 
				long currentStackTrace = StackTrace.trace;
				if(monitor_trace_map.containsKey(currentStackTrace))
				{
					List<Object> monitors = monitor_trace_map.get(currentStackTrace);
					int creationCounter = monitors.size();
					double monitorCreationProb = UnsafeIteratorMonitor_1.getMonitorCreation(creationCounter);
					
					if(new Random().nextDouble() < monitorCreationProb)
					{
						monitor = new UnsafeIteratorMonitor_1();
						m.put(i, monitor);
						monitors.add(monitor);
						monitor_trace_map.put(currentStackTrace, monitors);
						monitor_counter++;
					}
				}
				
				else
				{
					monitor = new UnsafeIteratorMonitor_1();
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

		{
			monitor.create(c,i);
			if(monitor.MOP_match()) {
				System.out.println("improper iterator usage");
			}

		}

	}
	}

	pointcut UnsafeIterator_updatesource1(Collection c) : ((call(* Collection+.remove*(..)) || call(* Collection+.add*(..))) && target(c)) && !within(UnsafeIteratorMonitor_1) && !within(UnsafeIteratorMonitorAspectOptimized) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
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
				for(UnsafeIteratorMonitor_1 monitor : (List<UnsafeIteratorMonitor_1>)obj) {
					monitor.updatesource(c);
					if(monitor.MOP_match()) {
						System.err.println("improper iterator usage");
					}

				}
			}
		}
		
    }

	pointcut UnsafeIterator_next1(Iterator i) : (call(* Iterator.next()) && target(i)) && !within(UnsafeIteratorMonitor_1) && !within(UnsafeIteratorMonitorAspectOptimized) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
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
				for(UnsafeIteratorMonitor_1 monitor : (List<UnsafeIteratorMonitor_1>)obj) {
					monitor.next(i);
					if(monitor.MOP_match()) {
						System.out.println("improper iterator usage");
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
	}
	
	pointcut mainMethod(): execution (public static void main(String[]));
	
	before(): mainMethod(){
						
		UnsafeIterator_i_Map = null;
		UnsafeIterator_c_i_Map = null;
		UnsafeIterator_c_Map = null;
	}

	}