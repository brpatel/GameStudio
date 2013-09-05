package com.adobe.gamebuilder.game.preview
{
	import com.citrusengine.core.CitrusEngine;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.display.NativeWindow;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
//	[SWF(frameRate="60", width="800", height="600", backgroundColor="0x333333")]
	[SWF(frameRate="60")]
	public class Game extends CitrusEngine
	{
	
	
		private var resumeGameInfo:Array;
		private var map:XML;

		public static var parentSprite:DisplayObject;

		
		
		public function Game(levelName:String)
		{
			super();
			
			var dir:File = File.applicationStorageDirectory; 
			dir = dir.resolvePath(levelName); 
			
				
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoader_completeHandler);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			xmlLoader.load(new URLRequest(dir.url));
			
	//		stage.addEventListener(KeyboardEvent.KEY_DOWN , escapehandler);
			this.addEventListener(Event.ADDED_TO_STAGE,addedToStage);
			
		}
		
		protected function addedToStage(event:Event):void
		{
			this.stage.color= 0x000000;
			
		}		
		
		
		public function onError(e:IOErrorEvent):void {
			trace("Reason"+e.text);
		}
		
		
		protected function xmlLoader_completeHandler(event:Event):void
		{
			var nativeApplication:NativeApplication = NativeApplication.nativeApplication;
			var activeWindow:NativeWindow = nativeApplication.activeWindow;
			
			map = new XML(event.target.data);
			state= new GameState(map);
			
		}
		
		public function pauseGame():void{
			this.playing = false;
			
	//		LevelEditor(this.root).showMap();
		}
		
		public function resumeGame():void{
			this.playing = true;
		}
		
		
	
		
		
	}
}