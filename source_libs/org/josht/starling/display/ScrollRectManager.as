//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.display
{
    import flash.geom.Rectangle;
    import flash.geom.Matrix;
    import starling.display.DisplayObject;
    import flash.geom.Point;

    public class ScrollRectManager 
    {

        public static var scrollRectOffsetX:Number = 0;
        public static var scrollRectOffsetY:Number = 0;
        public static var currentScissorRect:Rectangle;


        public static function adjustTouchLocation(_arg1:Point, _arg2:DisplayObject):void
        {
            var _local3:Matrix;
            var _local5:IDisplayObjectWithScrollRect;
            var _local6:Rectangle;
            var _local4:DisplayObject = _arg2;
            while (_local4.parent)
            {
                _local4 = _local4.parent;
                if ((_local4 is IDisplayObjectWithScrollRect))
                {
                    _local5 = IDisplayObjectWithScrollRect(_local4);
                    _local6 = _local5.scrollRect;
                    if (!((!(_local6)) || ((((_local6.x == 0)) && ((_local6.y == 0))))))
                    {
                        _local3 = _local4.getTransformationMatrix(_arg2, _local3);
                        _arg1.x = (_arg1.x + (_local6.x * _local3.a));
                        _arg1.y = (_arg1.y + (_local6.y * _local3.d));
                    };
                };
            };
        }

        public static function toStageCoordinates(_arg1:Point, _arg2:DisplayObject):void
        {
            var _local3:Matrix;
            var _local5:IDisplayObjectWithScrollRect;
            var _local6:Rectangle;
            var _local4:DisplayObject = _arg2;
            while (_local4.parent)
            {
                _local4 = _local4.parent;
                if ((_local4 is IDisplayObjectWithScrollRect))
                {
                    _local5 = IDisplayObjectWithScrollRect(_local4);
                    _local6 = _local5.scrollRect;
                    if (!((!(_local6)) || ((((_local6.x == 0)) && ((_local6.y == 0))))))
                    {
                        _local3 = _local4.getTransformationMatrix(_arg2, _local3);
                        _arg1.x = (_arg1.x - (_local6.x * _local3.a));
                        _arg1.y = (_arg1.y - (_local6.y * _local3.d));
                    };
                };
            };
        }

        public static function getBounds(_arg1:DisplayObject, _arg2:DisplayObject, _arg3:Rectangle=null):Rectangle
        {
            var _local4:Matrix;
            var _local6:IDisplayObjectWithScrollRect;
            var _local7:Rectangle;
            if (!_arg3)
            {
                _arg3 = new Rectangle();
            };
            _arg1.getBounds(_arg2, _arg3);
            var _local5:DisplayObject = _arg1;
            while (_local5.parent)
            {
                _local5 = _local5.parent;
                if ((_local5 is IDisplayObjectWithScrollRect))
                {
                    _local6 = IDisplayObjectWithScrollRect(_local5);
                    _local7 = _local6.scrollRect;
                    if (!((!(_local7)) || ((((_local7.x == 0)) && ((_local7.y == 0))))))
                    {
                        _local4 = _local5.getTransformationMatrix(_arg1, _local4);
                        _arg3.x = (_arg3.x - (_local7.x * _local4.a));
                        _arg3.y = (_arg3.y - (_local7.y * _local4.d));
                    };
                };
            };
            return (_arg3);
        }


    }
}//package org.josht.starling.display
