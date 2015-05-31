package GameState;

import java.awt.Graphics2D;
import java.awt.event.KeyEvent;

import Applet.*;
import Audio.AudioPlayer;
import Shop.*;
import Tower.*;

public class TowerState extends GameState{

	private Tower tower;
	private Player player;
	private Battle battle;
	private GoldShop goldShop;
	private ExpShop expShop;
	private MonsterBook monsterBook;
	private Dialogue dialogue;
	private Event event;
	private AudioPlayer audioPlayer;
	
	public TowerState(GameStateManager gsm){
		this.gsm = gsm;
	}
	
	public void draw(Graphics2D g) {
		
		if(player.getHp() <= 0){
			audioPlayer.stop("bgm");
			gsm.setState(GameStateManager.GAMEOVERSTATE);
		}
		
		tower.getFloor(player.getCurrentFloor()).draw(g);
		event.invokeEvent();
		
		player.draw(g);
		
		if(Battle.getDisplay())
			battle.draw(g);
		else if(dialogue.haveMeesgae())
			dialogue.draw(g);
		else if(GoldShop.getDisplay())
			goldShop.draw(g);
		else if(MonsterBook.getDisplay())
			monsterBook.draw(g);
		else if(ExpShop.getDisplay())
			expShop.draw(g);
		else if(event.isGameover()){
			audioPlayer.stop("bgm");
			gsm.setState(GameStateManager.GAMEENDSTATE);
		}
	}

	public void initialize() {
		tower = Tower.getInstance();
		monsterBook = MonsterBook.getInstance();
		player = Player.getInstance();
		goldShop = GoldShop.getInstance();
		battle = Battle.getInstance();
		dialogue = Dialogue.getInstance();
		event = Event.getInstance();
		audioPlayer = AudioPlayer.getInstance();
		expShop = ExpShop.getInstance();
		
		audioPlayer.playByLoop("bgm");
		player.initialize();
		event.initialize();
		tower.initialize();
	}

	public void keyPressed(int k) {
		if(k == KeyEvent.VK_Z)
			battle.decMaxCount();
		else if(k == KeyEvent.VK_X)
			battle.incMaxCount();
		
		if(player.getHp() <= 0)	return ;
		
		if(k == KeyEvent.VK_T)
			player.updateState(10000, 500, 500, 500, 500);
		
		if(dialogue.haveMeesgae()){
			dialogue.KeyPressed(k);
		}
		else if(GoldShop.getDisplay()){
			goldShop.keyPressed(k);
		}
		else if(ExpShop.getDisplay()){
			expShop.keyPressed(k);
		}
		else if(MonsterBook.getDisplay()){
			monsterBook.keyPressed(k);
		}
		else if(!Battle.getDisplay()){
			if(k == KeyEvent.VK_M){		monsterBook.initialize(); 	MonsterBook.setDisplay(true);	}
			if(k == KeyEvent.VK_LEFT) player.setLeft(true);
			else if(k == KeyEvent.VK_RIGHT) player.setRight(true);
			else if(k == KeyEvent.VK_UP) player.setUp(true);
			else if(k == KeyEvent.VK_DOWN) player.setDown(true);
		}
	}

	public void keyReleased(int k) {
		if(k == KeyEvent.VK_LEFT) player.setLeft(false);
		if(k == KeyEvent.VK_RIGHT) player.setRight(false);
		if(k == KeyEvent.VK_UP) player.setUp(false);
		if(k == KeyEvent.VK_DOWN) player.setDown(false);
		player.setCurrentFrame(3);
	}

}
