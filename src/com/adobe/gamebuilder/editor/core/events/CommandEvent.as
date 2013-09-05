package com.adobe.gamebuilder.editor.core.events
{
    import flash.events.Event;

    public class CommandEvent extends Event 
    {

        public static const GET_QUOTE:String = "getQuote";
        public static const SEND_PLAN:String = "sendPlan";
        public static const SAVE_PLAN:String = "savePlan";
        public static const LOAD_PRODUCTS:String = "loadProducts";

        public var data:Object;

        public function CommandEvent(_arg1:String, _arg2:Object=null, _arg3:Boolean=false, _arg4:Boolean=false)
        {
            this.data = _arg2;
            super(_arg1, _arg3, _arg4);
        }

    }
}//package at.polypex.badplaner.core.events
