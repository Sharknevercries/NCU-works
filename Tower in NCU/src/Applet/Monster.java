package Applet;

import java.awt.image.BufferedImage;
import java.util.ArrayList;

import Image.BrickObj;

public class Monster extends BrickObj{
	
	private int hp;
	private int atk;
	private int def;
	private int gold;
	private int exp;
	
	public Monster(ArrayList<BufferedImage> frames, int type) {
		super(frames, type);
		setStatus(type);
	}
	
	private void setStatus(int type){
		switch(type){
		case BrickObj.GREENSLIME:	hp = 30; 	atk = 20;	 def = 5;	  gold = 1; 	exp = 1; 	break;
		case BrickObj.BLUESLIME:	hp = 50; 	atk = 25;	 def = 5;  	  gold = 2; 	exp = 1; 	break;
		case BrickObj.REDSLIME:		hp = 80; 	atk = 30;	 def = 5;	  gold = 3; 	exp = 2; 	break;
		case BrickObj.LITTLEBAT:	hp = 40;	atk = 35;	 def = 20;	  gold = 5;		exp = 2;	break;
		case BrickObj.BIGBAT:		hp = 70;	atk = 80;	 def = 30;	  gold = 7;		exp = 4;	break;
		//case BrickObj.REDBAT:		hp = 200;	atk = 100;	 def = 50;	  gold = 12;	exp = 6;	break;
		case BrickObj.BLUEWIZZARD:	hp = 70;	atk = 15;	 def = 10;	  gold = 4;		exp = 2;	break;
		case BrickObj.YELLOWWIZZARD:hp = 150;	atk = 25;	 def = 25;	  gold = 10;	exp = 3;	break;
		//case BrickObj.REDWIZZARD:
		case BrickObj.SKELETON:		hp = 200;	atk = 100;	 def = 5;	  gold = 7;		exp = 3;	break;
		case BrickObj.BOSS_TONY:	hp = 500;	atk = 130;	 def = 40;	  gold = 20;	exp = 10;	break;
		}
	}
	
	public int getHp() {	return hp;	}
	public int getAtk(){	return atk;	}
	public int getDef(){	return def;	}
	public int getGold(){	return gold;}	
	public int getExp(){	return exp;	}
	
}
