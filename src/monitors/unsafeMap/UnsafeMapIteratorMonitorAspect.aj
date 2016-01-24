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


package monitors.unsafeMap;

import java.io.*;
import java.util.*;
import org.apache.commons.collections.map.*;
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

class UnsafeMapIteratorWrapper {
	public UnsafeMapIteratorMonitor_1 monitor = null;
	public long disable = 1;
	public long tau = 1;

	public WeakReference param_map = null;
	public WeakReference param_c = null;
	public WeakReference param_i = null;
}

class UnsafeMapIteratorMonitor_1 implements Cloneable {
	public Object clone() {
		try {
			UnsafeMapIteratorMonitor_1 ret = (UnsafeMapIteratorMonitor_1) super.clone();
			return ret;
		}
		catch (CloneNotSupportedException e) {
			throw new InternalError(e.toString());
		}
	}
	int state;
	int event;

	boolean MOP_match = false;

	public UnsafeMapIteratorMonitor_1 () {
		state = 0;
		event = -1;

	}
	synchronized public final void createColl(Map map,Collection c) {
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
				case 4 : state = 1; break;
				default : state = -1; break;
			}
			break;
			case 2:
			switch(event) {
				case 4 : state = 3; break;
				case 3 : state = 2; break;
				default : state = -1; break;
			}
			break;
			case 3:
			switch(event) {
				case 4 : state = 3; break;
				case 3 : state = 4; break;
				default : state = -1; break;
			}
			break;
			case 4:
			switch(event) {
				default : state = -1; break;
			}
			break;
			default : state = -1;
		}

		MOP_match = state == 4;
	}
	synchronized public final void createIter(Collection c,Iterator i) {
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
				case 4 : state = 1; break;
				default : state = -1; break;
			}
			break;
			case 2:
			switch(event) {
				case 4 : state = 3; break;
				case 3 : state = 2; break;
				default : state = -1; break;
			}
			break;
			case 3:
			switch(event) {
				case 4 : state = 3; break;
				case 3 : state = 4; break;
				default : state = -1; break;
			}
			break;
			case 4:
			switch(event) {
				default : state = -1; break;
			}
			break;
			default : state = -1;
		}

		MOP_match = state == 4;
	}
	synchronized public final void useIter(Iterator i) {
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
				case 4 : state = 1; break;
				default : state = -1; break;
			}
			break;
			case 2:
			switch(event) {
				case 4 : state = 3; break;
				case 3 : state = 2; break;
				default : state = -1; break;
			}
			break;
			case 3:
			switch(event) {
				case 4 : state = 3; break;
				case 3 : state = 4; break;
				default : state = -1; break;
			}
			break;
			case 4:
			switch(event) {
				default : state = -1; break;
			}
			break;
			default : state = -1;
		}

		MOP_match = state == 4;
	}
	synchronized public final void updateMap(Map map) {
		event = 4;

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
				case 4 : state = 1; break;
				default : state = -1; break;
			}
			break;
			case 2:
			switch(event) {
				case 4 : state = 3; break;
				case 3 : state = 2; break;
				default : state = -1; break;
			}
			break;
			case 3:
			switch(event) {
				case 4 : state = 3; break;
				case 3 : state = 4; break;
				default : state = -1; break;
			}
			break;
			case 4:
			switch(event) {
				default : state = -1; break;
			}
			break;
			default : state = -1;
		}

		MOP_match = state == 4;
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

