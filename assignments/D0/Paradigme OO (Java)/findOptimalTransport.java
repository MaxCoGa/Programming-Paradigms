/**
* The findOptimalTransport program implements the transportation problem
*  that find the best path between Demand and Supply.
*  We are using the mimunum cell cost method to find our first solution
*  that we will use to find the optimal solution using the stepping stones
*  method.
*
* @author  Maxime Côté-Gagné
* @id 8851539
*/
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.Scanner;

import static java.util.Arrays.stream;
import static java.util.stream.Collectors.toCollection;

 
public class findOptimalTransport {
	
	
	/*
	 * Attributes
	 */
    private Usine[] demand;//Demand  ,  bottom row 
    private Entrepot[] supply;//Supply  ,  last colunm
    private int[][] costs;//Cost per cell matrix
    private Transport[][] cellPath;//matrix use between method to find the optimal path
    
    
    
    

   /*
    * Initialize our costs matrix and our Tranportation matrix from
    * the file given by the user.
    * 
    *  @param filename a string given by the user in arguments to this program
    * 
    */
   private void read(String filename) throws Exception {
	   int numSupply;
	   int numDemand;
        try (Scanner sc = new Scanner(new File(filename))) {
            numSupply = sc.nextInt();//Supply
            int numLine = numSupply+3;//3 because first,second and last line doesnt count
            numDemand = sc.nextInt();//Demand
            int lineLenght = numDemand+2;//since first(position) int and last(supply)
            
            demand = new Usine[numDemand];
            supply = new Entrepot[numSupply];
            
            List<Integer> sup = new ArrayList<>();//supply list
            List<Integer> dem = new ArrayList<>();//demand list
            
            sc.nextLine();//change from 1 to 2
            sc.nextLine();//change from 2 to 3 since this line is not use
            
            //SUPPLY LOOP
            int it=0;
            for(int j = 3; j<numLine;j++){
	            for (int i = 0; i < lineLenght; i++){
	            	if(i == lineLenght-1){
	            		//System.out.print("Supply:");
	            		int tmpSupply = sc.nextInt();
	            		//System.out.println(tmpSupply);
	            		sup.add(tmpSupply);
	            		supply[it]=new Entrepot(tmpSupply);
	            		it++;
	            	}else{
	            		sc.nextInt();
	            	}
	            }
	            sc.nextLine();
            }
            
            //Final line start with Demand a string
            sc.next();
            
            //DEMAND LOOP
            for (int i = 0; i < numDemand; i++){
            	int tmpDemand = sc.nextInt();
            	//System.out.println("Demand:"+tmpDemand);
                dem.add(tmpDemand);
                demand[i] = new Usine(tmpDemand);
            }
            
            //fix
            /*
            supply = sup.stream().mapToInt(i -> i).toArray();
            demand = dem.stream().mapToInt(i -> i).toArray();
            */
            costs = new int[supply.length][demand.length];//INIT COSTS
            cellPath = new Transport[supply.length][demand.length];//INIT MATRIX

            //INIT each cell in the cost matrix
            try(Scanner c = new Scanner(new File(filename))){
            	c.nextLine();
            	c.nextLine();
	            for (int i = 0; i < numSupply; i++){
	            	c.nextInt();
	                for (int j = 0; j < numDemand; j++){
	                	costs[i][j]= c.nextInt();
	                }
	                c.nextInt();
	            }
	            c.close();
            }
            sc.close();
        }
        
        d = new Usine[demand.length];
        s = new Entrepot[supply.length];
        System.out.println("Demand warehouses:"+numDemand);
        for(int i=0;i<demand.length;i++){
        	System.out.print(" "+(demand[i]).capacity+" ");
        	d[i]=new Usine((demand[i]).capacity);
        }
        System.out.println();
        
        System.out.println("Supply warehouses:"+numSupply);
        for(int i=0;i<supply.length;i++){
        	System.out.println(" "+(supply[i]).capacity+" ");
        	s[i]=new Entrepot((supply[i]).capacity);
        }
        System.out.println();

   }
   
   
   
   
   /*
    * Save the different solutions of the transportation problem to the format
    * given. Can save the minimum cell costs method and 
    * the stepping stones methods.
    * 
    *  @param filename a string use as a path to save a file
    * 
    */
   private Usine[] d;//acces to a clone demand array
   private Entrepot[] s;//acces to a clone supply array
   private int dsMax;//acces to the maximum supply and demand of the problem
   private void write(String filename){
	   
	 //write on file
		  try{
		  	FileWriter fw = new FileWriter(filename,true); //the true will append the new data
		  	BufferedWriter out = new BufferedWriter(fw);
		  	
		  	//WRITE SUPPLY DEMAND
		  	out.write(String.valueOf(supply.length));
		  	out.write(" ");
		  	out.write(String.valueOf(demand.length));
		  	out.newLine();
		  	
		  	
		  	//WRITE A B C ... SUPPLY
		  	char ch = 'A';
		  	for(int i=0;i<supply.length;i++){
		  		out.append(ch);
		  		out.append(' ');
		  		ch++;
		  	}
		  	out.append("Supply");
		  	out.newLine();
		  	
		  	//WRITE row
		  	for(int r=0;r<supply.length;r++){
		  		out.write(String.valueOf(r+1));
		  		out.write(" ");
		  		for(int c=0;c<demand.length;c++){
		  			
		  			if(cellPath[r][c]!=null){
		  				out.write((String.valueOf((int)(cellPath[r][c]).capacity)));
		  				out.write(" ");
		  			}else{
		  				out.write(String.valueOf("0" + " " ));
		  			}
		  		}
		  		out.write(String.valueOf((s[r]).capacity));
		  		out.newLine();
		  	}
		  	
		  	
		  	//write DEMAND
		  	out.append("Demand"+' ');
		  	for(int i=0;i<demand.length;i++){
		  		out.write(String.valueOf((d[i]).capacity));
		  		out.write(" ");
		  	}
		  	out.write(String.valueOf(dsMax));

		  	//CLOSE FILE
		    out.close();
		    System.out.println("File Created!");
		  }catch(IOException ioe)
		    {
		        System.err.println("IOException: " + ioe.getMessage());
		    }
		  System.out.println();
   }
   
   
   
   
   
   
   /*
    * Minimum cell cost method is use 
    * to obtain the initial feasible 
    * solution for the transportation problem.
    */
   private int sMax = 0;//Maximum of supply
   private void minimalCost() {
	   degenerate();//degenerate case
	   
	   for(int m=0;m<supply.length;m++){
		   sMax +=(supply[m]).capacity;
	   }
	   dsMax = sMax;
	   System.out.println("Maximum Supply: "+ sMax);
	   
	   
	   System.out.println("Minimum Cell Cost Method Solution: ");
	   int array[] = new int[supply.length*demand.length];
	   int i=0;
	   for(int r = 0; r<supply.length;r++){
		   for(int c= 0; c<demand.length;c++){
			   array[i]=costs[r][c];
			   i++;
		   }
	   }
	   Arrays.sort(array);
	   i=0;
	   while(sMax != 0){
		   for(int r = 0; r<supply.length;r++){
			   for(int c= 0; c<demand.length;c++){
				   
				   if(i==array.length){
					   break;
				   }
				   if(costs[r][c] == array[i]){
					   int capacity = Math.min((supply[r]).capacity, (demand[c]).capacity);
		               if (capacity > 0) {
		            	   cellPath[r][c] = new Transport(capacity, costs[r][c], r, c);
		                   (supply[r]).capacity -= capacity;
		                   (demand[c]).capacity -= capacity;
		                   sMax-=capacity;
		                   i++;
		               }else if(capacity==0){
		            	   i++;
		               }
				   }
			   }
		   }
	   }
	}
   	
  
   
   
   
