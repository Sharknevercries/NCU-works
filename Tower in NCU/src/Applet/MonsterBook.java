package Applet;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.event.KeyEvent;
import java.util.ArrayList;

import Image.*;
import Tower.*;

public class MonsterBook {
	
	private static MonsterBook monsterBook = new MonsterBook();
	private Tower tower;
	private Player player;
	private static boolean display = false;
	
	// background
	private ImageUnit background;
	
	// image
	private ImageUnit prevArrow;
	private ImageUnit nextArrow;
	
	// pos
	private static final int startX = Floor.startX;
	
	// main
	private final static int pagePerMonster = 5;
	private ArrayList<Monster> monsters;
	private boolean monster[];
	private int maxPage;
	private int currentPage;
	
	private MonsterBook(){
		background = new ImageUnit("/Obj/dialogueBackground.png");
		background.setPosition(Floor.startX, 0);
		prevArrow = new ImageUnit("/Obj/leftArrow.png");
		prevArrow.setPosition(startX + 176, 370);
		nextArrow = new ImageUnit("/Obj/rightArrow.png");
		nextArrow.setPosition(startX + 208, 370);
	}
	
	public static boolean getDisplay(){	return display;	}
	public static void setDisplay(boolean k){	display = k;	}
	public static MonsterBook getInstance(){	return monsterBook;	}
	
	
	
	public void initialize(){
		player = Player.getInstance();
		tower = Tower.getInstance();
		
		int total = (BrickObj.BOSS_TONY - BrickObj.GREENSLIME) / 5 + 1;
		monster = new boolean[total];
		monsters = new ArrayList<Monster>();
		for(int i = 0; i < total; i++)	monster[i] = false;
		for(int row = 0; row < Floor.EDGE; row++){
			for(int col = 0; col < Floor.EDGE; col++){
				int type = tower.getFloor(player.getCurrentFloor()).getType(row, col);
				if(type >= BrickObj.GREENSLIME){
					monster[(type - BrickObj.GREENSLIME) / 5] = true;
				}
			}
		}
		
		for(int i = 0; i < total; i++){
			if(monster[i])
				monsters.add(tower.getFloor(player.getCurrentFloor()).getMonster(i * 5 + BrickObj.GREENSLIME));
		}
		maxPage = (int) Math.ceil((double)monsters.size() / pagePerMonster);
		currentPage = 0;
	}
	
	private String computeBattleResult(Monster monster){
		int type = monster.getType();
		int damageToPlayer = monster.getAtk() - player.getDef();
		int damageToMonster = player.getAtk() - monster.getDef();
		if(damageToMonster <= 0)
			return "INF";
		
		if(type == BrickObj.BLUEWIZZARD || type == BrickObj.YELLOWWIZZARD || type == BrickObj.REDWIZZARD)
			return "" + (((int) Math.ceil((double)monster.getHp() / damageToMonster)) - 1) * monster.getAtk(); 
		if(damageToPlayer <= 0)
			return "0";
		return "" + (((int) Math.ceil((double)monster.getHp() / damageToMonster)) - 1) * damageToPlayer;
	}
	
	public void draw(Graphics2D g){
		background.draw(g, Floor.EDGE * Floor.objSize, Floor.EDGE * Floor.objSize);
		for(int i = 0; i < pagePerMonster; i++){
			int target = currentPage * 5 + i;
			if(target < monsters.size()){
				monsters.get(target).setPosition(startX + 15 , 40 + i * 70);
				monsters.get(target).draw(g);
				g.setFont(new Font("微軟正黑體", Font.PLAIN, 16));
				g.setColor(Color.white);
				g.drawString("生命 : ", startX + 50, 50 + i * 70);
				g.drawString("攻擊力 : ", startX + 170, 50 + i * 70);
				g.drawString("防禦力 : ", startX + 290, 50 + i * 70);
				g.drawString("掉落金幣 : ", startX + 50, 70 + i * 70);
				g.drawString("獲取經驗 : ", startX + 170, 70 + i * 70);
				g.drawString("損失生命 : ", startX + 290, 70 + i * 70);

				g.setColor(Color.yellow);
				g.drawString("" + monsters.get(target).getHp(), startX + 110, 50 + i * 70);
				g.drawString("" + monsters.get(target).getAtk(), startX + 240, 50 + i * 70);
				g.drawString("" + monsters.get(target).getDef(), startX + 360, 50 + i * 70);
				g.drawString("" + monsters.get(target).getGold(), startX + 130, 70 + i * 70);
				g.drawString("" + monsters.get(target).getExp(), startX + 250, 70 + i * 70);
				g.drawString("" + computeBattleResult(monsters.get(target)), startX + 370, 70 + i * 70);
			}
		}
		if(currentPage > 0)	prevArrow.draw(g);
		if(currentPage + 1 < maxPage)	nextArrow.draw(g);
	}

	public void keyPressed(int k) {
		if(k == KeyEvent.VK_ESCAPE || k == KeyEvent.VK_M)
			display = false;
		if(k == KeyEvent.VK_LEFT){
			if(currentPage > 0)
				currentPage--;
		}
		if(k == KeyEvent.VK_RIGHT){
			if(currentPage + 1 != maxPage)
				currentPage++;
		}
	}
	
}
