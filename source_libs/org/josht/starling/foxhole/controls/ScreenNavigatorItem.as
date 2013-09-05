//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls
{
    import starling.display.DisplayObject;
    import flash.errors.IllegalOperationError;

    public class ScreenNavigatorItem 
    {

        public var screen:Object;
        public var events:Object;
        public var initializer:Object;

        public function ScreenNavigatorItem(_arg1:Object, _arg2:Object=null, _arg3:Object=null)
        {
            this.screen = _arg1;
            this.events = ((_arg2) ? _arg2 : {});
            this.initializer = ((_arg3) ? _arg3 : {});
        }

        function getScreen():DisplayObject
        {
            var _local1:DisplayObject;
            var _local2:Class;
            var _local3:String;
            if ((this.screen is Class))
            {
                _local2 = Class(this.screen);
                _local1 = new (_local2)();
            }
            else
            {
                if ((this.screen is DisplayObject))
                {
                    _local1 = DisplayObject(this.screen);
                }
                else
                {
                    throw (new IllegalOperationError('ScreenNavigatorItem "screen" must be a Class or a display object.'));
                };
            };
            if (this.initializer)
            {
                for (_local3 in this.initializer)
                {
                    _local1[_local3] = this.initializer[_local3];
                };
            };
            return (_local1);
        }


    }
}//package org.josht.starling.foxhole.controls
