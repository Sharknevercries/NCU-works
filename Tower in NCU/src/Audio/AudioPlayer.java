package Audio;

import java.util.HashMap;

public class AudioPlayer {
	
	private static AudioPlayer audioPlayer = new AudioPlayer();
	private HashMap<String, Audio> sounds;
	
	private AudioPlayer(){
		sounds = new HashMap<String, Audio>();
		sounds.put("bgm", new Audio("/Sound/bgm.wav"));
		sounds.put("cancel", new Audio("/Sound/cancel.wav"));
		sounds.put("confirm", new Audio("/Sound/confirm.wav"));
		sounds.put("door", new Audio("/Sound/door.wav"));
		sounds.put("eliminate", new Audio("/Sound/eliminate.wav"));
		sounds.put("enemyAttack", new Audio("/Sound/enemyAttack.wav"));
		sounds.put("fail", new Audio("/Sound/fail.wav"));
		sounds.put("move", new Audio("/Sound/move.wav"));
		sounds.put("changeChoice", new Audio("/Sound/changeChoice.wav"));
		sounds.put("playerAttack", new Audio("/Sound/playerAttack.wav"));
		sounds.put("getItem", new Audio("/Sound/getItem.wav"));
		sounds.put("gameover", new Audio("/Sound/gameover.mid"));
	}
	
	public static AudioPlayer getInstance(){	return audioPlayer;	}
	
	public void play(String s){
		sounds.get(s).play();
	}
	
	public void playByLoop(String s){
		sounds.get(s).loop();
	}
	
	public void stop(String s){
		sounds.get(s).stop();
	}
	
}
