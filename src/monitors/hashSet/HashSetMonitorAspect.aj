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
		return new ArrayList<>();
	}

	static Map<Object, Object> indexing_lock = new HashMap();

	static Map<Object, Object> SafeHashSet_t_o_Map = null;
	static Map<Object, Object> SafeHashSet_t_Map = null;
	static Map<Object, Object> SafeHashSet_o_Map = null;

	public static int add_counter = 0, contain_counter = 0, remove_counter = 0, error_counter = 0;
	static volatile Map<Long, List<Object>> monitor_trace_map = new ConcurrentHashMap<>();

	pointcut SafeHashSet_add1(HashSet t, Object o) : (call(* Collection+.add(Object)) && target(t) && args(o)) && !within(SafeHashSetMonitor_1) && !within(HashSetMonitorAspect) && !adviceexecution() && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer);
	after (HashSet t, Object o) : SafeHashSet_add1(t, o) {

		add_counter++;

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
						List<Object> monitors = new ArrayList<>();
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
				error_counter++;
				System.err.println("HashCode changed for Object " + o + " while being in a   Hashtable!");
				System.exit(1);
			}

		}
	}

	pointcut SafeHashSet_unsafe_contains1(HashSet t, Object o) : (call(* Collection+.contains(Object)) && target(t) && args(o)) && !within(SafeHashSetMonitor_1) && !within(HashSetMonitorAspect) && !adviceexecution() && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer);
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
				error_counter++;
				System.err.println("HashCode changed for Object " + o + " while being in a   Hashtable!");
				System.exit(1);
			}

		}
	}

	pointcut SafeHashSet_remove1(HashSet t, Object o) : (call(* Collection+.remove(Object)) && target(t) && args(o)) && !within(SafeHashSetMonitor_1) && !within(HashSetMonitorAspect) && !adviceexecution() && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer);
	after (HashSet t, Object o) : SafeHashSet_remove1(t, o) {

		remove_counter++;

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
				error_counter++;
				System.err.println("HashCode changed for Object " + o + " while being in a   Hashtable!");
				System.exit(1);
			}

		}
	}

	pointcut System_exit(): (call (* System.exit(int)));

	before(): System_exit(){
		//System.err.println("About to print the statistics--- \n");
	}

	void around(): System_exit(){

		int m_counter = (SafeHashSet_t_o_Map == null) ? 0 : SafeHashSet_t_o_Map.size();
		System.err.println("Total monitors : " + m_counter);
		System.err.println("add counter : " + add_counter);
		System.err.println("contain counter : " + contain_counter);
		System.err.println("remove counter : " + remove_counter);
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

}

