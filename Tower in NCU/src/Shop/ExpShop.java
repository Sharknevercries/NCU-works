package Shop;

import java.awt.Font;
import java.awt.Graphics2D;

import Applet.Player;

public class ExpShop extends Shop{
	
	private static ExpShop expShop = new ExpShop();
	private static final String content[] = {"提升全體數值 - 50 exp", "提升 4 點攻擊力 - 20 exp", "提升 4 點防禦力 - 20 exp", "離開"};
	private static boolean display = false;
	
	private Player player;
	
	private ExpShop(){
		super();
		player = Player.getInstance();
	}
	
	public static boolean getDisplay(){	return display;	}
	public static void setDisplay(boolean k){	display = k;	}
	public static ExpShop getInstance(){	return expShop;	}
	
	public void select(){
		// Default for 0
		int soundType = 0;
		
		switch(currentChoice){
		case 0:	
			if(player.getExp() >= 50)
				player.updateState(player.getHp() + 200, player.getAtk() + 5, player.getDef() + 5, player.getGold(), player.getExp() - 50);
			else
				soundType = 1;
			break;
		case 1:
			if(player.getExp() >= 20)
				player.updateState(player.getHp(), player.getAtk() + 4, player.getDef(), player.getGold(), player.getExp() - 20);
			else
				soundType = 1;
			break;
		case 2:
			if(player.getExp() >= 20)
				player.updateState(player.getHp(), player.getAtk(), player.getDef() + 4, player.getGold(), player.getExp() - 20);
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
		g.setFont(new Font("微軟正黑體", Font.PLAIN, 18));
		g.drawString("戰鬥經歷不是叫假的", startX + 130, 130);
		choiceBackground.draw(g, 224, 30);
		for(int i = 0; i < content.length; i++){
			g.drawString(content[i], startX + 110, 180 + i * 40);
		}
	}
}

