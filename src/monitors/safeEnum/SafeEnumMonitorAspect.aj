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


package monitors.safeEnum;

import java.io.*;
import java.util.*;

import org.apache.commons.collections.map.*;

import java.lang.management.ManagementFactory;
import java.lang.management.MemoryPoolMXBean;
import java.lang.management.MemoryUsage;
import java.lang.ref.WeakReference;
import java.util.Iterator;

class SimpleLinkedList<T> implements Iterable<T>{
	class Element<T> {

		protected Element(T obj){
			if ((obj != null) && !(obj instanceof String) && !(obj instanceof Integer)) {
				ref = new WeakReference<T>(obj);
			} else {
				this.obj = obj;
			}
		}

		Element<T> next = null;
		WeakReference<T> ref = null;
		T obj = null;

		T get(){
			if(ref != null) {
				if(ref.isEnqueued()) {
					return null;
				} else {
					return ref.get();
				}
			} else {
				return obj;
			}
		}
	}

	private Element<T> head;
	private Element<T> tail;

	public SimpleLinkedList() {
		tail = head = new Element<T>(null);
	}

	public void add(T obj) {
		tail.next = new Element<T>(obj);
		tail = tail.next;
	}

	public Iterator<T> iterator(){
		return new MIterator();
	}

	public boolean isEmpty(){
		return head == tail;
	}

	class MIterator implements Iterator<T> {
		private Element<T> curr;
		private Element<T> pre;

		public MIterator() {
			pre = curr = head;
		}

		public boolean hasNext() {
			return curr.next != null;
		}
		public T next() {
			pre = curr;
			curr = curr.next;
			return (T)(curr.get());
		}
		public void remove() {
			if (pre != curr) {
				if (curr == tail) {
					curr = tail = pre;
				} else {
					pre.next = curr.next;
					curr = pre;
				}
			}
		}
	}
}

class SafeEnumWrapper {
	public SafeEnumMonitor_1 monitor = null;
	public long disable = 1;
	public long tau = 1;

	public WeakReference param_v = null;
	public WeakReference param_e = null;
}

class SafeEnumMonitor_1 implements Cloneable {
	public Object clone() {
		try {
			SafeEnumMonitor_1 ret = (SafeEnumMonitor_1) super.clone();
			return ret;
		}
		catch (CloneNotSupportedException e) {
			throw new InternalError(e.toString());
		}
	}
	org.aspectj.lang.JoinPoint MOP_thisJoinPoint = null;
	int state;
	int event;

	boolean MOP_match = false;

