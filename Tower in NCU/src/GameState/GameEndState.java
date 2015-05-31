package GameState;

import java.awt.Color;
import java.awt.Graphics2D;

import Image.ImageUnit;
import Main.GamePanel;

public class GameEndState extends GameState {

	private ImageUnit img;
	private int height;
	private int currentY;
	private final int speed = 2;
	private long a;
	private long b;
	
	public GameEndState(GameStateManager gsm){
		this.gsm = gsm;
		img = new ImageUnit("/Obj/thanks.png");
		height = img.getHeight();
	}
	
	public void draw(Graphics2D g) {
		if(currentY + GamePanel.HEIGHT + speed <= height)
			currentY += speed;
		else
			currentY = height - GamePanel.HEIGHT;
		
		g.setColor(Color.black);
		g.fillRect(0, 0, GamePanel.WIDTH, GamePanel.HEIGHT);
		img.setPosition(0, 0);
		img.draw(g, 0, currentY, GamePanel.WIDTH, GamePanel.HEIGHT);
		
		if(currentY == height - GamePanel.HEIGHT){
			try {
				Thread.sleep(2000);
			} catch (Exception e) {
				e.printStackTrace();
			}
			gsm.setState(GameStateManager.MENUSTATE);
			b = System.nanoTime();
			System.out.println((double)(b-a) / 1000000);
		}
	}

	public void initialize() {
		currentY = 0;
		a = System.nanoTime();
	}

	public void keyPressed(int k) {
		
	}

	public void keyReleased(int k) {
		
	}
	
}
