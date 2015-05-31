package Audio;

import javax.sound.sampled.*;

public class Audio {
	
	private Clip clip;
	
	public Audio(String s){
		try{
			AudioInputStream ais = AudioSystem.getAudioInputStream(getClass().getResource(s));
			clip = AudioSystem.getClip();
			clip.open(ais);
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public void play(){
		if(clip.isRunning())
			stop();
		clip.setFramePosition(0);
		clip.start();
	}
	
	public void loop(){
		clip.loop(Clip.LOOP_CONTINUOUSLY);
	}
	
	public void stop(){
		clip.stop();
	}
	
}