package monitors.iterOriginal;

/* Original JavaMOP 2.1 aspect for UnsafeIterator property*/
import java.util.*;
import org.apache.commons.collections.map.*;

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
	synchronized public final void create(Collection c,Iterator i) {
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
}

public aspect UnsafeIteratorMonitorAspectOriginal {
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

	static Map UnsafeIterator_c_i_Map = null;
	static Map UnsafeIterator_c_Map = null;
	static Map UnsafeIterator_i_Map = null;

	static long maxTimeUpdate = 0;
	
	static volatile long monitor_counter = 0, next_counter = 0, update_counter = 0, error_counter = 0;

	pointcut UnsafeIterator_create1(Collection c) : (call(Iterator Collection+.iterator()) && target(c)) && !within(UnsafeIteratorMonitor_1) && !within(UnsafeIteratorMonitorAspectOriginal) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
	after (Collection c) returning (Iterator i) : UnsafeIterator_create1(c) {
		boolean skipAroundAdvice = false;
		Object obj = null;

        UnsafeIteratorMonitor_1 monitor = null;
		boolean toCreate = false;
                
		Map m = UnsafeIterator_c_i_Map;
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
			m = (Map)obj;
			obj = m.get(i);

			monitor = (UnsafeIteratorMonitor_1) obj;
			toCreate = (monitor == null);
			if (toCreate){
				
				monitor_counter++;
                monitor = new UnsafeIteratorMonitor_1();
                m.put(i, monitor);

		    }
			if(toCreate) {
				m = UnsafeIterator_c_Map;
				if (m == null) m = UnsafeIterator_c_Map = makeMap(c);
				obj = null;
				synchronized(UnsafeIterator_c_Map) {
					obj = m.get(c);
					List monitors = (List)obj;
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
					List monitors = (List)obj;
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
				error_counter++;
				System.out.println("improper iterator usage");
			}

		}

	}
	}

	pointcut UnsafeIterator_updatesource1(Collection c) : ((call(* Collection+.remove*(..)) || call(* Collection+.add*(..))) && target(c)) && !within(UnsafeIteratorMonitor_1) && !within(UnsafeIteratorMonitorAspectOriginal) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
	after (Collection c) : UnsafeIterator_updatesource1(c) {
		
		update_counter++;
		boolean skipAroundAdvice = false;
		Object obj = null;
        Map m = UnsafeIterator_c_Map;
       
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
						error_counter++;
						System.err.println("improper iterator usage");
					}

				}
			}
		}
		
    }

	pointcut UnsafeIterator_next1(Iterator i) : (call(* Iterator.next()) && target(i)) && !within(UnsafeIteratorMonitor_1) && !within(UnsafeIteratorMonitorAspectOriginal) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
	before (Iterator i) : UnsafeIterator_next1(i) {
		
		next_counter++;
		
		boolean skipAroundAdvice = false;
		Object obj = null;

		Map m = UnsafeIterator_i_Map;

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
						error_counter++;
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
		System.err.println("error counter : " + error_counter);
	}
	
	pointcut mainMethod(): execution (public static void main(String[]));
	
	before(): mainMethod(){
						
		UnsafeIterator_i_Map = null;
		UnsafeIterator_c_i_Map = null;
		UnsafeIterator_c_Map = null;
	}

	}