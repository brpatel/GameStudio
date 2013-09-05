package objects
{
	public class Scoreboard
	{
		public static var heartList:Array;
		
		private static var instance:Scoreboard = null;
		
		public function Scoreboard()
		{
			heartList = new Array;
			var i:int = 0;
			heartList[i] = new Heart("Heart" + i++, {x:893, y:55, width:15, height:15});		//starting mid heart
			heartList[i] = new Heart("Heart" + i++, {x:911, y:43, width:15, height:15});		//1st
			heartList[i] = new Heart("Heart" + i++, {x:924, y:31, width:15, height:15});		//2nd
			heartList[i] = new Heart("Heart" + i++, {x:944, y:28, width:15, height:15});		//3rd
			heartList[i] = new Heart("Heart" + i++, {x:965, y:40, width:15, height:15});		//4th
			heartList[i] = new Heart("Heart" + i++, {x:965, y:70, width:15, height:15});		//5th
			heartList[i] = new Heart("Heart" + i++, {x:955, y:93, width:15, height:15});		//6th
			heartList[i] = new Heart("Heart" + i++, {x:938, y:115,width:15, height:15});		//7th
			heartList[i] = new Heart("Heart" + i++, {x:920, y:135,width:15, height:15});		//8th
			
			heartList[i] = new Heart("Heart" + i++, {x:875, y:43, width:15, height:15});		//anti 1st
			heartList[i] = new Heart("Heart" + i++, {x:862, y:31, width:15, height:15});		//anti 2nd
			heartList[i] = new Heart("Heart" + i++, {x:842, y:28, width:15, height:15});		//anti 3rd
			heartList[i] = new Heart("Heart" + i++, {x:821, y:40, width:15, height:15});		//anti 4th
			heartList[i] = new Heart("Heart" + i++, {x:821, y:70, width:15, height:15});		//anti 5th
			heartList[i] = new Heart("Heart" + i++, {x:831, y:93, width:15, height:15});		//anti 6th
			heartList[i] = new Heart("Heart" + i++, {x:848, y:115,width:15, height:15});		//anti 7th
			heartList[i] = new Heart("Heart" + i++, {x:866, y:135,width:15, height:15});		//anti 8th
			heartList[i] = new Heart("Heart" + i++, {x:893, y:150, width:15, height:15});		//ending mid heart
		}
		
		public static function getInstance():Scoreboard{
			if(instance == null)
				instance = new Scoreboard;
			return instance;		
		}
		
		public function removeVisibility():void{
			for each (var heart:Heart in Scoreboard.heartList) 
			{
				if(heart.visible == true)
					heart.visible = false;
			}
		}
	}
}