   	//PAS JAPONAIS
   /*
    * Using the solution from the minimal cell costs method
    * The stepping stones method search to find a path where
    * it have less costs while changing by -1(initial cell to change)
    * and +1 in a circle.
    */
   private int numRec = 0 ;//number of recursion for the steppingStones()
   private void steppingStone() {
       degenerate();//degeneratecase
       
       
       Transport[] change= null;
       Transport quit = null;
       double maxReduction = 0;
       //Row=row=r & Column=col=c
       for (int row = 0; row < supply.length; row++) {
           for (int col = 0; col < demand.length; col++) {
                if (cellPath[row][col] != null) {
                	continue;
                }
 
               Transport testPath = new Transport(0, costs[row][col], row, col);
               Transport[] route = pathFinder(testPath);//Try to find a route/path
 
               
               double reduction = 0;
               double lowCap = Integer.MAX_VALUE;
               Transport candidate = null;

               
               boolean plus_minus = true;//plus==true, minus==false
               for (Transport path : route) {
                   if (plus_minus) {//true
                       reduction += path.costCell;
                   }else if(!plus_minus) {//false
                       reduction -= path.costCell;
                       if (path.capacity < lowCap) {
                    	   candidate = path;
                    	   lowCap = path.capacity;
                       }
                   }
                   plus_minus = !plus_minus;//change more boolean to true if false or to false if true
               }
               if (reduction < maxReduction) {
            	   change = route;
                   quit = candidate;
                   maxReduction = reduction;
               }
           }
       }
       if (change != null) {
           double qCap = quit.capacity;
           boolean plus_minus = true;
           for (Transport path : change) {
        	   path.capacity += plus_minus ? qCap : -qCap;
               cellPath[path.r][path.c] = path.capacity == 0 ? null : path;
               plus_minus = !plus_minus;
           }
           numRec++;
           steppingStone();
       }
   }
 
