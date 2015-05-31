package GameState;

import Image.ImageUnit;
import Main.GamePanel;

import java.awt.*;
import java.awt.event.KeyEvent;

public class MenuState extends GameState {
	private ImageUnit bg;
	private int currentChoice = 0;
	private String[] options = {"Start", "Help", "Quit"};
	private Color titleColor;
	private Color menuColor;
	private Font titleFont;
	private Font menuFont;
	
	public MenuState(GameStateManager gsm){
		this.gsm = gsm;
		try{
			bg = new ImageUnit("/Obj/Title.png");
			bg.setPosition(0, 0);
			
			titleColor = new Color(200, 100, 100);
			titleFont = new Font("Century Gothic", Font.PLAIN, 28);
			menuColor = new Color(0, 0, 30);
			menuFont = new Font("Arial", Font.PLAIN, 18);
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public void draw(Graphics2D g){
		bg.draw(g, GamePanel.WIDTH, GamePanel.HEIGHT);
		
		// set title content
		g.setColor(titleColor);
		g.setFont(titleFont);
		g.drawString("Tower in NCU", 80, 70);
		
		// set menu content
		g.setFont(menuFont);
		
		for(int i = 0; i < options.length; i++){
			if(i == currentChoice){
				g.setColor(Color.RED);
			}
			else{
				g.setColor(menuColor);
			}
			g.drawString(options[i], 450, 310 + (i * 30));
		}
	}
	
	private void select(){
		if(currentChoice == 0)
			gsm.setState(GameStateManager.TOWERSTATE);
		if(currentChoice == 1)
			gsm.setState(GameStateManager.HELPSTATE);
		if(currentChoice == 2)
			System.exit(0);
		
	}

	@Override
	public void keyPressed(int k){
		if(k == KeyEvent.VK_ENTER){
			select();
		}
		if(k == KeyEvent.VK_UP){
			currentChoice--;
			if(currentChoice == -1){
				currentChoice = options.length - 1;
			}
		}
		if(k == KeyEvent.VK_DOWN){
			currentChoice++;
			if(currentChoice == options.length){
				currentChoice = 0;
			}
		}
	}
	
	@Override
	public void keyReleased(int k) {
		
	}

	@Override
	public void initialize() {
		currentChoice = 0;
	}
}
