package Tower;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;

import javax.imageio.ImageIO;

import Applet.Monster;
import Image.BrickObj;
import Main.GamePanel;

public class Floor{
	
	// floor data
	public final static int EDGE = 13;
	private int[][] map;
	
	// common
	public final static int objSize = 32;
	public final static int startX = GamePanel.WIDTH - objSize * EDGE;
	
	// obj set
	private static BufferedImage floorset;
	private static BrickObj[][] floor;
	private static boolean loadObj = false;
	private static int numBrickInRow;
	private static int numBrickInCol;
	
	public Floor(){
		if(!loadObj){
			loadObj("/Obj/image.png");
			loadObj = true;
		}
	}
	
	private void loadObj(String s){
		try{
			floorset = ImageIO.read(getClass().getResourceAsStream(s));
			numBrickInCol = floorset.getWidth() / objSize;
			numBrickInRow = floorset.getHeight() / objSize;
			floor = new BrickObj[numBrickInRow][numBrickInCol];
			BufferedImage subimage;
			for(int row = 0; row < numBrickInRow; row++){
				if(row < 4){ // image
					for(int col = 0; col < numBrickInCol; col++){
						subimage = floorset.getSubimage(col * objSize, row * objSize, objSize, objSize);
						
						int type = row * numBrickInCol + col;
						floor[row][col] = new BrickObj(subimage, type);
					}
				}
				else{ // frame
					int type = row * numBrickInCol;
					int colMax = 0;
					ArrayList<BufferedImage> frames = new ArrayList<BufferedImage>();
					if(row == 8)	colMax = 2;
					if(row == 9 || row == 10)	colMax = 4;
					if(row > 10)	colMax = 4;
					if(row == 29)	colMax = 3;
					
					for(int col = 0; col < colMax; col++){
						subimage = floorset.getSubimage(col * Floor.objSize, row * Floor.objSize, Floor.objSize, Floor.objSize);
						frames.add(subimage);
					}
					floor[row][0] = new Monster(frames, type);
					for(int col = colMax; col < numBrickInCol; col++){
						subimage = floorset.getSubimage(col * objSize, row * objSize, objSize, objSize);
						
						type = row * numBrickInCol + col;
						floor[row][col] = new BrickObj(subimage, type);
					}
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public void loadFloor(String s){
		
		map = new int[EDGE][EDGE];
		try{
			InputStream in = getClass().getResourceAsStream(s);
			BufferedReader br = new BufferedReader(new InputStreamReader(in));
			
			String delims = "\\s+";
			for(int row = 0; row < EDGE; row++){
				String line = br.readLine();
				String[] tokens = line.split(delims);
				for(int col = 0; col < EDGE; col++){
					map[row][col] = Integer.parseInt(tokens[col]);
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}

	public void draw(Graphics2D g) {
		boolean[] record = new boolean[1000];
		for(int i = 0; i < EDGE; i++){
			for(int j = 0; j < EDGE ; j++){
				int row = map[i][j] / numBrickInCol;
				int col = map[i][j] % numBrickInCol;
				// draw floor background 
				floor[0][0].setPosition(startX + j * objSize, i * objSize); 
				floor[0][0].draw(g);
				// draw real texture
				floor[row][col].setPosition(startX + j * objSize, i * objSize);
				floor[row][col].draw(g);
				
				
				if(!record[map[i][j]] && floor[row][col] instanceof Monster)
					floor[row][col].nextFrame();
				record[map[i][j]] = true;
			}
		}
	}
	
	public int getType(int col, int row){
		return map[row][col];
	}
	
	public void update(int col, int row, int type){
		map[row][col] = type;
	}
	
	public Monster getMonster(int type){
		int row = type / numBrickInCol;
		int col = type % numBrickInCol;
		return (Monster)floor[row][col];
	}
	
}
