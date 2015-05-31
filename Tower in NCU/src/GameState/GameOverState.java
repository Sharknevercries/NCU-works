package GameState;

import java.awt.Color;
import java.awt.Graphics2D;

import Audio.AudioPlayer;
import Image.ImageUnit;
import Main.GamePanel;

public class GameOverState extends GameState{
	private ImageUnit img; 
	private AudioPlayer audioPlayer;
	
	private float op;
	
	public GameOverState(GameStateManager gsm) {
		this.gsm = gsm;
		audioPlayer = AudioPlayer.getInstance();
		img = new ImageUnit("/Obj/gameOver.png");
		img.setPosition(0, 0);
	}
	
	public void draw(Graphics2D g) {
		g.setColor(Color.black);
	    g.fillRect(0, 0, GamePanel.WIDTH, GamePanel.HEIGHT);
	    
	    op += 0.01;
		img.draw(g, op, 0, 0);

		if(op > 1.5){
			gsm.setState(GameStateManager.MENUSTATE);
			audioPlayer.stop("gameover");
		}
		
	}

	public void initialize() {
		op = 0.0f;
		audioPlayer.play("gameover");
	}

	public void keyPressed(int k) {
	}

	public void keyReleased(int k) {
	}

}
