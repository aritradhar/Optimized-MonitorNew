package monitors.hasNext;
/* Original JavaMOP 2.1 aspect for HasNext property */
import java.io.*;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

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

	public static double setProbability(long count)
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

public aspect HasNextMonitorAspectOptimized {
	@SuppressWarnings("unchecked")
	static Map<Object, Object> makeMap(Object key){
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

	static Map<Object, Object> HasNext_i_Map = null;

	static ConcurrentHashMap<Object, Long> monitor_trace_map = new ConcurrentHashMap<>();

	pointcut HasNext_create1() : (call(Iterator Collection+.iterator())) && !within(HasNextMonitor_1) && !within(HasNextMonitorAspect) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
	@SuppressWarnings("rawtypes")
	after () returning (Iterator i) : HasNext_create1() {
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

				monitor = new HasNextMonitor_1();
				m.put(i, monitor);

			}

		}
		if(monitor!=null)
		{
			monitor.create(i);
			if(monitor.MOP_fail()) {
				//System.err.println("! hasNext() has not been called" + " before calling next() for an" + " iterator");
				monitor.reset();
			}

		}
	}

	@SuppressWarnings("rawtypes")
	pointcut HasNext_hasnext1(Iterator i) : (call(* Iterator.hasNext()) && target(i)) && !within(HasNextMonitor_1) && !within(HasNextMonitorAspect) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
	after (Iterator i) : HasNext_hasnext1(i) {
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
				//System.err.println("! hasNext() has not been called" + " before calling next() for an" + " iterator");
				monitor.reset();
			}

		}


	}

	pointcut HasNext_next1(Iterator i) : (call(* Iterator.next()) && target(i)) && !within(HasNextMonitor_1) && !within(HasNextMonitorAspect) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
	before (Iterator i) : HasNext_next1(i) {
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
				//System.err.println("! hasNext() has not been called" + " before calling next() for an" + " iterator");
				monitor.reset();
			}

		}

	}

	pointcut System_exit(): (call (* System.exit(int)));
	before(): System_exit(){
		//System.err.println("About to print the statistics--- \n");
	}

	void around(): System_exit(){
		//System.out.println("The number of monitors created are: " + num_monitors);
		//System.out.println("Number of trees matching: "+num_matches);
	}

	pointcut mainMethod(): execution (public static void main(String[]));

	after(): mainMethod(){
		HasNext_i_Map = null;
	}
}

