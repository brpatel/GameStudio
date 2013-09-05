package
{
	import com.adobe.gamebuilder.editor.GameEditor;
	import com.adobe.gamebuilder.editor.assets.Embeds;
	import com.adobe.gamebuilder.editor.core.Constants;
	import com.adobe.gamebuilder.editor.core.manager.DBManager;
	import com.adobe.gamebuilder.editor.view.manager.ProductManager;
	import com.adobe.gamebuilder.game.data.StateQueue;
	import com.adobe.gamebuilder.game.preview.Game;
	import com.adobe.gamebuilder.game.preview.OverlayInstance;
	import com.adobe.gamebuilder.game.preview.Topbar;
	import com.adobe.gamebuilder.starter.Main;
	import com.citrusengine.core.CitrusObject;
	import com.citrusengine.core.SoundManager;
	import com.citrusengine.objects.platformer.box2d.Ball;
	import com.citrusengine.physics.Box2D;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import Box2DAS.Dynamics.b2Body;
	
	import locale._CompiledResourceBundleInfo;
	
	import starling.core.Starling;
	
	[SWF(frameRate="60")]
	public class GameBuilderApp extends Sprite
	{
		public static var STARLING_READY:Boolean = false;
		
		private var _starling:Starling;
		public static var game:Game;
		public static var topBar:Topbar;
		public static var editor:GameEditor;
		public static var productManager:ProductManager;
		private var ghostSprite:Sprite;
		
		public static var currentApp:GameBuilderApp;
		
		public function GameBuilderApp()
		{
			if (this.stage)
			{
				this.stage.scaleMode = StageScaleMode.NO_SCALE;
				this.stage.align = StageAlign.TOP_LEFT;
			};
			this.loaderInfo.addEventListener(Event.COMPLETE, this.loaderInfo_completeHandler, false, 0, true);
			this.addEventListener(Event.ADDED_TO_STAGE,addedToStage);
			
			// hack to call replayFrame method
			currentApp = this;
		}
		
		protected function addedToStage(event:Event):void
		{
	//		game = new Game();
	//		addChild(game);
			Game.parentSprite = this;
		}
		
		private function loaderInfo_completeHandler(_arg1:Event):void
		{
			// Temporary added to load properties files
			trace(_CompiledResourceBundleInfo.compiledLocales);
			new en_US$collections_properties();
			new en_US$core_properties;
			new en_US$iLabels_properties;
			new en_US$logging_properties;
			new en_US$messaging_properties;
			new en_US$rpc_properties;
			new en_US$styles_properties;
			new en_US$validators_properties;
			
			//
			
			var startupBitmap:Bitmap;
			var event:Event = _arg1;
			Starling.multitouchEnabled = true;
			Starling.handleLostContext = true;
			var viewPort:Rectangle = new Rectangle(0, 0, this.stage.stageWidth, this.stage.stageHeight);
		//	this._starling = new Starling(GameEditor, this.stage, viewPort);
			this._starling = new Starling(Main, this.stage, viewPort);
			this._starling.enableErrorChecking = false;
			if (Constants.DEV_TEST)
			{
				this._starling.showStats = true;
				this._starling.showStatsAt("right", "bottom");
				this._starling.simulateMultitouch = true;
			};
			startupBitmap = new Embeds.LoadingScreen();
			startupBitmap.x = int(((stage.stageWidth - startupBitmap.width) >> 1));
			startupBitmap.y = int(((stage.stageHeight - startupBitmap.height) >> 1));
			addChild(startupBitmap);
			DBManager.init(null);
			
			
			this._starling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, function (_arg1:Event):void
			{
				removeChild(startupBitmap);
				_starling.start();
		//		(Starling.current.root as IGameEditor).initApp();
			});
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, function (_arg1:Event):void
			{
				_starling.start();
			});
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, function (_arg1:Event):void
			{
				_starling.stop();
			});
		}
		
		public function startGame():void{
			
			/*if(game ==null){
				game = new Game();
			}else{
				removeChild(game);
				game = new Game();
			}*/
			
			game.x=300;
			game.y =100;
			addChildAt(game,this.numChildren-1);
			
		}
		
		public function removeGameElements():void{
			
			SoundManager.getInstance().stopSound("ramayan");
			editor.touchable = true;
			editor._topBar.visible = true;
			editor._actionBar.visible = true;
			this.removeChild(game);
			hideGhost();
			
		}
		
		public function pauseGame():void{
			game.pauseGame();
			game.state.isReplayMode = true;
			
			var stateQueue:StateQueue = StateQueue.getInstance();
			topBar.showTimelineControls();
			topBar.sliderButton.maximum = stateQueue.currentFrame;
			topBar.sliderButton.value= topBar.sliderButton.maximum;
			
//			editor._topBar.visible = true;
			editor.touchable = true;
			game.visible = false;
			
			// Set all map objects to their respective position as the game
			for (var i:int = 0; i < stateQueue.objectsState.length; i++) 
			{
				var statArray:Array = stateQueue.getFirstFrameforObject(i);
				if(statArray!=null){
				//	productManager.getProductObjectByID(
					productManager.getItemAt(i).x = statArray[0];
					productManager.getItemAt(i).y = statArray[1];
					
					/*this.map.mapObjectsHolder.getChildAt(2*i).x = statArray[0];
					this.map.mapObjectsHolder.getChildAt(2*i).y = statArray[1];
					this.map.mapObjectsHolder.getChildAt(2*i + 1).x = statArray[0];
					this.map.mapObjectsHolder.getChildAt(2*i +1).y = statArray[1];*/
				}
			}
			
			
			
		}
		
		public function resumeGame():void{
			editor.touchable = false;
			game.visible = true;
			game.resumeGame();
			game.state.isReplayMode = false;
		}
		
		public function getFrame(frameNum:Number):void
		{
			var stateQueue:StateQueue = StateQueue.getInstance();
			
			
			for (var i:int = 0; i < stateQueue.objectsState.length; i++) 
			{
				var statArray:Array = stateQueue.getFrameValueforObject(i,frameNum);
				
				if(statArray!=null){
					/*this.map.mapObjectsHolder.getChildAt(2*i).x = statArray[0];
					this.map.mapObjectsHolder.getChildAt(2*i).y = statArray[1];
					this.map.mapObjectsHolder.getChildAt(2*i + 1).x = statArray[0];
					this.map.mapObjectsHolder.getChildAt(2*i +1).y = statArray[1];*/
					productManager.getItemAt(i).x = statArray[0];
					productManager.getItemAt(i).y = statArray[1];
				}
			}
			
		}
		
		public static function frameReRun(updates:Array = null):void{
			
			currentApp.replayFrames(updates);
		}
		
		public function replayFrames(updates:Array = null):void
		{
			
			var stateQueue:StateQueue = StateQueue.getInstance();
			var gameObjects:Vector.<CitrusObject> = game.state.getAllObjects();
			
			// Set the objects to their initial position (1st frame)			
			for (var i:int = 0; i < gameObjects.length; i++) 
			{
				if(!(gameObjects[i] is Box2D)){
					var statArray:Array = stateQueue.getLastFrameforObject(i-1);
					if( statArray!=null && gameObjects[i]!=null ){
						
						
						gameObjects[i].x = statArray[0];
						gameObjects[i].y = statArray[1];	
						
						if(gameObjects[i] is Ball){
							//make pigs dynamic
							Ball(gameObjects[i]).body.SetType(b2Body.b2_staticBody);
							
						}
						
						if(updates!=null){
							
							for (var k:int = 0; k < updates.length; k++) 
							{
								if(gameObjects[i].name == updates[k].objectInstance.name){ //gameObjects[i] is updates[k].objectInstance.className &&	
									
									gameObjects[i][updates[k].property] = updates[k].value;
								}
							}
							
							
						}
						
					}
				}
			}
			
			stateQueue.resetQueue();
			
			// unpause the game
			game.playing = true;
			game.state.isReplayMode = true;
			var eventFrame:Array = null;
			
			// Update the objects for the duration 
			for (var j:int = 0; j < StateQueue.MAX_FRAMES; j++) 
			{
				//Call update on all objects
				var garbage:Array = [];
				var n:Number = gameObjects.length;
				
				if(stateQueue.objectsState.length == 0){
					
					stateQueue.setNoOfObjects(n-1);
					stateQueue.currentFrame =-1;
				}
				
				stateQueue.incrementFrameNumber();
				
				
				//var currentEventIndex:int=0;
				for (i= 0; i < n; i++)
				{
					var object:Object = gameObjects[i];
					if (object.kill){
						garbage.push(object);
					}else{
						if(i>0){
							
							if(eventFrame == null){
								eventFrame = stateQueue.getEventForFrame();
							}
							
							if(eventFrame!=null && j >= eventFrame[0] && (i-1) == eventFrame[1]){
								
								var objectArt:DisplayObject = game.state.view.getArt(object) as DisplayObject;
								if(objectArt != null){
									if(eventFrame[2] == 1)
										objectArt.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN,true,false,eventFrame[3],eventFrame[4]));//   .addEventListener(MouseEvent.MOUSE_DOWN, handleGrab );
									else if(eventFrame[2] == 2)
										game.stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP,true,false,eventFrame[3],eventFrame[4]));//   .addEventListener(MouseEvent.MOUSE_DOWN, handleGrab );
									else if(eventFrame[2] == 3)
										game.stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE,true,false,eventFrame[3],eventFrame[4]));//   .addEventListener(MouseEvent.MOUSE_DOWN, handleGrab );
									
								}
								
								// make event frame null for fetching next event
								eventFrame = null;
							}
							
							
						}
						object.update(0.17);
					}
					if(i>0){
						stateQueue.setFrameValueforObject(i-1,object.x, object.y);
						
					}
				}
				
				
				
				//Update the state's view
				game.state.view.update();
				
			
			}
			topBar.sliderButton.maximum = stateQueue.currentFrame;
			
			if(topBar.showTimeline)
				redrawGhost();
			
	}

		
		public function redrawGhost():void{
			//Re-draw the ghosts
			
			// Remove children from previous ghost sprite if  ghost already drawn
			if(ghostSprite !=null){
				if(this.getChildByName(ghostSprite.name))
					this.removeChild(ghostSprite);
				ghostSprite.removeChildren();
				
			}else{
				
				ghostSprite = new Sprite();
				ghostSprite.name = "ghostSprite";
			}
			var stateQueue:StateQueue = StateQueue.getInstance();
			
			// Draw ghosts
			for (var j:int = 0; j < StateQueue.MAX_FRAMES ; j++) 
			{
				try
				{
					var objectArray:Array = stateQueue.getFrameValueforObject(1,j);
					var ghost:OverlayInstance =  new OverlayInstance();
					ghost.view = 	productManager.getItemAt(1).getView();// OverlayInstance(this.map.mapObjectsHolder.getChildAt(3)).view;
					ghost.x = objectArray[0];
					ghost.y = objectArray[1];
					ghost.alpha = 0.2;
					ghostSprite.addChild(ghost);
				} 
				catch(error:Error) 
				{
					trace("Show Map ghost drawing error!"); 
				}
				
			}
			ghostSprite.x = 0;
			ghostSprite.y = 0;
			
			//			this.swapChildren(this.map, this.game);
			this.addChild(ghostSprite);
		}
		
		public function hideGhost():void
		{
			if(ghostSprite !=null){
				if(this.getChildByName(ghostSprite.name))
					this.removeChild(ghostSprite);
				ghostSprite.removeChildren();
				
			}
			
		}
		
		
	}
}