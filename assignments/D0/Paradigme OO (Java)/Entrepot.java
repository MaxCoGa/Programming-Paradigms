/**
* Entrepot Object
*
* @author  Maxime Côté-Gagné
* @id 8851539
*/
public class Entrepot implements Cloneable{
	int capacity;

    public Entrepot(int cap) {
   	 	this.capacity = cap; 
    }
    
    protected Object clone() throws CloneNotSupportedException{
    	return super.clone();
    }
}