public aspect UnsafeMapIteratorMonitorAspect {
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

	static Map UnsafeMapIterator_map_c_Map = makeMap();
	static Map UnsafeMapIterator_map_c_ListMap = makeMap();
	static Map UnsafeMapIterator_c_i_Map = makeMap();
	static Map UnsafeMapIterator_c_i_ListMap = makeMap();
	static Map UnsafeMapIterator_i_Map = makeMap();
	static Map UnsafeMapIterator_i_ListMap = makeMap();
	static Map UnsafeMapIterator_map_Map = makeMap();
	static Map UnsafeMapIterator_map_ListMap = makeMap();
	static Map UnsafeMapIterator_Map = makeMap();
	static Map UnsafeMapIterator_map_c_i_Map = makeMap();
	static Map UnsafeMapIterator_c__To__map_c_ListMap = makeMap();

	public UnsafeMapIteratorMonitorAspect() {
	}

	pointcut UnsafeMapIterator_createColl1(Map map) : ((call(* Map.values()) || call(* Map.keySet())) && target(map)) && !within(UnsafeMapIteratorMonitor_1) && !within(UnsafeMapIteratorWrapper) && !within(UnsafeMapIteratorMonitorAspect) && !within(SimpleLinkedList) && !adviceexecution();
	after (Map map) returning (Collection c) : UnsafeMapIterator_createColl1(map) {
		boolean skipAroundAdvice = false;
		Object obj = null;
		Map m;
		SimpleLinkedList<UnsafeMapIteratorWrapper> tempList;
		UnsafeMapIteratorWrapper mainWrapper;
		UnsafeMapIteratorWrapper uWrapper;
		UnsafeMapIteratorWrapper pWrapper;
		UnsafeMapIteratorWrapper monitorWrapper;
		Map mainMap;
		Map lastMap;
		SimpleLinkedList<UnsafeMapIteratorWrapper> uWList;

		m = UnsafeMapIterator_map_c_Map;
		obj = m.get(map);
		if(obj == null) {
			obj = makeMap();
			m.put(map, obj);
		}
		mainMap = (Map)obj;
		mainWrapper = (UnsafeMapIteratorWrapper) mainMap.get(c);

		if (mainWrapper == null || mainWrapper.monitor == null) {
			if(mainWrapper == null) {
				mainWrapper = new UnsafeMapIteratorWrapper();
				mainWrapper.param_map = new WeakReference(map);
				mainWrapper.param_c = new WeakReference(c);
				mainMap.put(c, mainWrapper);
			}
			if(mainWrapper.monitor == null) {
				mainWrapper.monitor = new UnsafeMapIteratorMonitor_1();
				mainWrapper.tau = this.timestamp++;
				m = UnsafeMapIterator_map_c_ListMap;
				obj = m.get(map);
				if(obj == null) {
					obj = makeMap();
					m.put(map, obj);
				}
				lastMap = (Map)obj;
				uWList = (SimpleLinkedList<UnsafeMapIteratorWrapper>)lastMap.get(c);

				if(uWList == null){
					uWList = makeLinkedList();
					lastMap.put(c, uWList);
				}
				uWList.add(mainWrapper);
				lastMap = UnsafeMapIterator_c__To__map_c_ListMap;
				uWList = (SimpleLinkedList<UnsafeMapIteratorWrapper>)lastMap.get(c);
				if(uWList == null){
					uWList = makeLinkedList();
					lastMap.put(c, uWList);
				}
				uWList.add(mainWrapper);
				lastMap = UnsafeMapIterator_map_ListMap;
				uWList = (SimpleLinkedList<UnsafeMapIteratorWrapper>)lastMap.get(map);

				if(uWList == null){
					uWList = makeLinkedList();
					lastMap.put(map, uWList);
				}
				uWList.add(mainWrapper);

			}

			mainWrapper.disable = this.timestamp++;
		}
		m = UnsafeMapIterator_map_c_ListMap;
		obj = m.get(map);
		if(obj == null) {
			obj = makeMap();
			m.put(map, obj);
		}
		m = (Map)obj;
		uWList = (SimpleLinkedList<UnsafeMapIteratorWrapper>)m.get(c);

		if(uWList != null) {
			Iterator it = uWList.iterator();
			while(it.hasNext()) {
				monitorWrapper = (UnsafeMapIteratorWrapper)it.next();
				if(monitorWrapper == null) {
					it.remove();
				} else {
					monitorWrapper.monitor.createColl(map,c);
					if(monitorWrapper.monitor.MOP_match()) {
						System.out.println("unsafe iterator usage!");
					}

				}
			}
		}
	}

	pointcut UnsafeMapIterator_createIter1(Collection c) : (call(* Collection.iterator()) && target(c)) && !within(UnsafeMapIteratorMonitor_1) && !within(UnsafeMapIteratorWrapper) && !within(UnsafeMapIteratorMonitorAspect) && !within(SimpleLinkedList) && !adviceexecution();
	after (Collection c) returning (Iterator i) : UnsafeMapIterator_createIter1(c) {
		boolean skipAroundAdvice = false;
		Object obj = null;
		Map m;
		SimpleLinkedList<UnsafeMapIteratorWrapper> tempList;
		UnsafeMapIteratorWrapper mainWrapper;
		UnsafeMapIteratorWrapper uWrapper;
		UnsafeMapIteratorWrapper pWrapper;
		UnsafeMapIteratorWrapper monitorWrapper;
		Map mainMap;
		Map lastMap;
		SimpleLinkedList<UnsafeMapIteratorWrapper> uWList;

		m = UnsafeMapIterator_c_i_Map;
		obj = m.get(c);
		if(obj == null) {
			obj = makeMap();
			m.put(c, obj);
		}
		mainMap = (Map)obj;
		mainWrapper = (UnsafeMapIteratorWrapper) mainMap.get(i);

		if (mainWrapper == null || mainWrapper.monitor == null) {
			m = UnsafeMapIterator_c__To__map_c_ListMap;
			uWList = (SimpleLinkedList<UnsafeMapIteratorWrapper>)m.get(c);

			if(uWList != null) {
				Iterator it = uWList.iterator();
				while(it.hasNext()) {
					UnsafeMapIteratorWrapper eWrapper = (UnsafeMapIteratorWrapper)it.next();
					if(eWrapper == null){
						it.remove();
						continue;
					}
					Map map = (Map)(eWrapper.param_map.get());
					if(map == null){
						it.remove();
						continue;
					}
					m = UnsafeMapIterator_map_c_i_Map;
					obj = m.get(map);
					if(obj == null) {
						obj = makeMap();
						m.put(map, obj);
					}
					m = (Map)obj;
					obj = m.get(c);
					if(obj == null) {
						obj = makeMap();
						m.put(c, obj);
					}
					lastMap = (Map)obj;
					uWrapper = (UnsafeMapIteratorWrapper) lastMap.get(i);

					if (uWrapper == null || uWrapper.monitor == null) {
						boolean timeCheck = true;
						m = UnsafeMapIterator_c_i_Map;
						obj = m.get(c);
						if(obj == null) {
							obj = makeMap();
							m.put(c, obj);
						}
						m = (Map)obj;
						pWrapper = (UnsafeMapIteratorWrapper) m.get(i);

						if(pWrapper != null && (pWrapper.disable > eWrapper.tau || pWrapper.tau < eWrapper.tau)) {
							timeCheck = false;
						}
						m = UnsafeMapIterator_i_Map;
						pWrapper = (UnsafeMapIteratorWrapper) m.get(i);

						if(pWrapper != null && (pWrapper.disable > eWrapper.tau || pWrapper.tau < eWrapper.tau)) {
							timeCheck = false;
						}
						m = UnsafeMapIterator_map_c_i_Map;
						obj = m.get(map);
						if(obj == null) {
							obj = makeMap();
							m.put(map, obj);
						}
						m = (Map)obj;
						obj = m.get(c);
						if(obj == null) {
							obj = makeMap();
							m.put(c, obj);
						}
						m = (Map)obj;
						pWrapper = (UnsafeMapIteratorWrapper) m.get(i);

						if(pWrapper != null && (pWrapper.disable > eWrapper.tau || pWrapper.tau < eWrapper.tau)) {
							timeCheck = false;
						}
						if(timeCheck){
							if(uWrapper == null) {
								uWrapper = new UnsafeMapIteratorWrapper();
								uWrapper.param_map = new WeakReference(map);
								uWrapper.param_c = new WeakReference(c);
								uWrapper.param_i = new WeakReference(i);
								lastMap.put(i, uWrapper);
							}
							uWrapper.tau = eWrapper.tau;
							uWrapper.monitor = (UnsafeMapIteratorMonitor_1) eWrapper.monitor.clone();
							m = UnsafeMapIterator_map_c_ListMap;
							obj = m.get(map);
							if(obj == null) {
								obj = makeMap();
								m.put(map, obj);
							}
							lastMap = (Map)obj;
							uWList = (SimpleLinkedList<UnsafeMapIteratorWrapper>)lastMap.get(c);

							if(uWList == null){
								uWList = makeLinkedList();
								lastMap.put(c, uWList);
							}
							uWList.add(uWrapper);
							m = UnsafeMapIterator_c_i_ListMap;
							obj = m.get(c);
							if(obj == null) {
								obj = makeMap();
								m.put(c, obj);
							}
							lastMap = (Map)obj;
							uWList = (SimpleLinkedList<UnsafeMapIteratorWrapper>)lastMap.get(i);

							if(uWList == null){
								uWList = makeLinkedList();
								lastMap.put(i, uWList);
							}
							uWList.add(uWrapper);
							lastMap = UnsafeMapIterator_i_ListMap;
							uWList = (SimpleLinkedList<UnsafeMapIteratorWrapper>)lastMap.get(i);

							if(uWList == null){
								uWList = makeLinkedList();
								lastMap.put(i, uWList);
							}
							uWList.add(uWrapper);
							lastMap = UnsafeMapIterator_map_ListMap;
							uWList = (SimpleLinkedList<UnsafeMapIteratorWrapper>)lastMap.get(map);

							if(uWList == null){
								uWList = makeLinkedList();
								lastMap.put(map, uWList);
							}
							uWList.add(uWrapper);

						}
					}
				}
			}

			if(mainWrapper == null) {
				mainWrapper = new UnsafeMapIteratorWrapper();
				mainWrapper.param_c = new WeakReference(c);
				mainWrapper.param_i = new WeakReference(i);
				mainMap.put(i, mainWrapper);
			}
			if(mainWrapper.monitor == null) {
				mainWrapper.monitor = new UnsafeMapIteratorMonitor_1();
				mainWrapper.tau = this.timestamp++;
				m = UnsafeMapIterator_c_i_ListMap;
				obj = m.get(c);
				if(obj == null) {
					obj = makeMap();
					m.put(c, obj);
				}
				lastMap = (Map)obj;
				uWList = (SimpleLinkedList<UnsafeMapIteratorWrapper>)lastMap.get(i);

				if(uWList == null){
					uWList = makeLinkedList();
					lastMap.put(i, uWList);
				}
				uWList.add(mainWrapper);
				lastMap = UnsafeMapIterator_i_ListMap;
				uWList = (SimpleLinkedList<UnsafeMapIteratorWrapper>)lastMap.get(i);

				if(uWList == null){
					uWList = makeLinkedList();
					lastMap.put(i, uWList);
				}
				uWList.add(mainWrapper);

			}

			mainWrapper.disable = this.timestamp++;
		}
		m = UnsafeMapIterator_c_i_ListMap;
		obj = m.get(c);
		if(obj == null) {
			obj = makeMap();
			m.put(c, obj);
		}
		m = (Map)obj;
		uWList = (SimpleLinkedList<UnsafeMapIteratorWrapper>)m.get(i);

		if(uWList != null) {
			Iterator it = uWList.iterator();
			while(it.hasNext()) {
				monitorWrapper = (UnsafeMapIteratorWrapper)it.next();
				if(monitorWrapper == null) {
					it.remove();
				} else {
					monitorWrapper.monitor.createIter(c,i);
					if(monitorWrapper.monitor.MOP_match()) {
						System.out.println("unsafe iterator usage!");
					}

				}
			}
		}
	}

	pointcut UnsafeMapIterator_useIter1(Iterator i) : (call(* Iterator.next()) && target(i)) && !within(UnsafeMapIteratorMonitor_1) && !within(UnsafeMapIteratorWrapper) && !within(UnsafeMapIteratorMonitorAspect) && !within(SimpleLinkedList) && !adviceexecution();
	before (Iterator i) : UnsafeMapIterator_useIter1(i) {
		boolean skipAroundAdvice = false;
		Object obj = null;
		Map m;
		SimpleLinkedList<UnsafeMapIteratorWrapper> tempList;
		UnsafeMapIteratorWrapper mainWrapper;
		UnsafeMapIteratorWrapper uWrapper;
		UnsafeMapIteratorWrapper pWrapper;
		UnsafeMapIteratorWrapper monitorWrapper;
		Map mainMap;
		Map lastMap;
		SimpleLinkedList<UnsafeMapIteratorWrapper> uWList;

		mainMap = UnsafeMapIterator_i_Map;
		mainWrapper = (UnsafeMapIteratorWrapper) mainMap.get(i);

		if (mainWrapper == null || mainWrapper.monitor == null) {

			if(mainWrapper == null) {
				mainWrapper = new UnsafeMapIteratorWrapper();
				mainWrapper.param_i = new WeakReference(i);
				mainMap.put(i, mainWrapper);
			}
			if(mainWrapper.monitor == null) {
				mainWrapper.monitor = new UnsafeMapIteratorMonitor_1();
				mainWrapper.tau = this.timestamp++;
				lastMap = UnsafeMapIterator_i_ListMap;
				uWList = (SimpleLinkedList<UnsafeMapIteratorWrapper>)lastMap.get(i);

				if(uWList == null){
					uWList = makeLinkedList();
					lastMap.put(i, uWList);
				}
				uWList.add(mainWrapper);

			}

			mainWrapper.disable = this.timestamp++;
		}
		m = UnsafeMapIterator_i_ListMap;
		uWList = (SimpleLinkedList<UnsafeMapIteratorWrapper>)m.get(i);

		if(uWList != null) {
			Iterator it = uWList.iterator();
			while(it.hasNext()) {
				monitorWrapper = (UnsafeMapIteratorWrapper)it.next();
				if(monitorWrapper == null) {
					it.remove();
				} else {
					monitorWrapper.monitor.useIter(i);
					if(monitorWrapper.monitor.MOP_match()) {
						System.out.println("unsafe iterator usage!");
					}

				}
			}
		}
	}

	pointcut UnsafeMapIterator_updateMap1(Map map) : ((call(* Map.put*(..)) || call(* Map.putAll*(..)) || call(* Map.clear()) || call(* Map.remove*(..))) && target(map)) && !within(UnsafeMapIteratorMonitor_1) && !within(UnsafeMapIteratorWrapper) && !within(UnsafeMapIteratorMonitorAspect) && !within(SimpleLinkedList) && !adviceexecution();
	after (Map map) : UnsafeMapIterator_updateMap1(map) {
		boolean skipAroundAdvice = false;
		Object obj = null;
		Map m;
		SimpleLinkedList<UnsafeMapIteratorWrapper> tempList;
		UnsafeMapIteratorWrapper mainWrapper;
		UnsafeMapIteratorWrapper uWrapper;
		UnsafeMapIteratorWrapper pWrapper;
		UnsafeMapIteratorWrapper monitorWrapper;
		Map mainMap;
		Map lastMap;
		SimpleLinkedList<UnsafeMapIteratorWrapper> uWList;

		mainMap = UnsafeMapIterator_map_Map;
		mainWrapper = (UnsafeMapIteratorWrapper) mainMap.get(map);

		if (mainWrapper == null || mainWrapper.monitor == null) {

			if(mainWrapper == null) {
				mainWrapper = new UnsafeMapIteratorWrapper();
				mainWrapper.param_map = new WeakReference(map);
				mainMap.put(map, mainWrapper);
			}
			if(mainWrapper.monitor == null) {
				mainWrapper.monitor = new UnsafeMapIteratorMonitor_1();
				mainWrapper.tau = this.timestamp++;
				lastMap = UnsafeMapIterator_map_ListMap;
				uWList = (SimpleLinkedList<UnsafeMapIteratorWrapper>)lastMap.get(map);

				if(uWList == null){
					uWList = makeLinkedList();
					lastMap.put(map, uWList);
				}
				uWList.add(mainWrapper);

			}

			mainWrapper.disable = this.timestamp++;
		}
		m = UnsafeMapIterator_map_ListMap;
		uWList = (SimpleLinkedList<UnsafeMapIteratorWrapper>)m.get(map);

		if(uWList != null) {
			Iterator it = uWList.iterator();
			while(it.hasNext()) {
				monitorWrapper = (UnsafeMapIteratorWrapper)it.next();
				if(monitorWrapper == null) {
					it.remove();
				} else {
					monitorWrapper.monitor.updateMap(map);
					if(monitorWrapper.monitor.MOP_match()) {
						System.out.println("unsafe iterator usage!");
					}

				}
			}
		}
	}

}