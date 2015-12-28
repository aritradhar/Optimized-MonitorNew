package monitors.hasNext;

import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;

public class FailTest 
{

	public static void main(String[] args) 
	{
		new FailTest().foo();
	}
	public void foo()  
	{		
		Collection<Collection<Integer>> set_container = new HashSet<Collection<Integer>>();
		Collection<Iterator<Integer>> iter_container = new HashSet<Iterator<Integer>>();
		
		for(int i = 0; i<10; i++)
		{
			Collection<Integer> c = new HashSet<Integer>();
			set_container.add(c);
			for(int j=0; j<10; j++)
			{
				c.add(j);
			}
			
			for(int k=0; k<10; k++)
			{
				Iterator<Integer> it = c.iterator();
				iter_container.add(it);
				int x = 0;
				while(it.hasNext())
				{
					x += it.next();
					it.next();
					c.add(x);
				}
			}
			
		}
		System.out.println("The size of set_container is " + 
							set_container.size() + 
							" and the size of iter_container is " + iter_container.size());
		System.exit(0);
	}
	
}
