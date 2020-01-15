// Tomb Raider: Underworld autosplitter and load remover for Livesplit
// Authors: Original script by FluxMonkii (twitter.com/fluxmonkii), expanded upon by Cadarev (twitter.com/cadarevelry, Discord: Cadarev#8544)
// Thanks for advice and testing: Toxic_TT, rythin_sr, clove, Plastic_Rainbow
// Version 1.0.0 <3

//Steam version
state("tru")
{
	//true when in a loading screen
	bool loading: 0xA7EE48;
	
	//name of the current map
	string32 level: 0xA7F0C0;
	
	//true if not in a cutscene which cannot be interrupted instantly with a crouch input
	bool control: 0x4AA838;
	
	//current amount of entries in the journal
	int journalEntries: 0x00856FDC, 0x6C;
	
	//0 from starting interaction to smash stone plate
	int finalSplit: 0x5FCD78;
	
	//coordinates to make last split on final input possible
	float xCoord: 0x6E4E24;
	float yCoord: 0x6E4E20;
}

//JP version
state("tr8")
{
	bool loading: 0xA199CC;
	string32 level: 0xA19C48;
	bool control: 0x4498B8;
	int journalEntries: 0x007F1B5C, 0x6C;
	int finalSplit: 0x597918;
	float xCoord: 0x67F9A4;
	float yCoord: 0x67F9A0;
}

init
{
}

start
{
	//Starts timer after opening cutscene.
	return (current.level == "L3_main_bedroom" && current.control && !old.control);
}

split
{	
	//Note: Level checks are redundant in some cases but help to identify which split the condition belongs to.
	
	//Prologue (Non-Prologue Skip)
	if(current.level == "l1_seatop" && old.level == "l3_main_hall" && settings["NoIllusions"])
		return true;
	
	//Mediterranean Sea
	if(current.level == "l1_kraken_entrance" && current.control && !old.control && settings["PathToAvalon"])
		return true;
		
	if(current.level == "l1_baldrs_tomb" && current.journalEntries == 4 && old.journalEntries < 4 && settings["Niflheim"])
		return true;
		
	if(current.level == "l1_ship_exterior" && old.level == "l1_cineseatop" && settings["NorseConnection"])
		return true;
		
	if(current.level == "l1_ship_natla_room" && current.journalEntries == 7 && old.journalEntries < 7 && settings["GodOfThunder"])
		return true;
		
	if(current.level == "l2_cliffclimb" && old.level == "l1_cine_ship_sinking" && settings["RealmOfTheDead"])
		return true;
	
	//Thailand	
	if(current.level == "l2_puzzleroom" && current.journalEntries == 9 && old.journalEntries < 9 && settings["Remnants"])
		return true;
	
	if(current.level == "l2_shrineroom" && current.journalEntries == 10 && old.journalEntries < 10 && settings["BhogavatiText"])
		return true;
	
	if(current.level == "l2_maproom" && current.journalEntries == 14 && old.journalEntries < 14 && settings["AncientWorld"])
		return true;
		
	if(current.level == "l3_caverns_start" && old.level == "l2_cliffclimb" && settings["PuppetNoLonger"])
		return true;
		
	//England or Prologue Skip
	if(current.level == "l4_trailstart" && old.level == "l3_mansion_exterior_afterburn" && settings["PrologueSkip"])
		return true;
	
	//Mexico
	if(current.level == "l4_ballcourt" && current.journalEntries == 24 && old.journalEntries < 24 && settings["UnnamedDays"])
		return true;
		
	if(current.level == "l4_ballcourt" && current.journalEntries == 25 && old.journalEntries < 25 && settings["Xibalba"])
		return true;
		
	if(current.level == "l4_pool" && current.journalEntries == 31 && old.journalEntries < 31 && settings["MidgardSerpent"])
		return true;
	
	if(current.level == "l5_startsnow" && old.level == "l4_ballcourt" && settings["LandOfTheDead"])
		return true;
	
	//Jan Mayen
	if(current.level == "l5_valgrind" && current.journalEntries == 36 && old.journalEntries < 36 && settings["GateOfTheDead"])
		return true;
			
	if(current.level == "l6_ship_exterior" && old.level == "l5_valaskjalf" && settings["Valhalla"])
		return true;
	
	//Andaman Sea
	if(current.level == "l7_thin_ice" && old.level == "l6_ship_natla_room" && settings["RitualsOld"])
		return true;
	
	//Arctic Sea
	if(current.level == "l7_helheim01" && current.journalEntries == 43 && old.journalEntries < 43 && settings["Helheim"])
		return true;
		
	if(current.level == "l7_yggdrasil_end" && current.journalEntries == 45 && old.journalEntries < 45 && settings["Yggdrasil"])
		return true;

	if(current.level == "l7_yggdrasil_end" && current.yCoord > -6300 && current.yCoord < -4800 && current.xCoord < -2200 && current.xCoord > -4100 && current.finalSplit == 0 && old.finalSplit != 0 && settings["OutOfTime"])
		return true;
}

isLoading
{
	return current.loading;
}

reset
{
	//Resets as soon as the opening cutscene starts.
	if(current.level == "L3_main_bedroom" && current.journalEntries == 0 && old.control && !current.control)
		return true;
}

