package com.adobe.gamebuilder.editor.core.data
{
    public class SystemMessage 
    {

        public static const DEFAULT_DELAY:uint = 2800;
        public static const LONG_DELAY:uint = 3800;
        public static const TYPE_ALERT:String = "alert";
        public static const TYPE_CONFIRM:String = "confirm";

        public var text:String;
        public var type:String;
        public var delay:uint;

        public function SystemMessage(_arg1:String, _arg2:String="alert", _arg3:uint=2800)
        {
            this.text = _arg1;
            this.type = _arg2;
            this.delay = _arg3;
        }

    }
}//package at.polypex.badplaner.core.data
