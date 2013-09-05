package com.adobe.gamebuilder.game.preview
{	
	import com.adobe.gamebuilder.game.data.StateQueue;
	import com.citrusengine.core.CitrusObject;
	import com.citrusengine.core.SoundManager;
	import com.citrusengine.core.State;
	import com.citrusengine.objects.CitrusSprite;
	import com.citrusengine.objects.platformer.box2d.Ball;
	import com.citrusengine.objects.platformer.box2d.Cloud;
	import com.citrusengine.objects.platformer.box2d.Crate;
	import com.citrusengine.objects.platformer.box2d.Platform;
	import com.citrusengine.physics.Box2D;
	import com.citrusengine.utils.ObjectMaker;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import objects.Bluto;
	import objects.Olive;
	import objects.Popeye;
	import objects.Ravana;
	import objects.RavanaHead;
	
	import starling.core.Starling;
	import starling.extensions.particles.PDParticleSystem;
	import starling.extensions.particles.ParticleDesignerPS;
	import starling.textures.Texture;
	
	public class GameState extends State
	{
		
		private var _level:XML;
		private var cameraSet:Boolean = false;
		private var objects:Vector.<CitrusObject> = new Vector.<CitrusObject>();

		private var usedObject:Array;
	
		private var stateQueue :StateQueue;

		private var clickedObject:CitrusObject;
		private var frameNum:int=-1;
		private var isMouseDown:Boolean;
		[Embed(source="../../../../../resource/ramayanaAssets/Particle.pex", mimeType="application/octet-stream")]
		private var _particleConfig:Class;
		
		[Embed(source="../../../../../resource/ramayanaAssets/ParticleTexture.png")]
		private var _particlePng:Class;
		
		public static var particles:PDParticleSystem;
		private var ravana:Ravana;
		
		public function GameState(level:XML)
		{
			
			super();
			this.level = level;
			
						
			usedObject = [Platform, Crate, CitrusSprite, Cloud, Ball, Popeye, Bluto, Olive, Ravana, RavanaHead];
			stateQueue = StateQueue.getInstance();
		}
		
		
		
	
		public function get level():XML
		{
			return _level;
		}
		
		public function set level(value:XML):void
		{
			_level = value;
		}
		
		
		
		override public function initialize():void
		{
			super.initialize();
			
			var box2D:Box2D = new Box2D("Box2D");
			add(box2D);
			box2D.visible = false;
			
			if(level)
				ObjectMaker.FromLevelArchitect(level);
			
			particles = new ParticleDesignerPS(XML(new _particleConfig()), Texture.fromBitmap(new _particlePng()));
			Starling.juggler.add(particles);
//			this.addChild(GameState.particles as starling.display.DisplayObject);
			
			SoundManager.getInstance().addSound("ramayan", "resource\\ramayanaAssets\\RaghupatiRahgav_Instrumental.mp3");
			ravana = Ravana(getFirstObjectByType(Ravana));
			
			if(ravana!=null)
				SoundManager.getInstance().playSound("ramayan",1,1);

			
			configureDisplayEvents();
			
						
		}
		
		private function configureDisplayEvents():void
		{
			var _ballObjects:Vector.<CitrusObject> = getObjectsByType(Ball);
			
		//	for each (var citrusObject:int in _ballObjects) 
			for (var i:int = 0; i < _ballObjects.length; i++) 
			{
				var objectArt:DisplayObject = view.getArt(_ballObjects[i]) as DisplayObject;
				objectArt.addEventListener(MouseEvent.MOUSE_DOWN, handleGrab );
			}
			
			
			
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, handleRelease);
			
		}
		
		
		
		override public function update(timeDelta:Number):void
		{
			if(!isReplayMode){
		//		trace("timeDelta: "+timeDelta);
				super.update(timeDelta);
				
				frameNum++;
				
				if(stateQueue.objectsState.length == 0){
					
					stateQueue.setNoOfObjects(getObjectCount()-1);
					stateQueue.currentFrame =-1;
				}
					
				stateQueue.incrementFrameNumber();
				objects = getAllObjects();
				
				for (var j:int = 1; j < getObjectCount(); j++) 
				{
					stateQueue.setFrameValueforObject(j-1,objects[j].x, objects[j].y);
				}
			}
			
			
			/*if(objects.length == 0){
				for (var i:int = 0; i < usedObject.length; i++) 
				{
					objects = objects.concat(getObjectsByType(usedObject[i]));
				}
				stateQueue.setNoOfObjects(objects.length);
				stateQueue.currentFrame =0;
				
			}else{
			//	trace("Objects length: "+objects.length);
				
				stateQueue.incrementFrameNumber();
				for (var j:int = 0; j < objects.length; j++) 
				{
					stateQueue.setFrameValueforObject(j,objects[j].x, objects[j].y);
				}
				
			}*/
			
			
		}
		
		private function handleGrab(e:MouseEvent):void
		{
			
//			trace("Mouse Down: "+e.localX +","+e.localY);
			isMouseDown = true;
			if(!isReplayMode){
				stateQueue.setEventForObject(frameNum,1,1,e.localX, e.localY);
			}else{
			//	e.stopPropagation();
			}
			
			clickedObject = view.getObjectFromArt(e.currentTarget) as CitrusObject;
			if (clickedObject!=null){
				Ball(clickedObject).enableHolding(e.currentTarget.parent,e.stageX, e.stageY);
				
				
			}
		}
		
		private function handleRelease(e:MouseEvent):void
		{
			isMouseDown = false;
			if(clickedObject!=null){
//				trace("Mouse Up: "+e.stageX +","+e.stageY);
				if(!isReplayMode){
					stateQueue.setEventForObject(frameNum,1,2,e.stageX, e.stageY);
				}else{
				//	e.stopPropagation();
				}
				
				Ball(clickedObject).disableHolding(DisplayObject(e.currentTarget),e.stageX,e.stageY);
				clickedObject = null;
			}
		}
		
		protected function handleMove(e:MouseEvent):void
		{
		
			// Only check when mouse is down
			if(isMouseDown){
				
				if(clickedObject!=null){
//					trace ("Mouse Move: "+e.stageX+","+e.stageY);
					if(!isReplayMode){
						stateQueue.setEventForObject(frameNum,1,3,e.stageX, e.stageY);
					}else{
					//	e.stopImmediatePropagation();
					}
					
					Ball(clickedObject).moveOnTouch(e.stageX,e.stageY);
				}
			}
			
		}
		
		
		
		
	}
}