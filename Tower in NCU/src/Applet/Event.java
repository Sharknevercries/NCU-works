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
		dialogue.addDialogue("Keyman", "�x�I�ڤ��O�n�줤���j�ǧ� Shark �ܡH", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Keyman", "���|�Ө�o�̡H�o�ױ��֩w����¡C", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Keyman", "�o�ؿv�ݰ_�ӬO�@�y��A�����W���a�I", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");	
	}
	
	private void counterTony1(){
		// before fight with tony
		dialogue.addDialogue("Keyman", "Tony�A�~�M�O�A�A�A���|�b�o�̡H", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Tony", "......�A�A�~�M�W�o�ӡA�u�s����Y�I", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/TonyFace.png");
		dialogue.addDialogue("Keyman", "�A�b�����򧾸ܡA�A�O���i�Ӫ��H", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Tony", "�o�O�ڪ���A�ӧA�O�ڪ��զѹ��C", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/TonyFace.png");
		dialogue.addDialogue("Keyman", "Tony�A�A�ݤ��ݤӦh�A�Y���a�F��I", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Keyman", "�ڨS�ɶ��z�A�F�A�ڭn�������}�o�y��A", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Keyman", "�M���� Shark�A��L���C���ƻs�L�ӡC", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Tony", "�A�䤣�� Shark�F�A�A�]�ǷQ����C���C", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/TonyFace.png");
		dialogue.addDialogue("Tony", "�L�w�Q�ڳn�T�F�A�A�w�g�S�o�u�F�I", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/TonyFace.png");
		dialogue.addDialogue("Keyman", "�i�c���å�A�A�~�M�� Shark�ХD�n�T�A", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Keyman", "���nı���a�A�ڭn�W�F�I", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
	}
	
	private void counterTony2(){
		// after fight with tony
		dialogue.addDialogue("Keyman", "�i�c�ATony �~�M�k���F�C", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Keyman", "�����ަA���h�֦��A�ڳ������ѥL�I", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Tony", "�o�@�D��������ƨƦp�N�C", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/TonyFace.png");
		dialogue.addDialogue("Tony", "�O�ѤF�o�u�O�է����A�O���۱i�F�I", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/TonyFace.png");
		dialogue.addDialogue("Tony", "�n���O�b�է������A�A�A��q���ܡH", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/TonyFace.png");
		dialogue.addDialogue("Tony", "�Q�n�ک�XShark���ܡA", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/TonyFace.png");
		dialogue.addDialogue("Tony", "�N�짹�㪩�ӧ�ڧa�I", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/TonyFace.png");
		dialogue.addDialogue("Keyman", "�~�M�I���ڴN�S���ۤF�C", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Keyman", "......", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Keyman", "�է��������e�N�즹�����F�C", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		dialogue.addDialogue("Keyman", "���U�ӷ|�^��C�����D�C", 18, Dialogue.DOWN, Dialogue.LEFT, "/Character/KeymanFace.png");
		gameover = true;
	}
	
}
