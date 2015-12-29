package monitors.hasNext;
/* Original JavaMOP 2.1 aspect for HasNext property */
import java.io.*;
import java.util.*;
import org.apache.commons.collections.map.*;
import java.lang.ref.WeakReference;


public aspect HasNextMonitorAspectOriginal {
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
	
	
	pointcut HasNext_create1() : (call(Iterator Collection+.iterator())) && !within(HasNextMonitor_1) && !within(HasNextMonitorAspectOriginal) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
	after () returning (Iterator i) : HasNext_create1() {
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

	pointcut HasNext_hasnext1(Iterator i) : (call(* Iterator.hasNext()) && target(i)) && !within(HasNextMonitor_1) && !within(HasNextMonitorAspectOriginal) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
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

	pointcut HasNext_next1(Iterator i) : (call(* Iterator.next()) && target(i)) && !within(HasNextMonitor_1) && !within(HasNextMonitorAspectOriginal) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
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
			// System.out.println("The number of monitors created are: " + num_monitors);
			//System.out.println("Number of trees matching: "+num_matches);
		}
	
	pointcut mainMethod(): execution (public static void main(String[]));
	
		after(): mainMethod(){
			HasNext_i_Map = null;
		}
}

