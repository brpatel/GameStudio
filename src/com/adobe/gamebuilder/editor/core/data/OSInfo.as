package com.adobe.gamebuilder.editor.core.data
{
    import flash.system.Capabilities;
    import flash.ui.Multitouch;
    import flash.utils.describeType;

    public class OSInfo 
    {

        public var language:String;
        public var manufacturer:String;
        public var os:String;
        public var pixelAspectRatio:Number;
        public var screenDPI:Number;
        public var touchscreenType:String;
        public var screenResolutionX:Number;
        public var screenResolutionY:Number;
        public var multitouch_inputMode:String;
        public var multitouch_supportsTouchEvents:Boolean;
        public var multitouch_maxTouchPoints:int;

        public function OSInfo()
        {
            this.language = Capabilities.language;
            this.manufacturer = Capabilities.manufacturer;
            this.os = Capabilities.os;
            this.pixelAspectRatio = Capabilities.pixelAspectRatio;
            this.screenDPI = Capabilities.screenDPI;
            this.touchscreenType = Capabilities.touchscreenType;
            this.screenResolutionX = Capabilities.screenResolutionX;
            this.screenResolutionY = Capabilities.screenResolutionY;
            this.multitouch_inputMode = Multitouch.inputMode;
            this.multitouch_supportsTouchEvents = Multitouch.supportsTouchEvents;
            this.multitouch_maxTouchPoints = Multitouch.maxTouchPoints;
        }

        public function toString():String
        {
            var _local1:XMLList = describeType(this).variable.@name;
            var _local2 = "";
            var _local3:int;
            while (_local3 < _local1.length())
            {
                _local2 = (_local2 + ((((((_local2)!="") ? ", " : "") + _local1[_local3]) + "=") + this[_local1[_local3]]));
                _local3++;
            };
            return ((("OSInfo [" + _local2) + "]"));
        }


    }
}//package at.polypex.badplaner.core.data