	public SafeEnumMonitor_1 () {
		state = 0;
		event = -1;

	}
	synchronized public final void create(Vector v,Enumeration e) {
		event = 1;

		switch(state) {
			case 0:
			switch(event) {
				case 1 : state = 2; break;
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
				case 2 : state = 3; break;
				case 3 : state = 2; break;
				default : state = -1; break;
			}
			break;
			case 3:
			switch(event) {
				case 2 : state = 3; break;
				case 3 : state = 1; break;
				default : state = -1; break;
			}
			break;
			default : state = -1;
		}

		MOP_match = state == 1;
	}
	synchronized public final void updatesource(Vector v) {
		event = 2;

		switch(state) {
			case 0:
			switch(event) {
				case 1 : state = 2; break;
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
				case 2 : state = 3; break;
				case 3 : state = 2; break;
				default : state = -1; break;
			}
			break;
			case 3:
			switch(event) {
				case 2 : state = 3; break;
				case 3 : state = 1; break;
				default : state = -1; break;
			}
			break;
			default : state = -1;
		}

		MOP_match = state == 1;
	}
	synchronized public final void next(Enumeration e) {
		event = 3;

		switch(state) {
			case 0:
			switch(event) {
				case 1 : state = 2; break;
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
				case 2 : state = 3; break;
				case 3 : state = 2; break;
				default : state = -1; break;
			}
			break;
			case 3:
			switch(event) {
				case 2 : state = 3; break;
				case 3 : state = 1; break;
				default : state = -1; break;
			}
			break;
			default : state = -1;
		}

		MOP_match = state == 1;
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

public aspect SafeEnumMonitorAspect {
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

	static Map makeMap(){
		return new ReferenceIdentityMap(AbstractReferenceMap.WEAK, AbstractReferenceMap.HARD, true);
	}
	static SimpleLinkedList makeLinkedList(){
		return new SimpleLinkedList();
	}

	static long timestamp = 1;

	static Map SafeEnum_v_e_Map = makeMap();
	static Map SafeEnum_v_Map = makeMap();
	static Map SafeEnum_v_ListMap = makeMap();
	static Map SafeEnum_e_Map = makeMap();
	static Map SafeEnum_e_ListMap = makeMap();
	static Map SafeEnum_Map = makeMap();

	public static volatile int create_counter = 0, update_counter = 0, next_counter = 0, error_counter = 0;
	
	public SafeEnumMonitorAspect() {
	}

	pointcut SafeEnum_create1(Vector v) : (call(Enumeration Vector+.elements()) && target(v)) && !within(SafeEnumMonitor_1) && !within(SafeEnumWrapper) && !within(SafeEnumMonitorAspect) && !within(SimpleLinkedList) && !adviceexecution() && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer);
	after (Vector v) returning (Enumeration e) : SafeEnum_create1(v) {
		
		create_counter++;
		
		boolean skipAroundAdvice = false;
		Object obj = null;
		Map m;
		SimpleLinkedList<SafeEnumWrapper> tempList;
		SafeEnumWrapper mainWrapper;
		SafeEnumWrapper uWrapper;
		SafeEnumWrapper pWrapper;
		SafeEnumWrapper monitorWrapper;
		Map mainMap;
		Map lastMap;
		SimpleLinkedList<SafeEnumWrapper> uWList;

		m = SafeEnum_v_e_Map;
		obj = m.get(v);
		if(obj == null) {
			obj = makeMap();
			m.put(v, obj);
		}
		mainMap = (Map)obj;
		mainWrapper = (SafeEnumWrapper) mainMap.get(e);

		if (mainWrapper == null || mainWrapper.monitor == null) {
			if(mainWrapper == null) {
				mainWrapper = new SafeEnumWrapper();
				mainWrapper.param_v = new WeakReference(v);
				mainWrapper.param_e = new WeakReference(e);
				mainMap.put(e, mainWrapper);
			}
			if(mainWrapper.monitor == null) {
				mainWrapper.monitor = new SafeEnumMonitor_1();
				mainWrapper.tau = this.timestamp++;
				lastMap = SafeEnum_v_ListMap;
				uWList = (SimpleLinkedList<SafeEnumWrapper>)lastMap.get(v);

				if(uWList == null){
					uWList = makeLinkedList();
					lastMap.put(v, uWList);
				}
				uWList.add(mainWrapper);
				lastMap = SafeEnum_e_ListMap;
				uWList = (SimpleLinkedList<SafeEnumWrapper>)lastMap.get(e);

				if(uWList == null){
					uWList = makeLinkedList();
					lastMap.put(e, uWList);
				}
				uWList.add(mainWrapper);

			}

			mainWrapper.disable = this.timestamp++;
		}
		if (mainWrapper != null && mainWrapper.monitor != null) {
			mainWrapper.monitor.MOP_thisJoinPoint = thisJoinPoint;
			mainWrapper.monitor.create(v,e);
			if(mainWrapper.monitor.MOP_match()) {
				System.out.println("improper enumeration usage at " + thisJoinPoint.getSourceLocation().toString());
				mainWrapper.monitor.reset();
			}

		}
	}

	pointcut SafeEnum_updatesource1(Vector v) : ((call(* Vector+.remove*(..)) || call(* Vector+.add*(..)) || call(* Vector+.clear(..)) || call(* Vector+.insertElementAt(..)) || call(* Vector+.set*(..)) || call(* Vector+.retainAll(..))) && target(v)) && !within(SafeEnumMonitor_1) && !within(SafeEnumWrapper) && !within(SafeEnumMonitorAspect) && !within(SimpleLinkedList) && !adviceexecution() && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer);
	after (Vector v) : SafeEnum_updatesource1(v) {
		
		update_counter++;
		
		boolean skipAroundAdvice = false;
		Object obj = null;
		Map m;
		SimpleLinkedList<SafeEnumWrapper> tempList;
		SafeEnumWrapper mainWrapper;
		SafeEnumWrapper uWrapper;
		SafeEnumWrapper pWrapper;
		SafeEnumWrapper monitorWrapper;
		Map mainMap;
		Map lastMap;
		SimpleLinkedList<SafeEnumWrapper> uWList;

		mainMap = SafeEnum_v_Map;
		mainWrapper = (SafeEnumWrapper) mainMap.get(v);

		if (mainWrapper == null || mainWrapper.monitor == null) {

			if(mainWrapper == null) {
				mainWrapper = new SafeEnumWrapper();
				mainWrapper.param_v = new WeakReference(v);
				mainMap.put(v, mainWrapper);
			}
			if(mainWrapper.monitor == null) {
				mainWrapper.monitor = new SafeEnumMonitor_1();
				mainWrapper.tau = this.timestamp++;
				lastMap = SafeEnum_v_ListMap;
				uWList = (SimpleLinkedList<SafeEnumWrapper>)lastMap.get(v);

				if(uWList == null){
					uWList = makeLinkedList();
					lastMap.put(v, uWList);
				}
				uWList.add(mainWrapper);

			}

			mainWrapper.disable = this.timestamp++;
		}
		m = SafeEnum_v_ListMap;
		uWList = (SimpleLinkedList<SafeEnumWrapper>)m.get(v);

		if(uWList != null) {
			Iterator it = uWList.iterator();
			while(it.hasNext()) {
				monitorWrapper = (SafeEnumWrapper)it.next();
				if(monitorWrapper == null) {
					it.remove();
				} else {
					monitorWrapper.monitor.MOP_thisJoinPoint = thisJoinPoint;
					monitorWrapper.monitor.updatesource(v);
					if(monitorWrapper.monitor.MOP_match()) {
						System.out.println("improper enumeration usage at " + thisJoinPoint.getSourceLocation().toString());
						monitorWrapper.monitor.reset();
					}

				}
			}
		}
	}

