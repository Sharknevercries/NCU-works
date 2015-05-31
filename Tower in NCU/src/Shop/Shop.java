package Shop;

import java.awt.Graphics2D;
import java.awt.event.KeyEvent;

import Audio.AudioPlayer;
import Image.ImageUnit;
import Tower.Floor;

public abstract class Shop {
	
	protected final static int startX = Floor.startX;
	protected ImageUnit background;
	protected ImageUnit choiceBackground;	
	protected int currentChoice;
	protected int maxChoice;

	// audio
	protected AudioPlayer audioPlayer;
	
    Shop(){
    	background = new ImageUnit("/Obj/dialogueBackground.png");
    	background.setPosition(startX + 96, 96);
    	choiceBackground = new ImageUnit("/Obj/choiceBackground.png");
		maxChoice = 4;
		currentChoice = 0;
		audioPlayer = AudioPlayer.getInstance();
		choiceChanged();
	}
	
	protected abstract void select();
	
	private void choiceChanged(){
		choiceBackground.setPosition(startX + 96, 158 + currentChoice * 40);
	}
	
	public void keyPressed(int k) {
		if(k == KeyEvent.VK_DOWN){
			audioPlayer.play("changeChoice");
			currentChoice++;
			if(currentChoice == maxChoice)
				currentChoice = 0;
			choiceChanged();
		}
		if(k == KeyEvent.VK_UP){
			audioPlayer.play("changeChoice");
			currentChoice--;
			if(currentChoice == -1)
				currentChoice = maxChoice - 1;
			choiceChanged();
		}
		if(k == KeyEvent.VK_ENTER){
			select();
		}
	}
	
	public abstract void draw(Graphics2D g);
	
}
