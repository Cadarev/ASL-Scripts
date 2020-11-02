/*
Timelie autosplitter and load remover by Cadarev (Twitter: @CadarevElry, Discord: Cadarev#8544).
Load removal works in general, autosplitting including automated start works only for the main story chapters of v 1.1.0.
Autosplitter only works if realms are played through in order, starting from 1-1 to 5-6, and is not yet available for Hell Loop.
*/

state("Timelie")
{
	int loading					:	"UnityPlayer.dll", 0x017FE048, 0x38;
	int level					:	"UnityPlayer.dll", 0x017BB058, 0xCEC;
}

isLoading
{
	//0 == not loading, 1 == loading
	return (current.loading == 1);
}

start
{
	//When entering 1-1, start the timer.
	if(current.level == 79 && old.level != 79)
	{
		//Get a fresh copy of the original level values list and duplicate levels list.
		vars.orderedLevels = new LinkedList<int>(vars.orderedLevelsClean);
		vars.duplicateLevels = new List<int>(vars.duplicateLevelsClean);
		vars.lastKnownLevel = 79;
		return true;
	}
}

split
{	
	//Level transition during a loading screen
	if(old.level != current.level && current.loading == 1)
	{
		//If the current level value is in the level list, there is a potential split.
		if(vars.orderedLevelsClean.Contains(current.level))
		{			
			//See if two levels prior to the current one, there was a duplicate level. If so, delete it, to maintain correct search behavior in the level list.
			if(vars.duplicateLevels.Contains(vars.orderedLevels.Find(current.level).Previous.Previous.Value))
			{		
				vars.orderedLevels.Remove(vars.orderedLevels.Find(current.level).Previous.Previous);
			}
			
			//Check if the level we were in previously (stored in a separate variable that is manually updated) is the same as in the chronological list of levels.
			if(vars.orderedLevels.Find(current.level).Previous.Value == vars.lastKnownLevel)
			{	
				//Update level variables to allow for a correct check, ignoring flicker values.
				vars.oldLevel = vars.lastKnownLevel;
				vars.lastKnownLevel = current.level;
				
				//Split if that level transition setting is set to true. For levels with duplicate values, the current and old level values have to be concatenated to get the corresponding settings key.
				if((vars.duplicateLevels.Contains(vars.oldLevel) && settings[current.level.ToString() + vars.oldLevel.ToString()]) || settings[vars.oldLevel.ToString()])
				{
					return true;
				}
			}
		}	
	}
	
	//Final split
	if(current.level == 13 && current.loading == 1 && old.loading == 0)
	{
		return true;
	}
}

init
{
	//Chronological order of level values from 1-1 to 5-4 excluding flicker values, but including bridge and hub. -9999 are dummy values outside of the range of possible flicker values.
	int[] levelValues = {-9999, -9999, 79, 38, 39, 82, 83, 4, 96, 28, 111, 96, 108, 140, 74, 91, 88, 124, 4, 103, 28, 10, 78, 93, 85, 7, 174, 53, 52, 101, 180, 93, 87, 78, 111, 97, 4, 102, 28, 91, 57, 65, 90, 4, 119, 28, 128, 105, 84, 117, 4};
	vars.orderedLevelsClean = new LinkedList<int>(levelValues);
	
	//List of duplicate level values that require special treatment to detect splits.
	int[] duplicateLevelValues = {96, 111, 91, 88, 78, 93, 28, 4};
	vars.duplicateLevelsClean = new List<int>(duplicateLevelValues);
	
	//Working copies of the above lists, used (and edited) during the run.
	vars.orderedLevels = new LinkedList<int>(vars.orderedLevelsClean);
	vars.duplicateLevels = new List<int>(vars.duplicateLevelsClean);
	
	//Two variables used to track what levels were transitioned between. This setup is used due to potential flickering which would disrupt the checks due to unused level values.
	vars.lastKnownLevel = 0;
	vars.oldLevel = 0;
}

startup
{
	settings.Add("Levels", true, "Automatically split at the end of:");

	settings.Add("28", true, "Hub", "Levels");
	settings.Add("4", false, "Bridge", "Levels");

	settings.Add("79", true, "1-1", "Levels");
	settings.Add("38", true, "1-2", "Levels");
	settings.Add("39", true, "1-3", "Levels");
	settings.Add("82", true, "1-4", "Levels");
	settings.Add("83", true, "1-5", "Levels");
	settings.Add("2896", false, "1-7", "Levels");

	settings.Add("96111", true, "2-1", "Levels");
	settings.Add("10896", true, "2-2", "Levels");
	settings.Add("108", true, "2-3", "Levels");
	settings.Add("140", true, "2-4", "Levels");
	settings.Add("74", true, "2-5", "Levels");
	settings.Add("8891", true, "2-6", "Levels");
	settings.Add("88", true, "2-7", "Levels");
	settings.Add("124", true, "2-8", "Levels");
	settings.Add("103", false, "2-10", "Levels");

	settings.Add("10", false, "3-1", "Levels");
	settings.Add("9378", true, "3-2", "Levels");
	settings.Add("8593", true, "3-3", "Levels");
	settings.Add("85", false, "3-4", "Levels");
	settings.Add("7", false, "3-5", "Levels");
	settings.Add("174", true, "3-6", "Levels");
	settings.Add("53", true, "3-7", "Levels");
	settings.Add("52", true, "3-8", "Levels");
	settings.Add("101", true, "3-9", "Levels");
	settings.Add("180", true, "3-10", "Levels");
	settings.Add("8793", true, "3-11", "Levels");
	settings.Add("87", true, "3-12", "Levels");
	settings.Add("11178", true, "3-13", "Levels");
	settings.Add("97111", true, "3-14", "Levels");
	settings.Add("97", true, "3-15", "Levels");
	settings.Add("102", false, "3-17", "Levels");

	settings.Add("5791", true, "4-1", "Levels");
	settings.Add("57", true, "4-2", "Levels");
	settings.Add("65", true, "4-3", "Levels");
	settings.Add("90", true, "4-4", "Levels");
	settings.Add("119", false, "4-6", "Levels");

	settings.Add("128", true, "5-1", "Levels");
	settings.Add("105", true, "5-2", "Levels");
	settings.Add("84", true, "5-3", "Levels");
	settings.Add("117", true, "5-4", "Levels");
	//Outro 2-7: 88
	settings.Add("13", true, "5-6", "Levels");
	//True Ending: 73
}