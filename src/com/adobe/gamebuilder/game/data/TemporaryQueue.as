package com.adobe.gamebuilder.game.data
{
	public class TemporaryQueue
	{
		public static var instance:TemporaryQueue;
		public static var MAX_FRAMES:int = 99;
		public  var objectsState:Array = new Array();
		public var currentFrame:int=0;
		
		
		public function TemporaryQueue()
		{
			
		}
		
		public static function getInstance():TemporaryQueue{
			if(instance == null){
				
				instance = new TemporaryQueue;
			}
			return instance;
		}
		
		public function setNoOfObjects(noOfObjects:int):void{
			
			for (var i:int = 0; i < noOfObjects; i++) 
			{
				objectsState.push(new Array());
			}
			
		}
		
		public function resetQueue():void{
			var arrayLenght:uint = objectsState.length;
			for (var i:int = 0; i < arrayLenght; i++) 
			{
				objectsState.pop();
			}
		}
		
		public function setFrameValueforObject(objectNum:int, x:int, y:int):void {
			
			(objectsState[objectNum]).push(new Array(x,y));
		}
		
		
		public function getFrameValueforObject(objectNum:int, frameNum:int):Array{
			return objectsState[objectNum][frameNum] ;
		}
		
		public function getFirstFrameforObject(objectNum:int):Array{
			currentFrame --;
			return objectsState[objectNum][currentFrame] ;
		}
		
		public function getLastFrameforObject(objectNum:int):Array{
			return objectsState[objectNum][0] ;
		}
		
		public function getNextFrameforObject(objectNum:int):Array{
			if (currentFrame < MAX_FRAMES ){
				currentFrame ++;
			}
			return objectsState[objectNum][currentFrame] ;
		}
		
		public function getPreviousFrameforObject(objectNum:int):Array{
			if (currentFrame > 1 ){
				currentFrame --;
			}
			
			return objectsState[objectNum][currentFrame] ;
		}
		
		public function incrementFrameNumber():void
		{
			if (currentFrame >= MAX_FRAMES){
				
				for (var i:int = 0; i < objectsState.length; i++) 
				{
					(objectsState[i]).shift();
					
				}				
				
				currentFrame--;
			}
			currentFrame++;	
		//	trace("current frame: " +currentFrame);
		}
		
		public function setEventForObject(objectNum:Number, event:Number, stageX:Number, stageY:Number, frameNum:Number):void
		{
			trace("SetEvent: "+event + " & Current Frame: "+ frameNum);
			(objectsState[objectNum][frameNum]).push(new Array(objectNum,event,stageX,stageY));
		}
	}
}