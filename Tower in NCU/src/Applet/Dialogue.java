package Applet;

import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.event.KeyEvent;
import java.util.ArrayList;

import Image.ImageUnit;
import Tower.Floor;

public class Dialogue {
	
	private static Dialogue dialogue = new Dialogue();
	private ArrayList<Dialogue> dialogues;
	
	private final static int startX = Floor.startX;
	
	private ImageUnit background;
	private ImageUnit faceImage;
	
	private int location;
	private int face;
	private String nameTitle;
	private String msg;
	private int fontSize;
	
	// location type
	public static final int LEFT = 0;
	public static final int RIGHT = 1;
	public static final int NONE = 2;
	
	// face type
	public static final int UP = 0;
	public static final int MID = 1;
	public static final int DOWN = 2;
	
	private Dialogue(){
		dialogues = new ArrayList<Dialogue>();
	}
	
	public static Dialogue getInstance(){	return dialogue;	}
	public boolean haveMeesgae(){	return dialogues.size() > 0;	}
	
	public void addDialogue(String nameTitle, String msg, int fontSize, int location, int face, String facePath){
		Dialogue tmp = new Dialogue();
		tmp.setBackground(location);
		if(facePath != null)
			tmp.setFaceImage(facePath, face);
		else
			tmp.setFaceImage(null, face);	
		tmp.setFontSize(fontSize);
		tmp.setMessage(msg);
		tmp.setNameTitle(nameTitle);
		
		dialogues.add(tmp);
	}
	
	private void setBackground(int location){
		background = new ImageUnit("/Obj/dialogueBackground.png");	//	locked
		this.location = location;
	}
	
	private void setFaceImage(String s, int face){
		this.face = face;
		if(face != NONE)
			faceImage = new ImageUnit(s);
		else
			faceImage = null;
	}
	
	private void setNameTitle(String nameTitle){
		this.nameTitle = nameTitle;
	}
	
	private void setMessage(String msg){
		this.msg = msg;
	}
	
	private void setFontSize(int fontSize){
		this.fontSize = fontSize;
	}
	
	private void show(Graphics2D g){
		int startY = 0;
		int xFix = 0;
		
		if(location == UP){		startY = 0;	}
		if(location == MID){	startY = 160;	}
		if(location == DOWN){	startY = 320;	}
		background.setPosition(startX, startY);
		background.draw(g);
		
		if(face == LEFT){
			xFix = 96;
			faceImage.setPosition(startX, startY);
		}
		if(face == RIGHT){
			faceImage.setPosition(startX, startY);
		}
		if(face == NONE){
			xFix = 10;
		}
		
		if(nameTitle != null){
			g.setFont(new Font("微軟正黑體", Font.PLAIN, 24));
			g.drawString(nameTitle, startX + xFix, startY + 30);
		}
		
		// not at the middle pos
		g.setFont(new Font("微軟正黑體", Font.PLAIN, fontSize));
		g.drawString(msg, startX + xFix, startY + 60);
		
		if(face != NONE)
			faceImage.draw(g);
		
	}
	
	public void KeyPressed(int k){
		if(k == KeyEvent.VK_ENTER){
			dialogues.remove(0);
		}
	}
	
	public void draw(Graphics2D g){
		dialogues.get(0).show(g);
	}
}
