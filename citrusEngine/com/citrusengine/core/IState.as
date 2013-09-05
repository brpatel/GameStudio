package com.citrusengine.core {

	import com.citrusengine.system.Entity;
	import com.citrusengine.system.components.ViewComponent;
	import com.citrusengine.view.CitrusView;
	
	/**
	 * Take a look on the 2 respective states to have some information on the functions.
	 */
	public interface IState {
		
		function destroy():void;
		
		function get view():CitrusView;
		
		function initialize():void;
		
		function update(timeDelta:Number):void;
		
		function add(object:CitrusObject):CitrusObject;
		
		function addEntity(entity:Entity, view:ViewComponent = null):Entity;
		
		function remove(object:CitrusObject):void;
		
		function getObjectByName(name:String):CitrusObject;
		
		function getFirstObjectByType(type:Class):CitrusObject;
		
		function getObjectsByType(type:Class):Vector.<CitrusObject>;
		
		/********* Added for level editor******/
		function getAllObjects():Vector.<CitrusObject>;
		
		function getObjectCount():int;
		
		function get isReplayMode():Boolean;
		
		function set isReplayMode(replayMode:Boolean);
	}
}
