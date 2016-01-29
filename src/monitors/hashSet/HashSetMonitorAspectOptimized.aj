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


package monitors.hashSet;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;


import org.apache.commons.collections.map.AbstractReferenceMap;
import org.apache.commons.collections.map.ReferenceIdentityMap;

import trace.StackTrace;

public aspect HashSetMonitorAspectOptimized {
	static Map makeMap(Object key){
		if (key instanceof String) {
			return new HashMap<>();
		} else {
			return new ReferenceIdentityMap(AbstractReferenceMap.WEAK, AbstractReferenceMap.HARD, true);
		}
	}
	static List<Object> makeList(){
		return new ArrayList<>();
	}

	static Map<Object, Object> indexing_lock = new HashMap<>();

	static Map<Object, Object> SafeHashSet_t_o_Map = null;
	static Map<Object, Object> SafeHashSet_t_Map = null;
	static Map<Object, Object> SafeHashSet_o_Map = null;
	static volatile Map<Long, List<Object>> monitor_trace_map = new ConcurrentHashMap<>();
	public static volatile int add_counter = 0, contain_counter = 0, 
			remove_counter = 0, monitor_counter = 0, error_counter = 0;
	
	pointcut SafeHashSet_add1(HashSet t, Object o) : (call(* Collection+.add(Object)) && target(t) && args(o)) && !within(SafeHashSetMonitor_1) && !within(HashSetMonitorAspect) && !adviceexecution();
	after (HashSet t, Object o) : SafeHashSet_add1(t, o) {
		
		add_counter++;
		
		boolean skipAroundAdvice = false;
		Object obj = null;

		SafeHashSetMonitor_1 monitor = null;
		boolean toCreate = false;

		Map m = SafeHashSet_t_o_Map;
		if(m == null){
			synchronized(indexing_lock) {
				m = SafeHashSet_t_o_Map;
				if(m == null) m = SafeHashSet_t_o_Map = makeMap(t);
			}
		}

		synchronized(SafeHashSet_t_o_Map) {
			obj = m.get(t);
			if (obj == null) {
				obj = makeMap(o);
				m.put(t, obj);
			}
			m = (Map)obj;
			obj = m.get(o);

			monitor = (SafeHashSetMonitor_1) obj;
			toCreate = (monitor == null);
			if (toCreate){
				//old code
				//monitor = new SafeHashSetMonitor_1();
				//m.put(o, monitor);
				//new additions
				long currentStackTrace = StackTrace.trace;
				if(monitor_trace_map.containsKey(currentStackTrace))
				{
					List<Object> monitors = monitor_trace_map.get(currentStackTrace);
					int creationCounter = monitors.size();
					double monitorCreationProb = SafeHashSetMonitor_1.getMonitorCreation(creationCounter);
					
					if(new Random().nextDouble() < monitorCreationProb)
					{
						
						monitor = new SafeHashSetMonitor_1();
						m.put(o, monitor);
						monitors.add(monitor);
						monitor_trace_map.put(currentStackTrace, monitors);

						monitor_counter++;
					}
				}
				
				else
				{
					monitor = new SafeHashSetMonitor_1();
					m.put(o, monitor);
					List<Object> monitors = new ArrayList<>();
					monitors.add(monitor);	
					monitor_trace_map.put(currentStackTrace, monitors);
					monitor_counter++;
				}

			}

		}
		if(toCreate) {
			m = SafeHashSet_t_Map;
			if (m == null) m = SafeHashSet_t_Map = makeMap(t);
			obj = null;
			synchronized(SafeHashSet_t_Map) {
				obj = m.get(t);
				List monitors = (List)obj;
				if (monitors == null) {
					monitors = makeList();
					m.put(t, monitors);
				}
				monitors.add(monitor);
			}//end of adding
			m = SafeHashSet_o_Map;
			if (m == null) m = SafeHashSet_o_Map = makeMap(o);
			obj = null;
			synchronized(SafeHashSet_o_Map) {
				obj = m.get(o);
				List monitors = (List)obj;
				if (monitors == null) {
					monitors = makeList();
					m.put(o, monitors);
				}
				monitors.add(monitor);
			}//end of adding
		}

		{
			monitor.add(t,o);
			if(monitor.MOP_match()) {
				error_counter++;
				//System.err.println("HashCode changed for Object " + o + " while being in a   Hashtable!");
				//System.exit(1);
			}

		}
	}

	pointcut SafeHashSet_unsafe_contains1(HashSet t, Object o) : (call(* Collection+.contains(Object)) && target(t) && args(o)) && !within(SafeHashSetMonitor_1) && !within(HashSetMonitorAspect) && !adviceexecution();
	before (HashSet t, Object o) : SafeHashSet_unsafe_contains1(t, o) {
		
		contain_counter++;
		
		boolean skipAroundAdvice = false;
		Object obj = null;

		SafeHashSetMonitor_1 monitor = null;
		boolean toCreate = false;

		Map m = SafeHashSet_t_o_Map;
		if(m == null){
			synchronized(indexing_lock) {
				m = SafeHashSet_t_o_Map;
				if(m == null) m = SafeHashSet_t_o_Map = makeMap(t);
			}
		}

		synchronized(SafeHashSet_t_o_Map) {
			obj = m.get(t);
			if (obj == null) {
				obj = makeMap(o);
				m.put(t, obj);
			}
			m = (Map)obj;
			obj = m.get(o);

			monitor = (SafeHashSetMonitor_1) obj;
			toCreate = (monitor == null);
			if (toCreate){
				//old code
				//monitor = new SafeHashSetMonitor_1();
				//m.put(o, monitor);
				//new addition
				
				long currentStackTrace = StackTrace.trace;
				if(monitor_trace_map.containsKey(currentStackTrace))
				{
					List<Object> monitors = monitor_trace_map.get(currentStackTrace);
					int creationCounter = monitors.size();
					double monitorCreationProb = SafeHashSetMonitor_1.getMonitorCreation(creationCounter);
					
					if(new Random().nextDouble() < monitorCreationProb)
					{
						
						monitor = new SafeHashSetMonitor_1();
						m.put(o, monitor);
						monitors.add(monitor);
						monitor_trace_map.put(currentStackTrace, monitors);

						monitor_counter++;
					}
				}
				
				else
				{
					monitor = new SafeHashSetMonitor_1();
					m.put(o, monitor);
					List<Object> monitors = new ArrayList<>();
					monitors.add(monitor);	
					monitor_trace_map.put(currentStackTrace, monitors);
					monitor_counter++;
				}
				
			}

		}
		if(toCreate) {
			m = SafeHashSet_t_Map;
			if (m == null) m = SafeHashSet_t_Map = makeMap(t);
			obj = null;
			synchronized(SafeHashSet_t_Map) {
				obj = m.get(t);
				List monitors = (List)obj;
				if (monitors == null) {
					monitors = makeList();
					m.put(t, monitors);
				}
				monitors.add(monitor);
			}//end of adding
			m = SafeHashSet_o_Map;
			if (m == null) m = SafeHashSet_o_Map = makeMap(o);
			obj = null;
			synchronized(SafeHashSet_o_Map) {
				obj = m.get(o);
				List monitors = (List)obj;
				if (monitors == null) {
					monitors = makeList();
					m.put(o, monitors);
				}
				monitors.add(monitor);
			}//end of adding
		}

		{
			monitor.unsafe_contains(t,o);
			if(monitor.MOP_match()) {
				error_counter++;
				//System.err.println("HashCode changed for Object " + o + " while being in a   Hashtable!");
				//System.exit(1);
			}

		}
	}

	pointcut SafeHashSet_remove1(HashSet t, Object o) : (call(* Collection+.remove(Object)) && target(t) && args(o)) && !within(SafeHashSetMonitor_1) && !within(HashSetMonitorAspect) && !adviceexecution();
	after (HashSet t, Object o) : SafeHashSet_remove1(t, o) {
		
		remove_counter++;
		
		boolean skipAroundAdvice = false;
		Object obj = null;

		SafeHashSetMonitor_1 monitor = null;
		boolean toCreate = false;

		Map<Object, Object> m = SafeHashSet_t_o_Map;
		if(m == null){
			synchronized(indexing_lock) {
				m = SafeHashSet_t_o_Map;
				if(m == null) m = SafeHashSet_t_o_Map = makeMap(t);
			}
		}

		synchronized(SafeHashSet_t_o_Map) {
			obj = m.get(t);
			if (obj == null) {
				obj = makeMap(o);
				m.put(t, obj);
			}
			m = (Map)obj;
			obj = m.get(o);

			monitor = (SafeHashSetMonitor_1) obj;
			toCreate = (monitor == null);
			if (toCreate){
				//old code
				//monitor = new SafeHashSetMonitor_1();
				//m.put(o, monitor);
				//new addition
				
				long currentStackTrace = StackTrace.trace;
				if(monitor_trace_map.containsKey(currentStackTrace))
				{
					List<Object> monitors = monitor_trace_map.get(currentStackTrace);
					int creationCounter = monitors.size();
					double monitorCreationProb = SafeHashSetMonitor_1.getMonitorCreation(creationCounter);
					
					if(new Random().nextDouble() < monitorCreationProb)
					{
						
						monitor = new SafeHashSetMonitor_1();
						m.put(o, monitor);
						monitors.add(monitor);
						monitor_trace_map.put(currentStackTrace, monitors);

						monitor_counter++;
					}
				}
				
				else
				{
					monitor = new SafeHashSetMonitor_1();
					m.put(o, monitor);
					List<Object> monitors = new ArrayList<>();
					monitors.add(monitor);	
					monitor_trace_map.put(currentStackTrace, monitors);
					monitor_counter++;
				}
				
			}

		}
		if(toCreate) {
			m = SafeHashSet_t_Map;
			if (m == null) m = SafeHashSet_t_Map = makeMap(t);
			obj = null;
			synchronized(SafeHashSet_t_Map) {
				obj = m.get(t);
				List monitors = (List)obj;
				if (monitors == null) {
					monitors = makeList();
					m.put(t, monitors);
				}
				monitors.add(monitor);
			}//end of adding
			m = SafeHashSet_o_Map;
			if (m == null) m = SafeHashSet_o_Map = makeMap(o);
			obj = null;
			synchronized(SafeHashSet_o_Map) {
				obj = m.get(o);
				List monitors = (List)obj;
				if (monitors == null) {
					monitors = makeList();
					m.put(o, monitors);
				}
				monitors.add(monitor);
			}//end of adding
		}

		{
			monitor.remove(t,o);
			if(monitor.MOP_match()) {
				error_counter++;
				//System.err.println("HashCode changed for Object " + o + " while being in a   Hashtable!");
				//System.exit(1);
			}

		}
	}
	pointcut System_exit(): (call (* System.exit(int)));
	before(): System_exit(){
		//System.err.println("About to print the statistics--- \n");
		//System.err.println("The number of monitors created are : " + monitor_counter);
		//System.err.println("HasNext counter : " + has_next_counter);
		//System.err.println("next counter : " + next_counter);
	}

	void around(): System_exit(){
		System.err.println("The number of monitors created are : " + monitor_counter);
		System.err.println("add counter : " + add_counter);
		System.err.println("contain counter : " + contain_counter);
		System.err.println("remove counter : " + remove_counter);		
		System.err.println("error counter : " + error_counter);
		System.err.println("---------------------------------------------------------");
	}

}

