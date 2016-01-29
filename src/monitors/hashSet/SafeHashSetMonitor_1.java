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

import java.util.HashSet;

public class SafeHashSetMonitor_1 implements Cloneable {
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
		double monitorCreationProbability = 0;
		
		if(count>=0 && count<10){
			monitorCreationProbability=1;
		}

		else if(count>=10 && count<50){
			monitorCreationProbability=0.05;
		}

		else if(count>=50 && count<100){
			monitorCreationProbability=0.0125;
		}

		else if(count>=100 && count<500){
			monitorCreationProbability=0.00125;
		}

		else if(count>=500 && count<1000){
			monitorCreationProbability=0.00625;
		}

		else if(count>=1000 && count<2000){
			monitorCreationProbability=0.003125;
		}

		else if(count>=2000 && count<4000){
			monitorCreationProbability=0.0015625;
		}
		
		else if(count>=4000 && count<7000){
			monitorCreationProbability=0.00078125;
		}
		
		else if(count>=7000 && count<10000){
			monitorCreationProbability=0.000390625;
		}
		
		else{
			monitorCreationProbability=0;
		}
		
		return monitorCreationProbability;

	}
}

