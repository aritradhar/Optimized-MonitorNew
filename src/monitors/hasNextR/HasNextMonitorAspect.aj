package monitors.hasNextR;

import java.io.*;
import java.util.*;
import org.apache.commons.collections.map.*;

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
	synchronized public final void hasnext(Iterator i) {
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
				case 2 : state = 0; break;
				case 1 : state = 1; break;
				default : state = -1; break;
			}
			break;
			default : state = -1;
		}

		MOP_fail = state == -1
		;
	}
	synchronized public final void next(Iterator i) {
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
				case 2 : state = 0; break;
				case 1 : state = 1; break;
				default : state = -1; break;
			}
			break;
			default : state = -1;
		}

		MOP_fail = state == -1
		;
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

public aspect HasNextMonitorAspect {
	
	public static volatile int total_monitor = 0;
	public static volatile int error_count = 0;
	
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

	pointcut HasNext_hasnext1(Iterator i) : (call(* Iterator.hasNext()) && target(i)) && !within(HasNextMonitor_1) && !within(HasNextMonitorAspect) && !adviceexecution();
	after (Iterator i) : HasNext_hasnext1(i) {
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
				monitor = new HasNextMonitor_1();
				total_monitor++;
				m.put(i, monitor);
			}

		}

		{
			monitor.hasnext(i);
			if(monitor.MOP_fail()) {
				error_count++;
				monitor.reset();
			}

		}
	}

	pointcut HasNext_next1(Iterator i) : (call(* Iterator.next()) && target(i)) && !within(HasNextMonitor_1) && !within(HasNextMonitorAspect) && !adviceexecution();
	before (Iterator i) : HasNext_next1(i) {
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
				monitor = new HasNextMonitor_1();
				total_monitor++;
				m.put(i, monitor);
			}

		}

		{
			monitor.next(i);
			if(monitor.MOP_fail()) {
				error_count++;
				monitor.reset();
			}

		}
	}
	
	pointcut System_exit(): (call (* System.exit(int)));
	before(): System_exit(){

	}

	void around(): System_exit(){
		System.err.println("Total monitors : " + total_monitor);
		System.err.println("Total errors : " + error_count);
	
	}

	pointcut mainMethod(): execution (public static void main(String[]));

	after(): mainMethod(){
		HasNext_i_Map = null;
	}

}
