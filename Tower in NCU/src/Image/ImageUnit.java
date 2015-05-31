package Image;

import java.awt.*;
import java.awt.image.*;

import javax.imageio.ImageIO;

public class ImageUnit {
	private BufferedImage image;
	
	private double x;
	private double y;
	
	private int width;
	private int height;
	
	public ImageUnit(String s){
		try{
			image = ImageIO.read(getClass().getResourceAsStream(s));
			width = image.getWidth();
			height = image.getHeight();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public int getWidth(){	return width;	}
	public int getHeight(){	return height;	}
	
	public void setPosition(double x, double y){
		this.x = x;
		this.y = y;
	}
	
	public void draw(Graphics2D g){
		g.drawImage(image, (int)x, (int)y, null);
	}
	
	public void draw(Graphics2D g, int width, int height){
		g.drawImage(image,(int)x ,(int)y, width, height, null);
	}

	public void draw(Graphics2D g, float op, int x, int y){
		float[] scales = { 1f, 1f, 1f, op };
	    float[] offsets = new float[4];
	    
	    RescaleOp rop = new RescaleOp(scales, offsets, null);
		g.drawImage(image, rop, x, y);
	}
	
	public void draw(Graphics2D g, int imgX, int imgY, int width, int height){
		g.drawImage(image.getSubimage(imgX, imgY, width, height), (int)x, (int)y, null);
	}
	
}