    /*
     * Test combinations of inputs that may be rare, but still possible.
     * Will expose obvious issues.
     */
    private void degenerate() {
        final double worst = Double.MIN_VALUE;//min possible value to test
 
        if (supply.length + demand.length - 1 != toList().size()) {
 
            for (int r = 0; r < supply.length; r++)
                for (int c = 0; c < demand.length; c++) {
                    if (cellPath[r][c] == null) {
                        Transport tmp = new Transport(worst, costs[r][c], r, c);
                        if (pathFinder(tmp).length == 0) {
                        	cellPath[r][c] = tmp;
                            return;//should work
                        }
                    }
                }
        }
    }
    

    
    /*
     * Use to find where the path are closed(no neighboring cell)
     * vertically or horizontally.
     * @param testPath Transport object
     */
    private Transport[] pathFinder(Transport testPath) {
    	LinkedList<Transport> pathList = toList();
        pathList.addFirst(testPath);
        
        //vertically or horizontally.
        //remove elems without vertical or horizontal neighbors
        while (pathList.removeIf(element -> {
        	
        	//Find nearest Cell
        	Transport[] neighbors = new Transport[2];
            for (Transport t : pathList) {
                if (t != element) {
                    if (t.r == element.r && neighbors[0] == null) {
                    	neighbors[0] = t;
                    }
                    else if (t.c == element.c && neighbors[1] == null) {
                    	neighbors[1] = t;
                    }
                    if (neighbors[0] != null && neighbors[1] != null) {
                    	break;
                    }
                }
            }
            Transport[] remover = neighbors;
            return remover[0] == null || remover[1] == null;//remove the nullpointer exception
        }));
        
        
        //ROERDER
        //reorder remaining elems
        Transport[] finalPath = pathList.toArray(new Transport[pathList.size()]);
        Transport prevPath = testPath;
        for (int i = 0; i < finalPath.length; i++) {
     	   finalPath[i] = prevPath;
     	   
     	//Find nearest Cell
       	Transport[] neighbors = new Transport[2];
           for (Transport t : pathList) {
               if (t != prevPath) {
                   if (t.r == prevPath.r && neighbors[0] == null) {
                   	neighbors[0] = t;
                   }
                   else if (t.c == prevPath.c && neighbors[1] == null) {
                   	neighbors[1] = t;
                   }
                   if (neighbors[0] != null && neighbors[1] != null) {
                   	break;
                   }
               }
           }
     	   
     	   prevPath = neighbors[i % 2];
        }
        return finalPath;
	}

    /*
     * Linkedlist method of Object Transport creating a list with a matrix
     */
	private LinkedList<Transport> toList() {
		// TODO Auto-generated method stub
		
        return stream(cellPath).flatMap(row -> stream(row)).filter(supply -> supply != null).collect(toCollection(LinkedList::new));
	}
	
	
	/*
     * Print the result of the matrix after a transformation using minimal cost and stepping stones methods
     */
    private void printResult() {
        double totalCosts = 0;
 
        for (int r = 0; r < supply.length; r++) {
            for (int c = 0; c < demand.length; c++) {
                if ((cellPath[r][c]) != null && (cellPath[r][c]).r == r && (cellPath[r][c]).c == c) {
                    System.out.printf(" %3s ", (int) (cellPath[r][c]).capacity);
                    totalCosts += ((cellPath[r][c]).capacity * (cellPath[r][c]).costCell);
                } else
                    System.out.printf("  0  ");
            }
            System.out.println();
        }
        System.out.println("Total:"+ (int)totalCosts);
    }
    
    
    
    /*
     * Print the matrix with the cost in each cell
     */
    private void printCosts(){
    	System.out.println("Initial Cost per Cell:");
    	for(int r = 0; r<supply.length; r++){
    		for (int c=0;c<demand.length;c++){
    			System.out.printf(" %3s ", (int)costs[r][c]);
    		}
    		System.out.println();
    	}
    	System.out.println();
    }
 
    
    /*
     * Start of the findOptimalTranport program
     * 
     * @param args File name to use to find a solution to the 
     * transportation problem
     */
    public static void main(String[] args) throws Exception {
    	findOptimalTransport instance= new findOptimalTransport();
    	
    	Scanner keyboard = new Scanner(System.in);
    	
    	String fn=args[0];
    	System.out.println(fn);
    	/*
   	  	System.out.println("Enter the File Name:             *(without .txt)*");
   	  	fn = keyboard.nextLine();
   	  	*/
        for (String filename : new String[]{fn}) {
        	instance.read(filename);
        	instance.printCosts();
        	
            
            instance.minimalCost();
            instance.printResult();
            instance.write(fn+"minimalCostSolution.txt");
            
            
            instance.steppingStone();
            System.out.println("Stepping Stone Solution: "+"  Number of recursions:"+instance.numRec);
            instance.printResult();
            instance.write(fn+"steppingStoneSolution.txt");
        }
        
        System.out.println("Finish?");
        if(keyboard.nextLine().equals("Y")){
        	System.out.println("Program terminated!");
        	System.exit(0);
        } else{
        	System.out.println("Program terminated!");
        	System.exit(0);
        }
        keyboard.close();
    }
}
