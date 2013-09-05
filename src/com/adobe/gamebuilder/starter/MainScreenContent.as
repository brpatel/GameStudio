package com.adobe.gamebuilder.starter
{
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import org.josht.starling.display.Sprite;
	import org.josht.starling.foxhole.controls.Button;
	import org.josht.starling.foxhole.core.PopUpManager;
	
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Color;
	
	public class MainScreenContent extends Sprite
	{
		private var directoryList:ArrayCollection = new ArrayCollection;

		private var totalWidth:int = 0;
		
		public function MainScreenContent()
		{
			super();
			this.x = 0;
			this.y = 0;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init():void
		{
			getFileList();
			addFileLabels();
		}
		
		private function addFileLabels():void
		{
			for (var i:int = 0; i < directoryList.length; i++) 
			{
				var levelButton:Button = new Button; 
				var levelText:TextField = new TextField(200,200,File(directoryList[i]).name.substr(0,File(directoryList[i]).name.indexOf('.')),"Verdana",14,Color.WHITE);
				levelButton.width = 200;
				levelButton.height = 200;
				levelButton.x = (this.x + 50)*(i+1) + i*200;
				levelButton.y = this.y + 150;
				levelButton.name = File(directoryList[i]).name.toString();
				levelText.x = levelButton.x;
				levelText.y = levelButton.y/2 + levelButton.height;

				levelButton.onRelease.add(showPopUp);
				this.addChild(levelButton);
				this.addChild(levelText);
			}				
		}
		
		private function showPopUp(_arg1:Button):void
		{
			var popUp:PopUp = new PopUp(_arg1.name);
			PopUpManager.addPopUp(popUp);
			PopUpManager.centerPopUp(popUp);
		}
		
		/*private function triggerSignalOnButtonRelease(button:Button, signal:Signal):void
		{
			const self:MainScreenContent = this;
			button.onRelease.add(function(button:Button):void
			{
				signal.dispatch(self);
			});
		}*/
		
		public function getFileList():void
		{
			if(directoryList != null)
				directoryList.removeAll();
			var count:int = 0;
			var tempObj:Array = File.applicationStorageDirectory.getDirectoryListing();
			for (var i:int = 0; i < tempObj.length; i++) 
			{
				if(!File(tempObj[i]).isDirectory)
				{
					var extension:String = File(tempObj[i]).extension.toString();
					if(extension == "lev" && !directoryList.contains(tempObj[i]))
						directoryList.addItemAt(tempObj[i], count++);
				}
			}			
		}
	}
}