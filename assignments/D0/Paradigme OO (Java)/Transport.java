/**
* Transport Object
*
* @author  Maxime Côté-Gagné
* @id 8851539
*/
public class Transport {
	 final double costCell;
     final int r;
     final int c;
     double capacity;

     public Transport(double cap, double cost, int r, int c) {
    	 capacity = cap;
         costCell = cost;
         this.r = r;
         this.c = c;
     }
}
