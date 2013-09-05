package com.adobe.gamebuilder.util
{
    import flash.geom.ColorTransform;
    import flash.geom.Transform;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.geom.Point;

    public class Utils 
    {


        public static function setObjectColor(_arg1:Transform, _arg2:uint):void
        {
            var _local3:ColorTransform = new ColorTransform();
            _local3.color = _arg2;
            _arg1.colorTransform = _local3;
        }

        public static function openURL(_arg1:String, _arg2:String):void
        {
            var _local3:URLRequest = new URLRequest(_arg1);
            try
            {
                navigateToURL(_local3, _arg2);
            }
            catch(e:Error)
            {
            };
        }

        public static function traceObject(_arg1):void
        {
            var _local2:*;
            var _local3:*;
            for (_local2 in _arg1)
            {
                if ((_arg1[_local2] is Object))
                {
                    for (_local3 in _arg1[_local2])
                    {
                    };
                };
            };
        }

        public static function calcRotation(_arg1:Point, _arg2:Point):Number
        {
            var _local3:Number;
            var _local4:Number = (_arg2.y - _arg1.y);
            var _local5:Number = (_arg2.x - _arg1.x);
            if (_local5 == 0)
            {
                _local3 = (((_local4)>0) ? (Math.PI / 2) : (-(Math.PI) / 2));
            }
            else
            {
                _local3 = Math.atan((_local4 / _local5));
            };
            _local3 = (_local3 * (180 / Math.PI));
            if (_local5 < 0)
            {
                _local3 = (_local3 + 180);
            };
            return (_local3);
        }

        public static function lineIntersectLine(_arg1:Point, _arg2:Point, _arg3:Point, _arg4:Point, _arg5:Boolean=true):Point
        {
            var _local6:Point;
            var _local7:Number;
            var _local8:Number;
            var _local9:Number;
            var _local10:Number;
            var _local11:Number;
            var _local12:Number;
            _local7 = (_arg2.y - _arg1.y);
            _local9 = (_arg1.x - _arg2.x);
            _local11 = ((_arg2.x * _arg1.y) - (_arg1.x * _arg2.y));
            _local8 = (_arg4.y - _arg3.y);
            _local10 = (_arg3.x - _arg4.x);
            _local12 = ((_arg4.x * _arg3.y) - (_arg3.x * _arg4.y));
            var _local13:Number = ((_local7 * _local10) - (_local8 * _local9));
            if (_local13 == 0)
            {
                return (null);
            };
            _local6 = new Point();
            _local6.x = (((_local9 * _local12) - (_local10 * _local11)) / _local13);
            _local6.y = (((_local8 * _local11) - (_local7 * _local12)) / _local13);
            if (_arg5)
            {
                if ((Math.pow((_local6.x - _arg2.x), 2) + Math.pow((_local6.y - _arg2.y), 2)) > (Math.pow((_arg1.x - _arg2.x), 2) + Math.pow((_arg1.y - _arg2.y), 2)))
                {
                    return (null);
                };
                if ((Math.pow((_local6.x - _arg1.x), 2) + Math.pow((_local6.y - _arg1.y), 2)) > (Math.pow((_arg1.x - _arg2.x), 2) + Math.pow((_arg1.y - _arg2.y), 2)))
                {
                    return (null);
                };
                if ((Math.pow((_local6.x - _arg4.x), 2) + Math.pow((_local6.y - _arg4.y), 2)) > (Math.pow((_arg3.x - _arg4.x), 2) + Math.pow((_arg3.y - _arg4.y), 2)))
                {
                    return (null);
                };
                if ((Math.pow((_local6.x - _arg3.x), 2) + Math.pow((_local6.y - _arg3.y), 2)) > (Math.pow((_arg3.x - _arg4.x), 2) + Math.pow((_arg3.y - _arg4.y), 2)))
                {
                    return (null);
                };
            };
            return (_local6);
        }


    }
}//package at.cmd.framework.util
