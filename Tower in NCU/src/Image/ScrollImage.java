package Image;

import java.awt.Graphics2D;
import java.awt.event.KeyEvent;

public class ScrollImage {
	private ImageUnit image;
	private ImageUnit vScrollBackground;
	private ImageUnit vScroll;
	//private ImageUnit hScrollBackground;
	//private ImageUnit hScroll;
	private int windowWidth;
	private int windowHeight;
	
	// relative to the window
	private int currentY;
	private int currentX;
	
	private final int scrollSpeed = 8;
	
	public ScrollImage(String s, int windowWidth, int windowHeight){
		image = new ImageUnit(s);
		
		vScroll = new ImageUnit("/Obj/slidebar.png");
		vScrollBackground = new ImageUnit("/Obj/slidebarBackground.png");
		
		
		this.windowHeight = windowHeight;
		this.windowWidth = windowWidth;
	}
	
	public void initialize(){
		currentX = currentY = 0;
	}
	
	public void KeyPressed(int k){
		if(windowHeight < image.getHeight()){
			if(k == KeyEvent.VK_DOWN){
				if(currentY + windowHeight + scrollSpeed <= image.getHeight())
					currentY += scrollSpeed;
				else
					currentY = image.getHeight() - windowHeight;
			}
			else if(k == KeyEvent.VK_UP){
				if(currentY - scrollSpeed >= 0)
					currentY -= scrollSpeed;
				else
					currentY = 0;
			}
		}
		if(windowWidth < image.getWidth()){
			if(k == KeyEvent.VK_RIGHT){
				if(currentX + windowWidth + scrollSpeed <= image.getWidth())
					currentX += scrollSpeed;
				else
					currentX = image.getWidth() - windowWidth;
			}
			else if(k == KeyEvent.VK_LEFT){
				if(currentX - scrollSpeed >= 0)
					currentX -= scrollSpeed;
				else
					currentX = 0;
			}
		}
	}
	
	public void draw(Graphics2D g, int startX, int startY){
		int w = windowWidth, h = windowHeight;
		if(image.getWidth() <= windowWidth)		w = image.getWidth();
		if(image.getHeight() <= windowHeight)	h = image.getHeight();
		
		
		image.setPosition(startX, startY);
		image.draw(g, currentX, currentY, w, h);
		
		if(h < image.getHeight()){
			vScrollBackground.setPosition(startX + windowWidth - vScrollBackground.getWidth(), startY);
			vScrollBackground.draw(g, vScrollBackground.getWidth(), windowHeight);
 
			int fixY = (int)((double)(currentY / ((double)(image.getHeight() - windowHeight) / 1000)) * ((double)(windowHeight - vScroll.getHeight()) / 1000));
			vScroll.setPosition(startX + windowWidth - vScroll.getWidth(), startY + fixY);
			vScroll.draw(g);
		}
		
		/*
		if(w < image.getWidth()){
			hScrollBackground.setPosition(startX, startY + windowHeight - hScrollBackground.getHeight());
			hScrollBackground.draw(g, windowWidth, hScrollBackground.getHeight());
			
			int fixX = (int)((double)currentX / ((double)(image.getWidth() - windowWidth) / 1000) * ((double)(windowWidth - hScroll.getWidth() / 1000)));
			hScroll.setPosition(startX + fixX, startY + windowHeight - hScroll.getHeight());
			hScroll.draw(g);
		}
		*/
	}
}
