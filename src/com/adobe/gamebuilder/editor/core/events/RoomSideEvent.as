
package com.adobe.gamebuilder.editor.core.events
{
    import flash.events.Event;

    public class RoomSideEvent extends Event 
    {

        public static const INIT:String = "sideMeasureInit";
        public static const CHANGE:String = "sideMeasureChange";
        public static const ENABLE:String = "sideEnableChange";
        public static const INITIAL_REQUEST:String = "sideInitRequest";
        public static const INPUT_CHANGE:String = "sideMeasureinputChange";
        public static const SIDES_UPDATE:String = "sidesUpdate";
        public static const SIDES_DIRECTION_UPDATE:String = "sidesDirectionUpdate";
        public static const SIDES_ENABLING_UPDATE:String = "sidesEnablingUpdate";

        public var data:Object;

        public function RoomSideEvent(_arg1:String, _arg2:Boolean=false, _arg3:Object=null)
        {
            this.data = _arg3;
            super(_arg1, _arg2);
        }

    }
}//package at.polypex.badplaner.core.events
