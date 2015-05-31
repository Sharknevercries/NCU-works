package Applet;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.util.ArrayList;

import javax.imageio.ImageIO;

import Audio.AudioPlayer;
import Image.BrickObj;
import Main.GamePanel;
import Shop.*;
import Tower.Floor;
import Tower.Tower;

public class Player{
	private static Player player = new Player();
	private Tower tower;
	
	// image
	private ArrayList<BufferedImage[]> frames;
	private int currentFrame;
	private final static int numRowFrame = 4;
	private final static int numColFrame = 3;
	
	// position
	private int x;
	private int y;
	
	// status
	private BufferedImage[] keys;
	private int numRowStatusUnit;
	private int numColStatusUnit;
	private int hp;
	private int atk;
	private int def;
	private int gold;
	private int exp;
	private int currentFloor;
	private int yellowKey;
	private int blueKey;
	private int redKey;
	
	// move
	private final static int DOWN = 0;
	private final static int LEFT = 1;
	private final static int RIGHT = 2;
	private final static int UP = 3;
	private int finalFace;
	private boolean down;
	private boolean left;
	private boolean right;
	private boolean up;
	private boolean movable;
	
	// dialogue
	private Dialogue dialogue;
	
	// battle
	private Battle battle;
	
	// audio
	private AudioPlayer audioPlayer;
	
	private Player(){
		numRowStatusUnit = GamePanel.HEIGHT / Floor.objSize;
		numColStatusUnit = Floor.startX / Floor.objSize;
		loadStatusImage("/Obj/image.png");
		loadCharacterImage("/Character/Actor1.png");
		
		tower = Tower.getInstance();
		battle = Battle.getInstance();
		dialogue = Dialogue.getInstance();
		audioPlayer = AudioPlayer.getInstance();
		
	}
	
	public void initialize(){
		finalFace = DOWN;
		hp = 1000;
		atk = 10;
		def = 10;
		gold = 0;
		exp = 0;
		yellowKey = 0;
		blueKey = 0;
		redKey = 0;
		currentFloor = 0;
		setCurrentFrame(1);
		x = 6;
		y = 11;
	}
	
	public static Player getInstance(){	return player;	}
	
