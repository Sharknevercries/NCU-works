package GameState;

import java.util.ArrayList;

public class GameStateManager {
	private ArrayList<GameState> gameStates;
	private int currentState;
	
	public static final int MENUSTATE = 0;
	public static final int TOWERSTATE = 1;
	public static final int HELPSTATE = 2;
	public static final int GAMEOVERSTATE = 3;
	public static final int GAMEENDSTATE = 4;
	
	public GameStateManager(){
		gameStates = new ArrayList<GameState>();
		
		currentState = MENUSTATE;
		gameStates.add(new MenuState(this));
		gameStates.add(new TowerState(this));
		gameStates.add(new HelpState(this));
		gameStates.add(new GameOverState(this));
		gameStates.add(new GameEndState(this));
	}
	
	public void setState(int state){
		gameStates.get(state).initialize();
		try
		{
			Thread.sleep(100);
		}
		catch(Exception e){
			e.printStackTrace();
		}
		currentState = state;
	}
	
	public void draw(java.awt.Graphics2D g){
		gameStates.get(currentState).draw(g);
	}
	
	public void keyPressed(int e){
		gameStates.get(currentState).keyPressed(e);
	}
	
	public void keyReleased(int e){
		gameStates.get(currentState).keyReleased(e);
	}
	
	
}
