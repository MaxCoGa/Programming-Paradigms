/**
* Usine Object
*
* @author  Maxime Côté-Gagné
* @id 8851539
*/
public class Usine implements Cloneable{
	int capacity;

    public Usine(int cap) {
   	 	capacity = cap; 
    }
    
    protected Object clone() throws CloneNotSupportedException{
    	return super.clone();
    }
}

