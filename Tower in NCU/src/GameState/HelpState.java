package GameState;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.event.KeyEvent;

import Image.ImageUnit;
import Image.ScrollImage;
import Main.GamePanel;

public class HelpState extends GameState{
	private ImageUnit background;
	private ImageUnit selectedBackground;
	private ScrollImage[] content;
	private String[] title = new String[]{"遊戲介紹", "遊戲背景", "怪物介紹", "關於作者", "返回上層"};
	private final int maxChoice = 5;
	private final int gap = 6;
	private final int titleWidth = (GamePanel.WIDTH - gap * 6) / 5;
	private final int titleHeight = 110;
	private final int contentWidth = GamePanel.WIDTH - 2 * gap;
	private final int contentHeight = GamePanel.HEIGHT - 3 * gap - titleHeight;
	private int currentChoice;
	
	//576 = 6x + 5y
	//416 - 18 - 110 = 288 
	public HelpState(GameStateManager gsm){
		this.gsm = gsm;
		background = new ImageUnit("/Obj/dialogueBackground.png");
		selectedBackground = new ImageUnit("/Obj/choiceBackground2.png");
		content = new ScrollImage[maxChoice - 1];
		content[0] = new ScrollImage("/Obj/story.png", contentWidth, contentHeight);
		content[1] = new ScrollImage("/Obj/gameintro.png", contentWidth, contentHeight);
		content[2] = new ScrollImage("/Obj/monstersintro.png", contentWidth, contentHeight);
		content[3] = new ScrollImage("/Obj/author.png", contentWidth, contentHeight);
	}
	
	public void draw(Graphics2D g) {
		g.setColor(Color.black);
		g.fillRect(0, 0, GamePanel.WIDTH, GamePanel.HEIGHT);
		background.setPosition(6, 6);
		background.draw(g, contentWidth, contentHeight);
		for(int i = 0; i < maxChoice; i++){
			background.setPosition(gap + (titleWidth + gap) * i + 2, 300 + 2);
			background.draw(g, titleWidth - 4, titleHeight - 4);
			if(i == currentChoice){
				selectedBackground.setPosition(gap + (titleWidth + gap) * currentChoice, 300 - 2);
				selectedBackground.draw(g, titleWidth, titleHeight);
			}
			g.setColor(Color.white);
			g.setFont(new Font("微軟正黑體", Font.BOLD, 20));
			g.drawString(title[i], gap + (titleWidth + gap) * i + 15, 300 + titleHeight / 2 + 5);
		}
		
		if(currentChoice != maxChoice - 1) // not equal return to main menu
			content[currentChoice].draw(g, gap, gap);
	}
	
	public void initialize() {
		currentChoice = 0;
	}

	public void refreshPage(){
		if(currentChoice != maxChoice - 1)
		content[currentChoice].initialize();
	}
	
	public void keyPressed(int k) {
		if(k == KeyEvent.VK_ENTER && currentChoice == 4)
			gsm.setState(GameStateManager.MENUSTATE);
		if(k == KeyEvent.VK_LEFT){
			if(currentChoice - 1 < 0)
				currentChoice = maxChoice - 1;
			else
				currentChoice--;
			refreshPage();
		}
		if(k == KeyEvent.VK_RIGHT){
			if(currentChoice + 1 >= maxChoice)
				currentChoice = 0;
			else
				currentChoice++;
			refreshPage();
		}
		
		// contents only use VK_UP and VK_DOWN
		if(currentChoice != 4 && (k == KeyEvent.VK_UP || k == KeyEvent.VK_DOWN))
			content[currentChoice].KeyPressed(k);
			
	}

	public void keyReleased(int k) {
	}

}
