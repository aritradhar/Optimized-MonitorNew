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


package test;

import java.io.*;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;


import org.apache.commons.collections.map.*;

import trace.StackTrace;

import java.lang.management.ManagementFactory;
import java.lang.management.MemoryPoolMXBean;
import java.lang.management.MemoryUsage;
import java.lang.ref.WeakReference;

class EV
{
	public static final boolean optimized = true;
}

class SafeHashSetMonitor_1 implements Cloneable {
	public Object clone() {
		try {
			SafeHashSetMonitor_1 ret = (SafeHashSetMonitor_1) super.clone();
			return ret;
		}
		catch (CloneNotSupportedException e) {
			throw new InternalError(e.toString());
		}
	}
	int hashcode;
	int state;
	int event;

	boolean MOP_match = false;

	public SafeHashSetMonitor_1 () {
		state = 0;
		event = -1;

	}
	synchronized public final void add(HashSet t,Object o) {
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
			default : state = -1; break;
			}
			break;
		default : state = -1;
		}

		MOP_match = state == 2;
		{
			hashcode = o.hashCode();
		}
	}
	synchronized public final void unsafe_contains(HashSet t,Object o) {
		if (!(hashcode != o.hashCode())) {
			return;
		}
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
			default : state = -1; break;
			}
			break;
		default : state = -1;
		}

		MOP_match = state == 2;
	}
	synchronized public final void remove(HashSet t,Object o) {
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
			default : state = -1; break;
			}
			break;
		default : state = -1;
		}

		MOP_match = state == 2;
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
		if (count >= 0 && count < 10) {
			return 1;
		}

		else if (count >= 10 && count < 50) {
			return 0.5;
		}

		else if (count >= 50 && count < 100) {
			return 0.25;
		}

		else if (count >= 100 && count < 500) {
			return 0.125;
		}

		else if (count >= 500 && count < 1000) {
			return 0.0625;
		}

		else if (count >= 1000 && count < 2000) {
			return 0.03125;
		}

		else if (count >= 2000 && count < 4000) {
			return 0.015625;
		}

		else if (count >= 4000 && count < 7000) {
			return 0.0078125;
		}

		else if (count >= 7000 && count < 10000) {
			return 0.00390625;
		}

		else {
			return 0;
		}
	}
}

public aspect HashSetMonitorAspect {
	static Map makeMap(Object key){
		if (key instanceof String) {
			return new HashMap();
		} else {
			return new ReferenceIdentityMap(AbstractReferenceMap.WEAK, AbstractReferenceMap.HARD, true);
		}
	}
	static List<Object> makeList(){
		return new ArrayList();
	}

	static Map<Object, Object> indexing_lock = new HashMap();

	static Map<Object, Object> SafeHashSet_t_o_Map = null;
	static Map<Object, Object> SafeHashSet_t_Map = null;
	static Map<Object, Object> SafeHashSet_o_Map = null;

	static long max_add = 0, max_contain = 0, max_remove = 0;
	static long min_add = Long.MAX_VALUE , min_contain = Long.MAX_VALUE, min_remove = Long.MAX_VALUE;

	static volatile Map<Long, List<Object>> monitor_trace_map = new ConcurrentHashMap();

	pointcut SafeHashSet_add1(HashSet t, Object o) : (call(* Collection+.add(Object)) && target(t) && args(o)) && !within(SafeHashSetMonitor_1) && !within(HashSetMonitorAspect) && !adviceexecution() && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer);
	after (HashSet t, Object o) : SafeHashSet_add1(t, o) {

		//add_counter++;
		long startTime = System.currentTimeMillis();

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

				if(EV.optimized)
				{
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
						}
						else
							return;
					}

					else
					{
						monitor = new SafeHashSetMonitor_1();
						m.put(o, monitor);
						List<Object> monitors = new ArrayList();
						monitors.add(monitor);	
						monitor_trace_map.put(currentStackTrace, monitors);

					}

					//monitor = new SafeHashSetMonitor_1();
					//m.put(o, monitor);
				}
			}
			else
			{
				monitor = new SafeHashSetMonitor_1();
				m.put(o, monitor);
			}

		}
		if(monitor == null)
			return;
		if(toCreate && monitor != null) {
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
				//error_counter++;
				//System.err.println("HashCode changed for Object " + o + " while being in a   Hashtable!");
				System.exit(1);
			}

		}

		long endTime = System.currentTimeMillis();
	    long duration = (endTime - startTime);  
	    //System.out.println("Duration: " + duration);

	    if(duration > max_add && duration > 0)
	    {
	    	max_add = duration;
	    }

	    if(duration < min_add && duration > 0)
	    {
	    	min_add = duration;
	    }
	}

	pointcut SafeHashSet_unsafe_contains1(HashSet t, Object o) : (call(* Collection+.contains(Object)) && target(t) && args(o)) && !within(SafeHashSetMonitor_1) && !within(HashSetMonitorAspect) && !adviceexecution() && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer);
	before (HashSet t, Object o) : SafeHashSet_unsafe_contains1(t, o) {

		//contain_counter++;
		long startTime = System.currentTimeMillis();

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
				monitor = new SafeHashSetMonitor_1();
				m.put(o, monitor);
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
				//error_counter++;
				//System.err.println("HashCode changed for Object " + o + " while being in a   Hashtable!");
				System.exit(1);
			}

		}

		long endTime = System.currentTimeMillis();
	    long duration = (endTime - startTime);  
	    //System.out.println("Duration: " + duration);

	    if(duration > max_contain && duration > 0)
	    {
	    	max_contain = duration;
	    }

	    if(duration < min_contain && duration > 0)
	    {
	    	min_contain = duration;
	    }
	}

	pointcut SafeHashSet_remove1(HashSet t, Object o) : (call(* Collection+.remove(Object)) && target(t) && args(o)) && !within(SafeHashSetMonitor_1) && !within(HashSetMonitorAspect) && !adviceexecution() && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer);
	after (HashSet t, Object o) : SafeHashSet_remove1(t, o) {

		//remove_counter++;
		long startTime = System.currentTimeMillis();

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
				monitor = new SafeHashSetMonitor_1();
				m.put(o, monitor);
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
				//error_counter++;
				//System.err.println("HashCode changed for Object " + o + " while being in a   Hashtable!");
				System.exit(1);
			}

		}

		long endTime = System.currentTimeMillis();
	    long duration = (endTime - startTime);  
	    //System.out.println("Duration: " + duration);

	    if(duration > max_remove && duration > 0)
	    {
	    	max_remove = duration;
	    }

	    if(duration < min_remove && duration > 0)
	    {
	    	min_remove = duration;
	    }
	}

	pointcut System_exit(): (call (* System.exit(int)));

	before(): System_exit(){
		//System.err.println("About to print the statistics--- \n");
	}

	void around(): System_exit(){

		System.out.println("Max add : "+ max_add);
		System.out.println("Max remove : "+ max_remove);
		System.out.println("Max contain : "+ max_contain);
		System.out.println("Min add : "+ min_add);
		System.out.println("Min remove : "+ min_remove);
		System.out.println("Min contain : "+ min_contain);
		
	}

}

