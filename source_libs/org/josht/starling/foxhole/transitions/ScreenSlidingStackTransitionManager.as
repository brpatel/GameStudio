//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.transitions
{
    import org.josht.starling.foxhole.controls.ScreenNavigator;
    import __AS3__.vec.Vector;
    import org.josht.starling.motion.GTween;
    import com.gskinner.motion.easing.Sine;
    import starling.display.DisplayObject;
    import __AS3__.vec.*;

    public class ScreenSlidingStackTransitionManager 
    {

        private var _navigator:ScreenNavigator;
        private var _stack:Vector.<Class>;
        private var _activeTransition:GTween;
        private var _savedCompleteHandler:Function;
        public var duration:Number = 0.25;
        public var ease:Function;

        public function ScreenSlidingStackTransitionManager(_arg1:ScreenNavigator, _arg2:Class=null)
        {
            this._stack = new <Class>[];
            this.ease = Sine.easeOut;
            super();
            if (!_arg1)
            {
                throw (new ArgumentError("ScreenNavigator cannot be null."));
            };
            this._navigator = _arg1;
            if (_arg2)
            {
                this._stack.push(_arg2);
            };
            this._navigator.transition = this.onTransition;
        }

        public function clearStack():void
        {
            this._stack.length = 0;
        }

        private function onTransition(_arg1:DisplayObject, _arg2:DisplayObject, _arg3:Function):void
        {
            var _local6:Number;
            var _local7:Function;
            var _local8:Class;
            if (((!(_arg1)) || (!(_arg2))))
            {
                if (_arg2)
                {
                    _arg2.x = 0;
                };
                if (_arg1)
                {
                    _arg1.x = 0;
                };
                (_arg3());
                return;
            };
            if (this._activeTransition)
            {
                this._activeTransition.paused = true;
                this._activeTransition = null;
            };
            this._savedCompleteHandler = _arg3;
            var _local4:Class = Object(_arg2).constructor;
            var _local5:int = this._stack.indexOf(_local4);
            if (_local5 < 0)
            {
                _local8 = Object(_arg1).constructor;
                this._stack.push(_local8);
                _arg1.x = 0;
                _arg2.x = this._navigator.width;
                _local7 = this.activeTransitionPush_onChange;
            }
            else
            {
                this._stack.length = _local5;
                _arg1.x = 0;
                _arg2.x = -(this._navigator.width);
                _local7 = this.activeTransitionPop_onChange;
            };
            this._activeTransition = new GTween(_arg2, this.duration, {x:0}, {
                data:_arg1,
                ease:this.ease,
                onChange:_local7,
                onComplete:this.activeTransition_onComplete
            });
        }

        private function activeTransitionPush_onChange(_arg1:GTween):void
        {
            var _local2:DisplayObject = DisplayObject(_arg1.target);
            var _local3:DisplayObject = DisplayObject(_arg1.data);
            _local3.x = (_local2.x - this._navigator.width);
        }

        private function activeTransitionPop_onChange(_arg1:GTween):void
        {
            var _local2:DisplayObject = DisplayObject(_arg1.target);
            var _local3:DisplayObject = DisplayObject(_arg1.data);
            _local3.x = (_local2.x + this._navigator.width);
        }

        private function activeTransition_onComplete(_arg1:GTween):void
        {
            this._activeTransition = null;
            if (this._savedCompleteHandler != null)
            {
                this._savedCompleteHandler();
            };
        }


    }
}//package org.josht.starling.foxhole.transitions
