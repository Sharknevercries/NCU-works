package Applet;

import Image.BrickObj;
import Tower.Tower;


public class Event {
	
	private static Event event = new Event();
	private Dialogue dialogue;
	private Player player;
	private Tower tower;
	
	private final int eventCount = 3; 
	private final static int OPENING = 0;
	private final static int COUNTERTONY1 = 1;
	private final static int COUNTERTONY2 = 2;
	private static boolean gameover;
	private boolean[] displayed;
	
	private Event(){}
	
	public static Event getInstance(){	return event;	}
	
	public void initialize(){
		player = Player.getInstance();
		dialogue = Dialogue.getInstance();
		tower = Tower.getInstance();
		displayed = new boolean[eventCount];
		for(int i = 0; i < displayed.length; i++)
			displayed[i]= false;
		gameover = false;
	}
	
	public void invokeEvent(){
		if(player.getCurrentFloor() == 0 && player.getX() == 6 && player.getY() == 11 && !displayed[OPENING])
			callEvent(OPENING);
		if(player.getCurrentFloor() == 4 && player.getX() == 6 && player.getY() == 3 && !displayed[COUNTERTONY1])
			callEvent(COUNTERTONY1); 
		if(player.getCurrentFloor() == 4 && player.getX() == 6 && player.getY() == 1 && !displayed[COUNTERTONY2]
			&& tower.getFloor(4).getType(6, 1) == BrickObj.FLOOR)
			callEvent(COUNTERTONY2);
	}
	
	public boolean isGameover(){
		return gameover;
	}
	
	private void callEvent(int event){
		switch(event){
		case OPENING:	openingDialogue(); 		displayed[OPENING] = true;		break;
		case COUNTERTONY1: counterTony1();		displayed[COUNTERTONY1] = true;	break;
		case COUNTERTONY2: counterTony2();		displayed[COUNTERTONY2] = true;	break;
		}
	}
	
	private void openingDialogue(){
		dialogue.addDialogue("Keyman", "咦！我不是要到中央大學找 Shark 嗎？", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Keyman", "怎麼會來到這裡？這案情肯定不單純。", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Keyman", "這建築看起來是一座塔，先往上走吧！", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");	
	}
	
	private void counterTony1(){
		// before fight with tony
		dialogue.addDialogue("Keyman", "Tony，居然是你，你怎麼會在這裡？", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Tony", "......，你居然上得來，真叫我驚訝！", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/TonyFace.png");
		dialogue.addDialogue("Keyman", "你在說什麼屁話，你是怎麼進來的？", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Tony", "這是我的塔，而你是我的白老鼠。", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/TonyFace.png");
		dialogue.addDialogue("Keyman", "Tony，你看片看太多，頭腦壞了喔！", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Keyman", "我沒時間理你了，我要趕快離開這座塔，", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Keyman", "然後找到 Shark，把他的遊戲複製過來。", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Tony", "你找不到 Shark了，你也甭想拿到遊戲。", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/TonyFace.png");
		dialogue.addDialogue("Tony", "他已被我軟禁了，你已經沒得尻了！", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/TonyFace.png");
		dialogue.addDialogue("Keyman", "可惡的傢伙，你居然把 Shark教主軟禁，", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Keyman", "做好覺悟吧，我要上了！", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
	}
	
	private void counterTony2(){
		// after fight with tony
		dialogue.addDialogue("Keyman", "可惡，Tony 居然逃走了。", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Keyman", "但不管再打多少次，我都能擊敗他！", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Tony", "這世道哪有那麼事事如意。", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/TonyFace.png");
		dialogue.addDialogue("Tony", "別忘了這只是試完版，別太囂張了！", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/TonyFace.png");
		dialogue.addDialogue("Tony", "要不是在試完版讓你，你能通關嗎？", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/TonyFace.png");
		dialogue.addDialogue("Tony", "想要我放出Shark的話，", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/TonyFace.png");
		dialogue.addDialogue("Tony", "就到完整版來找我吧！", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/TonyFace.png");
		dialogue.addDialogue("Keyman", "居然！那我就沒戲唱了。", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Keyman", "......", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Keyman", "試完版的內容就到此結束了。", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Keyman", "接下來會回到遊戲標題。", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		gameover = true;
	}
	
}