	pointcut SafeEnum_next1(Enumeration e) : (call(* Enumeration+.nextElement()) && target(e)) && !within(SafeEnumMonitor_1) && !within(SafeEnumWrapper) && !within(SafeEnumMonitorAspect) && !within(SimpleLinkedList) && !adviceexecution() && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer);
	before (Enumeration e) : SafeEnum_next1(e) {
		
		next_counter++;
		
		boolean skipAroundAdvice = false;
		Object obj = null;
		Map m;
		SimpleLinkedList<SafeEnumWrapper> tempList;
		SafeEnumWrapper mainWrapper;
		SafeEnumWrapper uWrapper;
		SafeEnumWrapper pWrapper;
		SafeEnumWrapper monitorWrapper;
		Map mainMap;
		Map lastMap;
		SimpleLinkedList<SafeEnumWrapper> uWList;

		mainMap = SafeEnum_e_Map;
		mainWrapper = (SafeEnumWrapper) mainMap.get(e);

		if (mainWrapper == null || mainWrapper.monitor == null) {

			if(mainWrapper == null) {
				mainWrapper = new SafeEnumWrapper();
				mainWrapper.param_e = new WeakReference(e);
				mainMap.put(e, mainWrapper);
			}
			if(mainWrapper.monitor == null) {
				mainWrapper.monitor = new SafeEnumMonitor_1();
				mainWrapper.tau = this.timestamp++;
				lastMap = SafeEnum_e_ListMap;
				uWList = (SimpleLinkedList<SafeEnumWrapper>)lastMap.get(e);

				if(uWList == null){
					uWList = makeLinkedList();
					lastMap.put(e, uWList);
				}
				uWList.add(mainWrapper);

			}

			mainWrapper.disable = this.timestamp++;
		}
		m = SafeEnum_e_ListMap;
		uWList = (SimpleLinkedList<SafeEnumWrapper>)m.get(e);

		if(uWList != null) {
			Iterator it = uWList.iterator();
			while(it.hasNext()) {
				monitorWrapper = (SafeEnumWrapper)it.next();
				if(monitorWrapper == null) {
					it.remove();
				} else {
					monitorWrapper.monitor.MOP_thisJoinPoint = thisJoinPoint;
					monitorWrapper.monitor.next(e);
					if(monitorWrapper.monitor.MOP_match()) {
						System.out.println("improper enumeration usage at " + thisJoinPoint.getSourceLocation().toString());
						monitorWrapper.monitor.reset();
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
		System.err.println("Total monitors : " + create_counter);
		System.err.println("Create counter : " + create_counter);
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

		 SafeEnum_v_e_Map = null;
		 Map SafeEnum_v_Map = null;
		 Map SafeEnum_v_ListMap = null;
		 Map SafeEnum_e_Map = null;
		 Map SafeEnum_e_ListMap = null;
		 Map SafeEnum_Map = null;
	}


}

