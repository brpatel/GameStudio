package com.adobe.gamebuilder.starter
{
	import com.adobe.gamebuilder.editor.assets.Assets;
	import com.adobe.gamebuilder.editor.core.Constants;
	import com.adobe.gamebuilder.editor.model.vo.GameState;
	import com.adobe.gamebuilder.editor.view.comps.buttons.DesignImageButton;
	import com.adobe.gamebuilder.game.preview.Game;
	import com.adobe.gamebuilder.game.preview.Topbar;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	
	import org.josht.starling.display.Scale9Image;
	import org.josht.starling.display.Sprite;
	import org.josht.starling.textures.Scale9Textures;

	public class PopUp extends Sprite
	{
		private var levelName:String;

	//	private var _citrusEngine:CitrusEngine;

		private var dashBoard:Dashboard;
		
		public function PopUp(levelName:String, dashBoard:Dashboard)
		{
			this.dashBoard = dashBoard;
			this.levelName = levelName;
			
			var _local1:Scale9Textures = new Scale9Textures(Assets.getTextureAtlas("Interface").getTexture("default_btn_bg_black_down"), new Rectangle(2, 2, 30, 30));
			var bg1:Scale9Image = new Scale9Image(_local1);
			bg1.width = Constants.POPUP_WIDTH;
			bg1.height = Constants.POPUP_HEIGHT;
			bg1.alpha = 0;
			addChild(bg1);
			
		/*	var closeIcon:ImageButton = new ImageButton("overlay_close_icon_down", 0, 0);
			closeIcon.x = this.x + this.width - closeIcon.width - 10;;
			closeIcon.y = this.y + 5;
			closeIcon.onRelease.add(removePopUp);
			addChild(closeIcon);*/
			
			var editButton:DesignImageButton = new DesignImageButton("design", 0, 0, true);
			editButton.x = 50;
			editButton.y = 20;
			editButton.width = 130;
			editButton.height = 70;
			editButton.onRelease.add(launchEditor);
			
			var playButton:DesignImageButton = new DesignImageButton("play", 0, 0, true);
			playButton.x = 50;
			playButton.y = editButton.y + editButton.height + 20;
			playButton.width = 130;
			playButton.height = 70;
			playButton.onRelease.add(playGame);
			
			addChild(editButton );
			addChild(playButton);
		}
		
		/*public function get citrusEngine():CitrusEngine
		{
			return _citrusEngine;
		}

		public function set citrusEngine(value:CitrusEngine):void
		{
			_citrusEngine = value;
		}*/

		private function playGame(_arg1:*):void
		{
			this.parent.removeChild(this);
			
			
			//var dir:File = File.applicationDirectory.resolvePath("levels/" + levelName);
			//dir.copyTo(File.applicationStorageDirectory.resolvePath(levelName), true);
			var dir:File = File.applicationStorageDirectory.resolvePath(levelName);
			
	/*		citrusEngine = new CitrusEngine;
			
			citrusEngine.gameData = new MyGameData(dir);
			citrusEngine.levelManager = new LevelManager(GameState);
			citrusEngine.levelManager.onLevelChanged.add(_onLevelChanged);
			citrusEngine.levelManager.levels = citrusEngine.gameData.levels;
			
			var myLoader:URLLoader = new URLLoader();
			myLoader.load(new URLRequest(dir.url));
			myLoader.addEventListener(flash.events.Event.COMPLETE, processXML);
			*/
			GameBuilderApp.game = new Game(levelName);
			GameBuilderApp.game.x = 0;
			GameBuilderApp.game.y = 0;
			GameBuilderApp(Game.parentSprite).addChild(GameBuilderApp.game);
			GameBuilderApp.topBar = new Topbar(GameBuilderApp(Game.parentSprite));
			GameBuilderApp(Game.parentSprite).addChild(GameBuilderApp.topBar);
		}
		
		private function _onLevelChanged(lvl:GameState):void {
	//		citrusEngine.state = lvl;
		}
		
		private function processXML(e:flash.events.Event):void {
			var levelXML:XML = new XML(e.target.data);
		//	citrusEngine.state = new GameState(levelXML);
		}
		
		private function launchEditor(_arg1:DesignImageButton):void
		{
			this.parent.removeChild(this);		
		//	this.dashBoard.onEditor.dispatch(dashBoard);
			this.dashBoard.goToEditor(levelName);
		}
		
		private function removePopUp(_arg1:*):void
		{
			this.parent.removeChild(this);
		}
	}
}