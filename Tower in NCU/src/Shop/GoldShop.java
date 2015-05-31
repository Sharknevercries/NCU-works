package Shop;

import java.awt.Font;
import java.awt.Graphics2D;

import Applet.Player;

public class GoldShop extends Shop{
	
	private static GoldShop goldShop = new GoldShop();
	private static final String content[] = {"�^�_ 500 �I�ͩR", "���� 4 �I�����O", "���� 4 �I���m�O", "���}"};
	private static boolean display = false;
	
	private Player player;
	
	private GoldShop(){
		super();
		player = Player.getInstance();
	}
	
	public static boolean getDisplay(){	return display;	}
	public static void setDisplay(boolean k){	display = k;	}
	public static GoldShop getInstance(){	return goldShop;	}
	
	public void select(){
		// Default for 0
		int soundType = 0;
		
		switch(currentChoice){
		case 0:	
			if(player.getGold() >= 25)
				player.updateState(player.getHp() + 500, player.getAtk(), player.getDef(), player.getGold() - 25, player.getExp());
			else
				soundType = 1;
			break;
		case 1:
			if(player.getGold() >= 25)
				player.updateState(player.getHp(), player.getAtk() + 4, player.getDef(), player.getGold() - 25, player.getExp());
			else
				soundType = 1;
			break;
		case 2:
			if(player.getGold() >= 25)
				player.updateState(player.getHp(), player.getAtk(), player.getDef() + 4, player.getGold() - 25, player.getExp());
			else
				soundType = 1;
			break;
		case 3:
			soundType = 2;
			display = false;
			break;
		}
		switch(soundType){
		case 0:	audioPlayer.play("confirm");	break;
		case 1:	audioPlayer.play("fail");		break;
		case 2:	audioPlayer.play("cancel");		break;
		}
	}
	
	public void draw(Graphics2D g){
		background.draw(g, 224, 224);
		g.setFont(new Font("�L�n������", Font.PLAIN, 18));
		g.drawString("���� 25 ����", startX + 160, 130);
		choiceBackground.draw(g, 224, 30);
		for(int i = 0; i < content.length; i++){
			g.drawString(content[i], startX + 150, 180 + i * 40);
		}
	}

}
