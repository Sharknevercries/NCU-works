package Image;

import java.awt.*;
import java.awt.image.*;
import java.util.ArrayList;

public class BrickObj {
	// image
	private BufferedImage image;
	private ArrayList<BufferedImage> frames;
	private int currentFrame;
	private int type;
	
	// position
	private int x;
	private int y;
	
	// status
	public static final int FLOOR = 0;
	public static final int WALL = 1;
	public static final int UPSTAIR1 = 2;
	public static final int UPSTAIR2 = 3;
	public static final int DOWNSTAIR1 = 4;
	public static final int YELLOWKEY = 5;
	public static final int BLUEKEY = 6;
	public static final int REDKEY = 7;
	public static final int MONSTERBOOK = 8;
	public static final int DOWNSTAIR2 = 9;
	public static final int SMALLPOTION = 10;
	public static final int LARGEPOTION = 11;
	public static final int REDCRYSTAL = 12;
	public static final int BLUECRYSTAL = 13;
	public static final int PICKAXE = 14;
	public static final int YELLOWDOOR = 15;
	public static final int BLUEDOOR = 16;
	public static final int REDDOOR = 17;
	public static final int TELEPORTSTAFF = 18;
	public static final int SWORD1 = 20;
	public static final int SWORD2 = 21;
	public static final int SWORD3 = 22;
	public static final int SWORD4 = 23;
	public static final int SWORD5 = 24;
	public static final int SHIELD1 = 25;
	public static final int SHIELD2 = 26;
	public static final int SHIELD3 = 27;
	public static final int SHIELD4 = 28;
	public static final int SHIELD5 = 29;
	public static final int GOLDSHOP = 40;
	public static final int GOLDSHOPLEFT = 42;
	public static final int GOLDSHOPRIGHT = 43;
	public static final int EXPSHOP = 45;
	
	// monster
	public static final int GREENSLIME = 75;
	public static final int BLUESLIME = 80;
	public static final int REDSLIME = 85;
	public static final int LITTLEBAT = 90;
	public static final int BIGBAT = 95;
	public static final int REDBAT = 100;
	public static final int BLUEWIZZARD = 105;
	public static final int YELLOWWIZZARD = 110;
	public static final int REDWIZZARD = 115;
	public static final int SKELETON = 120;
	public static final int BOSS_TONY = 145;
	
	public BrickObj(BufferedImage image, int type) {
		this.type = type;
		this.image = image;
	}
	
	public BrickObj(ArrayList<BufferedImage> frames, int type){
		this.frames = frames;
		this.type = type;
		currentFrame = 0;
	}
	
	public void setPosition(int x, int y){
		this.x = x;
		this.y = y;
	}
	
	public void draw(Graphics2D g){
		// choose one to display
		if(image != null)
			g.drawImage(image, x, y, null);
		if(frames != null)
			g.drawImage(frames.get(currentFrame / 3), x, y, null);
	}
	
	public void nextFrame(){
		currentFrame++;
		if(currentFrame >= frames.size() * 3)
			currentFrame = 0;
	}
	
	public int getType(){
		return type;
	}
}
