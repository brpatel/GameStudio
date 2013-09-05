package com.adobe.gamebuilder.editor.view.events
{
    import com.adobe.gamebuilder.editor.model.vo.ObjectAsset;
    import flash.events.Event;
    
   
	public class CreateObjectInstanceEvent extends Event 
    {

        public static const CREATE_OBJECT_INSTANCE:String = "createObjectInstance";

        public var objectAsset:ObjectAsset;
        public var x:Number;
        public var y:Number;

        public function CreateObjectInstanceEvent(objectAsset:ObjectAsset, x:Number, y:Number)
        {
            super(CREATE_OBJECT_INSTANCE, false, false);
            this.objectAsset = objectAsset;
            this.x = x;
            this.y = y;
        }

        override public function clone():Event
        {
            return (new CreateObjectInstanceEvent(this.objectAsset, this.x, this.y));
        }


    }
}//package events
