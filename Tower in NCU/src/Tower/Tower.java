package Tower;

public class Tower {
	
	private static Tower tower = new Tower();
	private final static int MAXFLOOR = 5;
	
	private Floor[] floors; 
	
	private Tower(){
		floors = new Floor[MAXFLOOR];
		for(int i = 0; i < MAXFLOOR; i++)
			floors[i] = new Floor();
			
	}
	
	public static Tower getInstance(){	return tower;	}
	public Floor getFloor(int currentFloor){	return floors[currentFloor];	}
	
	public void initialize(){
		for(int i = 0; i < MAXFLOOR; i++)
			floors[i].loadFloor("/Floors/floor" + (i + 1) + ".txt");
	}
	
}