startup
{
	settings.Add("Main", true, "Automatically split at the end of (see tooltips for further info):");
	settings.SetToolTip("Main", "If you skip certain chapters, you do not need to untick that option. Only untick an option if you go through that level transition but do not wish to split there.");
	
	settings.Add("Prologue", true, "Prologue", "Main");
	settings.Add("NoIllusions", true, "No Illusions", "Prologue");
	settings.SetToolTip("NoIllusions", "Splits when leaving the level to Medditeranean Sea, also known as No Prologue Skip. The setting for leaving the level to Southern Mexico when using the Prologue Skip is in the England section.");
	
	settings.Add("MediterraneanSea", true, "Mediterranean Sea", "Main");
	settings.Add("PathToAvalon",true, "The Path to Avalon", "MediterraneanSea");
	settings.SetToolTip("PathToAvalon", "Splits after the cutscene when opening the door to Niflheim.");
	settings.Add("Niflheim",true, "Niflheim", "MediterraneanSea");
	settings.SetToolTip("Niflheim", "Splits after the cutscene when entering Baldr's tomb.");
	settings.Add("NorseConnection",true, "The Norse Connection", "MediterraneanSea");
	settings.SetToolTip("NorseConnection", "Splits after the cutscene of Lara approaching the ship.");
	settings.Add("GodOfThunder",true, "God of Thunder", "MediterraneanSea");
	settings.SetToolTip("GodOfThunder", "Splits after the cutscene with Natla.");
	settings.Add("RealmOfTheDead",true, "Realm of the Dead", "MediterraneanSea");
	settings.SetToolTip("RealmOfTheDead", "Splits when leaving the level to Coastal Thailand.");
	
	settings.Add("CoastalThailand",true, "Coastal Thailand", "Main");
	settings.Add("Remnants",true, "Remnants", "CoastalThailand");
	settings.SetToolTip("Remnants", "Splits after the cutscene when entering Bhogavati.");
	settings.Add("BhogavatiText",true, "Bhogavati", "CoastalThailand");
	settings.SetToolTip("BhogavatiText", "Splits after destroying the floor and getting the Ancient World text on screen.");
	settings.Add("AncientWorld",true, "The Ancient World", "CoastalThailand");
	settings.SetToolTip("AncientWorld", "Splits after the cutscene of Thor's gauntlet losing its power when leaving the map room.");
	settings.Add("PuppetNoLonger",true, "Puppet No Longer", "CoastalThailand");
	settings.SetToolTip("PuppetNoLonger", "Splits when leaving the level to England.");
	
	settings.Add("England", true, "England", "Main");
	settings.Add("PrologueSkip", true, "Protected by the Dead (or Prologue Skip)", "England");
	settings.SetToolTip("PrologueSkip", "Splits when leaving the level to Southern Mexico. This can be the case both in the prologue if the Prologue Skip is performed or when playing the entire England level.");
	
	settings.Add("SouthernMexico", true, "Southern Mexico", "Main");
	settings.Add("UnnamedDays", true, "The Unnamed Days", "SouthernMexico");
	settings.SetToolTip("UnnamedDays", "Splits after the cutscene of Lara examining the Mayan calendar.");
	settings.Add("Xibalba", true, "Xibalba", "SouthernMexico");
	settings.SetToolTip("Xibalba", "Splits after the cutscene of Lara entering Xibalba with her motorbike.");
	settings.Add("MidgardSerpent", true, "The Midgard Serpent", "SouthernMexico");
	settings.SetToolTip("MidgardSerpent", "Splits after the cutscene of Lara obtaining Thor's belt.");
	settings.Add("LandOfTheDead", true, "Land of the Dead", "SouthernMexico");
	settings.SetToolTip("LandOfTheDead", "Splits after leaving the level to Jan Mayen.");
	
	settings.Add("JanMayen", true, "Jan Mayen", "Main");
	settings.Add("GateOfTheDead", true, "Gate of the Dead", "JanMayen");
	settings.SetToolTip("GateOfTheDead", "Splits after solving the Tower of the Dead puzzle.");
	settings.Add("Valhalla", true, "Valhalla", "JanMayen");
	settings.SetToolTip("Valhalla", "Splits after leaving the level to Andaman Sea.");
	
	settings.Add("AndamanSea", true, "Andaman Sea", "Main");
	settings.Add("RitualsOld", true, "Rituals Old", "AndamanSea");
	settings.SetToolTip("RitualsOld", "Splits after leaving the level to Arctic Sea.");
	
	settings.Add("ArcticSea", true, "Arctic Sea", "Main");
	settings.Add("Helheim", true, "Helheim", "ArcticSea");
	settings.SetToolTip("Helheim", "Splits after the cutscene of Lara using Mjölnir to open the gate at the end of the room with deadly water.");
	settings.Add("Yggdrasil", true, "Yggdrasil", "ArcticSea");
	settings.SetToolTip("Yggdrasil", "Splits after the cutscene of Lara entering the final battle against Natla.");
	settings.Add("OutOfTime", true, "Out of Time", "ArcticSea");
	settings.SetToolTip("OutOfTime", "Splits on final input, when Lara starts to destroy the last stone plate.");
}