	private void loadCharacterImage(String s){
		frames = new ArrayList<BufferedImage[]>();
		try{
			BufferedImage character = ImageIO.read(getClass().getResourceAsStream(s));
			for(int row = 0; row < numRowFrame; row++){
				BufferedImage[] tmp = new BufferedImage[numColFrame];
				for(int col = 0; col < numColFrame; col++){
					tmp[col] = character.getSubimage(col * Floor.objSize, row * Floor.objSize, Floor.objSize, Floor.objSize);
				}
				frames.add(tmp);
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
	private void loadStatusImage(String s){
		try{
			BufferedImage tmp = ImageIO.read(getClass().getResourceAsStream(s));
			keys = new BufferedImage[3];
			for(int col = 0; col < 3; col++){
				keys[col] = tmp.getSubimage(col * Floor.objSize, Floor.objSize, Floor.objSize, Floor.objSize);
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public void updateState(int hp, int atk, int def,int gold, int exp){	
		this.hp = hp;	
		this.atk = atk;	
		this.def = def;
		this.gold = gold;
		this.exp = exp;
	}

	private void nextPosEvent(int x, int y){
		String soundKey = null;
		int currentBrickType = tower.getFloor(currentFloor).getType(x, y);
		
		switch(currentBrickType){
		case BrickObj.FLOOR:	break;
		case BrickObj.GOLDSHOPLEFT:
		case BrickObj.GOLDSHOPRIGHT:
		case BrickObj.WALL:		movable = false;	break;
		case BrickObj.UPSTAIR1:
		case BrickObj.UPSTAIR2:		currentFloor++;	break;
		case BrickObj.DOWNSTAIR1:
		case BrickObj.DOWNSTAIR2:	currentFloor--;	break;
		case BrickObj.YELLOWKEY:
			yellowKey++;	updateFloor(x, y, BrickObj.FLOOR);	dialogue.addDialogue(null, "獲得黃鑰匙一把", 32, Dialogue.MID, Dialogue.NONE, null);	soundKey = "getItem";	break;
		case BrickObj.BLUEKEY:
			blueKey++;		updateFloor(x, y, BrickObj.FLOOR);	dialogue.addDialogue(null, "獲得藍鑰匙一把", 32, Dialogue.MID, Dialogue.NONE, null);	soundKey = "getItem";	break;
		case BrickObj.REDKEY:
			redKey++;		updateFloor(x, y, BrickObj.FLOOR);	dialogue.addDialogue(null, "獲得紅鑰匙一把", 32, Dialogue.MID, Dialogue.NONE, null);	soundKey = "getItem";	break;
		case BrickObj.SMALLPOTION:
			hp += 150;		updateFloor(x, y, BrickObj.FLOOR);	dialogue.addDialogue(null, "回復生命 150 點", 32, Dialogue.MID, Dialogue.NONE, null); soundKey = "getItem";	break;
		case BrickObj.LARGEPOTION:
			hp += 500;		updateFloor(x, y, BrickObj.FLOOR);	dialogue.addDialogue(null, "回復生命 500 點", 32, Dialogue.MID, Dialogue.NONE, null); soundKey = "getItem";	break;
		case BrickObj.REDCRYSTAL:
			atk += 2;		updateFloor(x, y, BrickObj.FLOOR);	dialogue.addDialogue(null, "攻擊力提高 2 點", 32, Dialogue.MID, Dialogue.NONE, null);	soundKey = "getItem"; 	break;
		case BrickObj.BLUECRYSTAL:
			def += 2;		updateFloor(x, y, BrickObj.FLOOR);	dialogue.addDialogue(null, "防禦力提高 2 點", 32, Dialogue.MID, Dialogue.NONE, null);	soundKey = "getItem";	break;
		case BrickObj.YELLOWDOOR:
			if(yellowKey > 0){	yellowKey--;	updateFloor(x, y, BrickObj.FLOOR);	soundKey = "door";	}
			else{	movable = false;	}
			break;
		case BrickObj.BLUEDOOR:
			if(blueKey > 0){	blueKey--;	updateFloor(x, y, BrickObj.FLOOR);	soundKey = "door";	}
			else{	movable = false;	}
			break;
		case BrickObj.REDDOOR:
			if(redKey > 0){	redKey--;	updateFloor(x, y, BrickObj.FLOOR);	soundKey = "door";	}
			else{	movable = false;	}
			break;
		case BrickObj.SWORD1:	atk += 10;	updateFloor(x, y, BrickObj.FLOOR);	dialogue.addDialogue(null, "攻擊力提高 10 點", 32, Dialogue.MID, Dialogue.NONE, null); soundKey = "getItem";	break;
		case BrickObj.SWORD2:	break;
		case BrickObj.SWORD3:	break;
		case BrickObj.SWORD4:	break;
		case BrickObj.SWORD5:	break;
		case BrickObj.SHIELD1:	def += 8;	updateFloor(x, y, BrickObj.FLOOR);	dialogue.addDialogue(null, "防禦力 提高 8 點", 32, Dialogue.MID, Dialogue.NONE, null);	 soundKey = "getItem";	break;
		case BrickObj.SHIELD2:	break;
		case BrickObj.SHIELD3:	break;
		case BrickObj.SHIELD4:	break;
		case BrickObj.SHIELD5:	break;
		case BrickObj.GOLDSHOP:		GoldShop.setDisplay(true);	movable = false;	break;
		case BrickObj.EXPSHOP:		ExpShop.setDisplay(true);	movable = false;	break;
		default: // monsters
			battle.initialize(tower.getFloor(currentFloor).getMonster(currentBrickType));
			Battle.setDisplay(true);
			break;
		}
		
		if(soundKey != null){
			audioPlayer.stop(soundKey);
			audioPlayer.play(soundKey);
		}
	}
	
	private void nextPos(){
		movable = true;
		
		if(left){	nextPosEvent(x - 1, y);	}
		else if(right){	nextPosEvent(x + 1, y);	}
		else if(down){	nextPosEvent(x, y + 1);	}
		else if(up){	nextPosEvent(x, y - 1);	}
		
		if(movable){
			if(left)	x--;
			else if(right)	x++;
			else if(down)	y++;
			else if(up)	y--;
			if(left || right || down || up)
				audioPlayer.play("move");
		}
	}
	
	private void drawStatus(Graphics2D g){
		// player status background 
		g.setColor(Color.black);
		for(int row = 0; row < numRowStatusUnit; row++){
			for(int col = 0; col < numColStatusUnit; col++){
				g.fillRect(col * Floor.objSize, row * Floor.objSize, Floor.objSize, Floor.objSize);
			}
		}
		
		// precalculate
		String tmp = currentFloor + 1 + "";
		
		// player status
		g.setColor(Color.white);
		g.setFont(new Font("微軟正黑體", Font.BOLD, 20));
		g.drawString("NCU TOWER", 20, 32);
		g.drawString("第", 32, 64);
		g.drawString(tmp, 77 - tmp.length() * 5, 64);
		g.drawString(" 層", 96, 64);
		g.setFont(new Font("微軟正黑體", Font.BOLD, 16));
		g.drawString("生命", 32, 96);
		g.drawString("" + hp, 96, 96);
		g.drawString("攻擊力", 32, 128);
		g.drawString("" + atk, 96, 128);
		g.drawString("防禦力", 32, 160);
		g.drawString("" + def, 96, 160);
		g.drawString("金幣", 32, 192);
		g.drawString("" + gold, 96, 192);
		g.drawString("經驗", 32, 224);
		g.drawString("" + exp, 96, 224);
		
		// key status
		g.setFont(new Font("微軟正黑體", Font.BOLD, 24));
		g.drawImage(keys[0], 32, 288, null);
		g.drawString("X", 70, 310);
		g.drawString("" + yellowKey, 100, 310);
		g.drawImage(keys[1], 32, 320, null);
		g.drawString("X", 70, 342);
		g.drawString("" + blueKey, 100, 342);
		g.drawImage(keys[2], 32, 352, null);
		g.drawString("X", 70, 374);
		g.drawString("" + redKey, 100, 374);
	}
	
	public void drawPlayerInBattle(Graphics2D g, int x, int y){
		BufferedImage[] tmp = frames.get(DOWN);
		if(currentFrame >= tmp.length * 3)	currentFrame = 0;
		g.drawImage(tmp[(currentFrame++) / 3], x, y, null);
	}
	
	public void draw(Graphics2D g){
		nextPos();
		drawStatus(g);
		
		if(left)	finalFace = LEFT;
		else if(right)	finalFace = RIGHT;
		else if(up)	finalFace = UP;
		else if(down)	finalFace = DOWN;
		
		if(dialogue.haveMeesgae() || Battle.getDisplay())	left = right = down = up = false; // reset
		
		// player in tower
		if(left || down || up || right)
			currentFrame++;
		
		if(currentFrame >= numColFrame * 3)
			currentFrame = 0;
		
		BufferedImage[] tmp = frames.get(finalFace);
		g.drawImage(tmp[currentFrame / 3], Floor.startX + x * Floor.objSize, y * Floor.objSize, null);
		
	}
	
	// general
	public void setLeft(boolean b){	left = b;	}
	public void setRight(boolean b){	right = b;	}
	public void setUp(boolean b){	up = b;	}
	public void setDown(boolean b){	down = b;	}
	public void setCurrentFrame(int k){	currentFrame = k;	}
	public int getCurrentFloor(){	return currentFloor;	}
	public int getHp(){		return hp;	}
	public int getAtk(){	return atk;	}
	public int getDef(){	return def;	}
	public int getGold(){	return gold;	}
	public int getExp(){	return exp;	}
	public int getX(){	return x;	}
	public int getY(){	return y;	}
	public void updateFloor(int x,int y, int type){		tower.getFloor(currentFloor).update(x, y, type);	}
	
}
