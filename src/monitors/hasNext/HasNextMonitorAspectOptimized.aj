package monitors.hasNext;
/* Original JavaMOP 2.1 aspect for HasNext property */
import java.lang.management.ManagementFactory;
import java.lang.management.MemoryPoolMXBean;
import java.lang.management.MemoryUsage;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.commons.collections.map.*;

import trace.StackTrace;

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

	synchronized public static double getMonitorCreation(long count)
	{		
		double monitorCreationProbability = 0;
		
		if(count>=0 && count<10){
			monitorCreationProbability=1;
		}

		else if(count>=10 && count<50){
			monitorCreationProbability=0.5;
		}

		else if(count>=50 && count<100){
			monitorCreationProbability=0.25;
		}

		else if(count>=100 && count<500){
			monitorCreationProbability=0.125;
		}

		else if(count>=500 && count<1000){
			monitorCreationProbability=0.0625;
		}

		else if(count>=1000 && count<2000){
			monitorCreationProbability=0.03125;
		}

		else if(count>=2000 && count<4000){
			monitorCreationProbability=0.015625;
		}
		
		else if(count>=4000 && count<7000){
			monitorCreationProbability=0.0078125;
		}
		
		else if(count>=7000 && count<10000){
			monitorCreationProbability=0.00390625;
		}
		
		else{
			monitorCreationProbability=0;
		}
		
		return monitorCreationProbability;

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

	static volatile Map<Object, Object> indexing_lock = new HashMap<>();

	static volatile Map<Object, Object> HasNext_i_Map = null;

	static volatile Map<Long, List<Object>> monitor_trace_map = new ConcurrentHashMap<>();
	
	static volatile long monitor_counter = 0, has_next_counter = 0, next_counter = 0, error_counter = 0, creation_logged = 0;
	
	static volatile Map<Object, Object> iterContextMap = new HashMap<>();
	
	static volatile Set<Object> errorContext = new HashSet<>();
	
	static volatile long prob_created = 0;

	pointcut HasNext_create1() : (call(Iterator Collection+.iterator())) && !within(HasNextMonitor_1) && !within(HasNextMonitorAspectOptimized)  && !within(trace.StackTrace) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
	@SuppressWarnings("rawtypes")
	after () returning (Iterator i) : HasNext_create1() {
		
		creation_logged++;
		
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
				
				long currentStackTrace = StackTrace.trace;
				if(monitor_trace_map.containsKey(currentStackTrace))
				{
					List<Object> monitors = monitor_trace_map.get(currentStackTrace);
					int creationCounter = monitors.size();
					double monitorCreationProb = HasNextMonitor_1.getMonitorCreation(creationCounter);
					
					if(new Random().nextDouble() < monitorCreationProb)
					{
						prob_created++;
						monitor = new HasNextMonitor_1();
						m.put(i, monitor);
						monitors.add(monitor);
						monitor_trace_map.put(currentStackTrace, monitors);
						iterContextMap.put(i, currentStackTrace);
						monitor_counter++;
					}
				}
				
				else
				{
					monitor = new HasNextMonitor_1();
					m.put(i, monitor);
					List<Object> monitors = new ArrayList<>();
					monitors.add(monitor);	
					monitor_trace_map.put(currentStackTrace, monitors);
					iterContextMap.put(i, currentStackTrace);
					monitor_counter++;
				}
			}

		}
		if(monitor!=null)
		{
			monitor.create(i);
			if(monitor.MOP_fail()) {
				//System.err.println("! hasNext() has not been called" + " before calling next() for an" + " iterator");
				errorContext.add(iterContextMap.get(i));
				error_counter++;
				monitor.reset();
			}

		}
	}

	@SuppressWarnings("rawtypes")
	pointcut HasNext_hasnext1(Iterator i) : (call(* Iterator.hasNext()) && target(i)) && !within(trace.StackTrace) && !within(HasNextMonitor_1) && !within(HasNextMonitorAspectOptimized) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
	after (Iterator i) : HasNext_hasnext1(i) {
		
		has_next_counter++;
		
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
				error_counter++;
				//System.err.println("! hasNext() has not been called" + " before calling next() for an" + " iterator");
				errorContext.add(iterContextMap.get(i));
				monitor.reset();
			}

		}


	}

	pointcut HasNext_next1(Iterator i) : (call(* Iterator.next()) && target(i)) && !within(HasNextMonitor_1) && !within(trace.StackTrace) && !within(HasNextMonitorAspectOptimized) && !within(EDU.purdue.cs.bloat.trans.CompactArrayInitializer) && !adviceexecution();
	before (Iterator i) : HasNext_next1(i) {
		
		next_counter++;
		
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
				error_counter++;
				//System.err.println("! hasNext() has not been called" + " before calling next() for an" + " iterator");
				errorContext.add(iterContextMap.get(i));
				monitor.reset();
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
		System.err.println("HasNext counter : " + has_next_counter);
		System.err.println("next counter : " + next_counter);
		System.err.println("error counter : " + error_counter);
		System.err.println("---------------------------------------------------------");
		
		for(Object i : errorContext)
			System.err.printf("0x%08X\n",i);
			
		System.err.println("---------------------------------------------------------");
		System.err.println("prob_created counter : " + prob_created);
		System.err.println("Total contexts : " + monitor_trace_map.size());
		for(Object in : monitor_trace_map.keySet())
			System.err.printf("0x%08X\n", in);
		System.err.println("Creation logged : " + creation_logged);
		
		/*
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
		}*/
	}

	pointcut mainMethod(): execution (public static void main(String[]));

	after(): mainMethod(){
		HasNext_i_Map = null;
	}
}

