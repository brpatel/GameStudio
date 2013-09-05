package com.adobe.gamebuilder.starter
{
    
    import com.adobe.gamebuilder.editor.core.Constants;
    
    import flash.filesystem.File;
    
    import mx.collections.ArrayCollection;
    
    import org.josht.starling.display.Scale9Image;
    import org.josht.starling.foxhole.controls.Button;
    import org.josht.starling.foxhole.controls.Screen;
    import org.josht.starling.foxhole.core.PopUpManager;
    import org.osflash.signals.Signal;
    
    import starling.display.Image;
    import starling.events.Event;
    import starling.text.TextField;
    import starling.utils.Color;

	public class Dashboard extends Screen
	{
		private static const LABELS:Vector.<String> = new <String>
			[
				"Editor",
				"GamePlay",
				
			];
		
		public function Dashboard()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public var _onEditor:Signal = new Signal(Dashboard);
		
		public function get onEditor():Signal
		{
			return this._onEditor;
		}
		
		private var _onPlayGame:Signal = new Signal(Dashboard);
		
		public function get onPlayGame():Signal
		{
			return this._onPlayGame;
		}
	
		
		private var _buttons:Vector.<Button> = new <Button>[];
		private var _buttonMaxWidth:Number = 0;
		private var _header:HeaderBar;
		private var _footer:FooterBar;
		private var _bg1:Scale9Image;
		public var mainScreen:Main;
		
		// MainScreen
		private var directoryList:ArrayCollection = new ArrayCollection;
		
		private var totalWidth:int = 0;
		private var popUp:PopUp;
		private var _arg1:Button;
		
		override protected function initialize():void
		{
			this.stage.color=0x666666;
			
			const signals:Vector.<Signal> = new <Signal>[this.onEditor, this.onPlayGame];
			const buttonCount:int = LABELS.length;
			/*for(var i:int = 0; i < buttonCount; i++)
			{
				var label:String = LABELS[i];
				var signal:Signal = signals[i];
				var button:Button = new Button();
				button.label = label;
				this.triggerSignalOnButtonRelease(button, signal);
				this.addChild(button);
				this._buttons.push(button);
				button.validate();
				this._buttonMaxWidth = Math.max(this._buttonMaxWidth, button.width);
			}
			*/
			this._header = new HeaderBar();
			this._footer = new FooterBar();
			
			
			
			this.addChild(this._header);
			this.addChild(this._footer);
	//		var mainScreenContent:MainScreenContent = new MainScreenContent;
	//		this.addChild(mainScreenContent);

			
		}
		
		public function init():void
		{
			copyFiles();
			getFileList();
			addFileLabels();
		}
		
		private function copyFiles():void
		{
			// Copy .lev files
			var _local1:File = File.applicationDirectory.resolvePath("resource/My FarmVille  [Shared by Guriya].lev")
			_local1.copyTo(File.applicationStorageDirectory.resolvePath("My FarmVille  [Shared by Guriya].lev"), true);
			
			var _local2:File = File.applicationDirectory.resolvePath("resource/Popeye  [Shared by Guriya].lev")
			_local2.copyTo(File.applicationStorageDirectory.resolvePath("Popeye  [Shared by Guriya].lev"), true);
		}
		
		private function addFileLabels():void
		{
			var damn:String;
			for (var i:int = 0; i < directoryList.length; i++) 
			{
				var levelButton:Button = new Button();
				if(i < 4)
					damn = "level"+ (i + 1);
				else
					damn = "temp";
				
				var img:Image = new Image(myAssets.getTexture(damn));
				img.width = 250
				img.height = 200;
				levelButton.defaultIcon = img;
				var levelText:TextField;
				if(i==2){
					levelText = new TextField(250,40,"Angry Birds","Verdana",14,Color.WHITE);;
				}else if(i==3){
					levelText = new TextField(250,40,"Dussehra","Verdana",14,Color.WHITE);;
				}else{
				
				levelText = new TextField(250,40,File(directoryList[i]).name.substr(0,File(directoryList[i]).name.indexOf('.')),"Verdana",14,Color.WHITE);;
			
				}
				levelButton.width = 250;
				levelButton.height = 200;
				if(i < 4)
				{
					levelButton.x = (this.x + 50)*(i+1) + i*250;
					levelButton.y = this.y + 100;
				}
				else
				{
					levelButton.x = (this.x + 50)*(i-3) + (i-4)*250;
					levelButton.y = this.y + 150 + 250;
				}
				levelButton.name = File(directoryList[i]).name.toString();
				levelText.x = levelButton.x;
				levelText.y = levelButton.y + levelButton.height;
				
				levelButton.onRelease.add(showPopUp);
				this.addChild(levelButton);
				this.addChild(levelText);
			}				
		}

		
		private function showPopUp(_arg1:Button):void
		{
			if(popUp != null)
			{
				this._arg1.alpha = 1;
				removeChild(popUp);
			}
			this._arg1 = _arg1;
			popUp = new PopUp(_arg1.name,this);
			popUp.x = _arg1.x;
			popUp.y = _arg1.y + 10;
			popUp.width = _arg1.width;
			popUp.height = _arg1.height;
			
			_arg1.alpha = 0.5;
			addChild(popUp);
		//	PopUpManager.centerPopUp(popUp);
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
		
		
		override protected function draw():void
		{
			const margin:Number = this.originalHeight * 0.06 * this.dpiScale;
			const spacingX:Number = this.originalHeight * 0.03 * this.dpiScale;
			const spacingY:Number = this.originalHeight * 0.03 * this.dpiScale;
			
			this._header.width = this.actualWidth;
			this._footer.width = this.actualWidth;
			this._footer.y = this.actualHeight - Constants.TOPBAR_HEIGHT;
			
			const contentMaxWidth:Number = this.actualWidth - 2 * margin;
			const buttonCount:int = this._buttons.length;
			var horizontalButtonCount:int = 1;
			var horizontalButtonCombinedWidth:Number = this._buttonMaxWidth;
			while((horizontalButtonCombinedWidth + this._buttonMaxWidth + spacingX) <= contentMaxWidth)
			{
				horizontalButtonCombinedWidth += this._buttonMaxWidth + spacingX;
				horizontalButtonCount++;
				if(horizontalButtonCount == buttonCount)
				{
					break;
				}
			}
			
			const startX:Number = (this.actualWidth - horizontalButtonCombinedWidth) / 2;
			var positionX:Number = startX;
			var positionY:Number = this._header.y + this._header.height + spacingY;
			for(var i:int = 0; i < buttonCount; i++)
			{
				var button:Button = this._buttons[i];
				button.width = this._buttonMaxWidth;
				button.x = positionX;
				button.y = positionY;
				positionX += this._buttonMaxWidth + spacingX;
				if(positionX + this._buttonMaxWidth > margin + contentMaxWidth)
				{
					positionX = startX;
					positionY += button.height + spacingY;
				}
			}
		}
		
		private function triggerSignalOnButtonRelease(button:Button, signal:Signal):void
		{
			const self:Dashboard = this;
			button.onRelease.add(function(button:Button):void
			{
				signal.dispatch(self);
			});
		}
		
		public function goToEditor(levelName:String = null){
			if(mainScreen!=null ){
				mainScreen.currentLevelName= levelName;
			}
			onEditor.dispatch(this);
		}


    }
}//package at.polypex.badplaner
