package com.adobe.gamebuilder.editor.core.events
{
    import flash.events.Event;

    public class ContextEvent extends Event 
    {

        public static const NEW_PLAN:String = "newPlan";
        public static const BASE_ROOM_CHANGED:String = "baseRoomChanged";
        public static const SET_BASE_ROOM_REQUEST:String = "setBaseRoomRequest";
        public static const ROOM_REFLECTION:String = "roomReflection";
        public static const SCREEN_CHANGED:String = "screenChanged";
        public static const SET_SCREEN_REQUEST:String = "setScreenRequest";
        public static const ADD_PRODUCT:String = "addProduct";
        public static const PRODUCT_LOAD_COMPLETE:String = "productLoadComplete";
        public static const SAVE_PLAN_REQUEST:String = "savePlanRequest";
        public static const SAVE_PLAN_COMPLETE:String = "savePlanComplete";
        public static const LOAD_PLAN:String = "loadPlan";
        public static const LOAD_PLAN_COMPLETE:String = "loadPlanComplete";
        public static const CONTAINER_TOUCH:String = "containerTouch";
        public static const SHOW_ACTION_BAR:String = "showActionBar";
        public static const HIDE_ACTION_BAR:String = "hideActionBar";
        public static const RESET_TOPBAR:String = "resetTopbar";
        public static const SWITCH_PRESENTATION_MODE:String = "switchPresentationMode";
        public static const OPEN_OVERLAY:String = "openOverlay";
        public static const SET_PLAN_NAME:String = "setPlanName";
        public static const SYSTEM_MESSAGE:String = "systemMessage";
        public static const SUCCESS:String = "success";
        public static const ERROR:String = "error";
		
		// For level Editor
		public static const ADD_BACKGROUND_IMAGE:String = "addBackgroundImage";

        public var data:Object;

        public function ContextEvent(_arg1:String, _arg2:Object=null, _arg3:Boolean=false, _arg4:Boolean=false)
        {
            this.data = _arg2;
            super(_arg1, _arg3, _arg4);
        }

        override public function clone():Event
        {
            return (new ContextEvent(type, this.data, bubbles, cancelable));
        }


    }
}//package at.polypex.badplaner.core.events
