//Load remover and autosplitter for Gemini: Heroes Reborn.
//I used this game to learn this whole ASL coding thing, so this is my first result.
//To do: Splits if Cass dies and checkpoint is not manually reloaded; skips split if manual checkpoint reset is selected but canceled out of; splits rarely on manual checkpoint reset for unknown reasons (maybe value flickering).
//Special thanks to Toxic_TT (twitch.tv/toxic_tt) for mentoring and helping me out with everything.

//Author/contact: Twitter: @CadarevElry, Twitch: twitch.tv/cadarev, Discord: Cadarev#8544
//Version 0.1


state("TravelerGame-Win64-Shipping")
{
		//3 while in a loading screen, 4 during normal gameplay, can flicker to 5 during gameplay and before starting a loading screen
	int loading: 0x022ACE70, 0x10, 0x0;
	
		//counter keeping track of the amount of load prompts (from manual checkpoint resets, quit outs to main menu, and loads from main menu)
	int load_prompts: 0x0231E740, 0x3F8, 0x10, 0x58, 0x20, 0x528;
	
		//has a constant value within each level, then flickers as soon as going into a loading screen
	int level: 0x022AA380, 0x3A0, 0x88;
	
		//in level 1: 8 during intro until control, 10 after gaining control, sometimes flickers to 11, different values for later parts and loading screens
	int start: 0x022BE9F0, 0x0, 0x8;
}

init
{
		//variable to track amount load prompts after last load screen
	vars.prompts_after_load = 0;
}

split
{
	
		//save the amount of load prompts whenever exiting a loading screen to determine if the next load is a level transition or not
	if(current.loading == 4 && old.loading == 3)
	{
		vars.prompts_after_load = current.load_prompts;
	}
	
		//splits if loading screen starts and no additional manual loads have been triggered
		//prevents splits from manual checkpoint resets and level loads from main menu
		//(splits on death reload though, and will skip split if manual reset was pressed but canceled out of)
	if(current.loading == 3 && old.loading != 3 && current.load_prompts == vars.prompts_after_load)
	{
		return true;
	}
}

start
{
		//checks if in first level (462) and gaining first control
	if(current.level == 462 && current.start == 10 && old.start == 8)
	{
		return true;
	}
}

isLoading
{
		//pause timer when in a loading screen
	return current.loading == 3;
}