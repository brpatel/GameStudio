package com.adobe.gamebuilder.game.data
{
	public class StateQueue
	{
		public static var instance:StateQueue;
		public static var MAX_FRAMES:int = 199;
		public  var objectsState:Array = new Array();
		public var eventsQueue:Array = new Array();
		public var currentFrame:int=0;
		public var currentEventIndex:int= -1;
		
		
		public function StateQueue()
		{
			
		}
		
		public static function getInstance():StateQueue{
			if(instance == null){
				
				instance = new StateQueue;
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
			currentEventIndex = -1;
		}
		
		public function setFrameValueforObject(objectNum:int, x:int, y:int):void {
			
			if(objectsState[objectNum]!=null)
				(objectsState[objectNum]).push(new Array(x,y));
		}
		
		
		public function getFrameValueforObject(objectNum:int, frameNum:int):Array{
			//Check for range error based on frame num
			
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
			
			return objectsState[objectNum][currentFrame] ;
		}
		
		public function getPreviousFrameforObject(objectNum:int):Array{
						
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
	//		trace("current frame: " +currentFrame);
		}
		
		
		
		public function setEventForObject(frameNum:Number, objectNum:Number,  event:Number, localX:Number, localY:Number):void
		{
		//	trace("SetEvent: "+event + " & Current Frame: "+ frameNum);
			//(objectsState[objectNum][currentFrame]).push(new Array(objectNum,event,localX,localY));
			eventsQueue.push(new Array(frameNum, objectNum,event,localX,localY));
			
		}
		
		public function getEventForFrame():Array{
			
			
			if(currentEventIndex < eventsQueue.length -1)
				currentEventIndex++;
			/*else
				currentEventIndex =-1;*/
			
			var eventArray:Array = eventsQueue[currentEventIndex];
			return eventArray;
			
		}
		
		
		
		public function resetEventQueue():void
		{
			var arrayLenght:uint = eventsQueue.length;
			for (var i:int = 0; i < arrayLenght; i++) 
			{
				eventsQueue.pop();
			}
		}
	}
}