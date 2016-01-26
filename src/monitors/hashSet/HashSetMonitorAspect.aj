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
import org.apache.commons.collections.map.*;
import java.lang.ref.WeakReference;

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
}

public aspect HashSetMonitorAspect {
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

	static Map SafeHashSet_t_o_Map = null;
	static Map SafeHashSet_t_Map = null;
	static Map SafeHashSet_o_Map = null;

	pointcut SafeHashSet_add1(HashSet t, Object o) : (call(* Collection+.add(Object)) && target(t) && args(o)) && !within(SafeHashSetMonitor_1) && !within(HashSetMonitorAspect) && !adviceexecution();
	after (HashSet t, Object o) : SafeHashSet_add1(t, o) {
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
			monitor.add(t,o);
			if(monitor.MOP_match()) {
				System.err.println("HashCode changed for Object " + o + " while being in a   Hashtable!");
				System.exit(1);
			}

		}
	}

	pointcut SafeHashSet_unsafe_contains1(HashSet t, Object o) : (call(* Collection+.contains(Object)) && target(t) && args(o)) && !within(SafeHashSetMonitor_1) && !within(HashSetMonitorAspect) && !adviceexecution();
	before (HashSet t, Object o) : SafeHashSet_unsafe_contains1(t, o) {
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
				System.err.println("HashCode changed for Object " + o + " while being in a   Hashtable!");
				System.exit(1);
			}

		}
	}

	pointcut SafeHashSet_remove1(HashSet t, Object o) : (call(* Collection+.remove(Object)) && target(t) && args(o)) && !within(SafeHashSetMonitor_1) && !within(HashSetMonitorAspect) && !adviceexecution();
	after (HashSet t, Object o) : SafeHashSet_remove1(t, o) {
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
				System.err.println("HashCode changed for Object " + o + " while being in a   Hashtable!");
				System.exit(1);
			}

		}
	}

}

