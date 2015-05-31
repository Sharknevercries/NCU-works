package Applet;

import java.awt.Font;
import java.awt.Graphics2D;

import Audio.AudioPlayer;
import Image.BrickObj;
import Image.ImageUnit;
import Tower.Floor;

public class Battle {
	
	private static Battle battle = new Battle();
	private static boolean display = false;
	
	// pos
	private final static int startX = Floor.startX;
	
	// information
	private ImageUnit background;
	private Player player;
	private Monster monster;
	private Dialogue dialogue;
	private static final String s = "/Obj/dialogueBackground.png";
	
	// data
	private int playerHp;
	private int playerAtk;
	private int playerDef;
	private int playerGold;
	private int playerExp;
	private int monsterHp;
	private int monsterAtk;
	private int monsterDef;
	private int monsterGold;
	private int monsterExp;
	private boolean playerTurn;
	
	// audio
	private AudioPlayer audioPlayer;
	
	// time
	private int maxCount = 6;
	private int count;
	
	private Battle(){
		background = new ImageUnit(s);
		background.setPosition(startX, 130);
		count = 0;
	}
	
	public static boolean getDisplay(){	return display;	}
	public static void setDisplay(boolean k){	display = k;	}
	public static Battle getInstance(){	return battle;	}
	
	public void incMaxCount(){
		if(maxCount + 1 < 8)
			maxCount++;
	}
	
	public void decMaxCount(){
		if(maxCount - 1 >= 1)
			maxCount--;
	}

	public void initialize(Monster monster){
		player = Player.getInstance();
		dialogue = Dialogue.getInstance();
		audioPlayer = AudioPlayer.getInstance();
		this.monster = monster;
		
		playerTurn = true;
		playerHp = player.getHp();
		playerAtk = player.getAtk();
		playerDef = player.getDef();
		playerGold = player.getGold();
		playerExp = player.getExp();
		monsterHp = monster.getHp();
		monsterAtk = monster.getAtk();
		monsterDef = monster.getDef();
		monsterGold = monster.getGold();
		monsterExp = monster.getExp();
		
		count = 0;
	}
	
	public void compute(){
		int damageToPlayer = monsterAtk - playerDef;
		int damageToMonster = playerAtk - monsterDef;
		int type = monster.getType();
		
		if(playerTurn){
			audioPlayer.play("playerAttack");
			if(damageToMonster > 0)
				monsterHp -= damageToMonster;
		}
		else{
			audioPlayer.play("enemyAttack");
			if(type == BrickObj.BLUEWIZZARD || type == BrickObj.YELLOWWIZZARD || type == BrickObj.REDWIZZARD)
				playerHp -= monster.getAtk();
			else if(damageToPlayer > 0)
				playerHp -= damageToPlayer;
		}
		
		playerTurn = !playerTurn;
	}
	
	private void BattleEnd(){
		
		// gameover
		if(playerHp <= 0){
			audioPlayer.stop("bgm");
			player.updateState(playerHp, playerAtk, playerDef, playerGold, playerExp);
			display = false;
		}
		else if(monsterHp <= 0){
			player.updateState(playerHp, playerAtk, playerDef, playerGold + monsterGold, playerExp + monsterExp);
			player.updateFloor(player.getX(), player.getY(), BrickObj.FLOOR);
			dialogue.addDialogue(null, "獲得金幣 " + monsterGold + " 枚和經驗 " + monsterExp + "點", 32, Dialogue.MID, Dialogue.NONE, null);
			audioPlayer.play("eliminate");
			display = false;
		}
		
	}
	
	public void draw(Graphics2D g){
		count++;
		if(count >= maxCount){
			compute();
			count = 0;
		}
		
		background.draw(g, Floor.EDGE * Floor.objSize, 150);
		monster.setPosition(230, 140);
		monster.draw(g);
		
		g.setFont(new Font("微軟正黑體", Font.PLAIN, 18));
		g.drawString("生命", 210, 190);
		g.drawString("攻擊力", 200, 222);
		g.drawString("防禦力", 200, 254);
		
		g.drawString(monsterHp + "", 280, 190);
		g.drawString(monsterAtk + "", 280, 222);
		g.drawString(monsterDef + "", 280, 254);
		
		player.drawPlayerInBattle(g, 460, 140);
		g.drawString("生命", 430, 190);
		g.drawString("攻擊力", 420, 222);
		g.drawString("防禦力", 420, 254);
		
		g.drawString(playerHp + "", 500, 190);
		g.drawString(playerAtk + "", 500, 222);
		g.drawString(playerDef + "", 500, 254);
		
		BattleEnd();
	}
}
