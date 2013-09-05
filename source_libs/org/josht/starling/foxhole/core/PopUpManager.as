//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.core
{
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import starling.display.DisplayObject;
    import starling.display.Quad;
    import starling.core.Starling;
    import starling.display.Stage;
    import starling.events.Event;
    import starling.events.EnterFrameEvent;
    import __AS3__.vec.*;

    public class PopUpManager 
    {

        private static const POPUP_TO_OVERLAY:Dictionary = new Dictionary(true);

        public static var overlayFactory:Function = defaultOverlayFactory;
        protected static var popUps:Vector.<DisplayObject> = new <DisplayObject>[];


        public static function defaultOverlayFactory():DisplayObject
        {
            var _local1:Quad = new Quad(100, 100, 0);
            _local1.alpha = 0;
            return (_local1);
        }

        public static function addPopUp(_arg1:DisplayObject, _arg2:Boolean=true, _arg3:Boolean=true, _arg4:Function=null):void
        {
            var _local6:DisplayObject;
            var _local5:Stage = Starling.current.stage;
            if (_arg2)
            {
                if (_arg4 == null)
                {
                    _arg4 = overlayFactory;
                };
                if (_arg4 == null)
                {
                    _arg4 = defaultOverlayFactory;
                };
                _local6 = _arg4();
                _local6.width = _local5.stageWidth;
                _local6.height = _local5.stageHeight;
                _local5.addChild(_local6);
                POPUP_TO_OVERLAY[_arg1] = _local6;
            };
            popUps.push(_arg1);
            _local5.addChild(_arg1);
            _arg1.addEventListener(Event.REMOVED_FROM_STAGE, popUp_removedFromStageHandler);
            if (_arg3)
            {
                centerPopUp(_arg1);
            };
        }

        public static function removePopUp(_arg1:DisplayObject, _arg2:Boolean=false):void
        {
            var _local3:int = popUps.indexOf(_arg1);
            if (_local3 < 0)
            {
                throw (new ArgumentError("Display object is not a pop-up."));
            };
            _arg1.removeFromParent(_arg2);
        }

        public static function isPopUp(_arg1:DisplayObject):Boolean
        {
            return ((popUps.indexOf(_arg1) >= 0));
        }

        public static function centerPopUp(_arg1:DisplayObject):void
        {
            var _local2:Stage = Starling.current.stage;
            _arg1.x = ((_local2.stageWidth - _arg1.width) / 2);
            _arg1.y = ((_local2.stageHeight - _arg1.height) / 2);
        }

        protected static function popUp_removedFromStageHandler(_arg1:Event):void
        {
            var popUp:DisplayObject;
            var overlay:DisplayObject;
            var event:Event = _arg1;
            popUp = DisplayObject(event.currentTarget);
            popUp.removeEventListener(Event.REMOVED_FROM_STAGE, popUp_removedFromStageHandler);
            var index:int = popUps.indexOf(popUp);
            popUps.splice(index, 1);
            overlay = DisplayObject(POPUP_TO_OVERLAY[popUp]);
            if (overlay)
            {
                Starling.current.stage.addEventListener(EnterFrameEvent.ENTER_FRAME, function (_arg1:EnterFrameEvent):void
                {
                    _arg1.currentTarget.removeEventListener(_arg1.type, arguments.callee);
                    overlay.removeFromParent(true);
                    delete POPUP_TO_OVERLAY[popUp];
                });
            };
        }


    }
}//package org.josht.starling.foxhole.core
