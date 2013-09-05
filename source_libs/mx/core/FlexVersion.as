﻿//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.core
{
    import mx.resources.ResourceManager;

    public class FlexVersion 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        public static const CURRENT_VERSION:uint = 67502080;
        public static const VERSION_4_6:uint = 67502080;
        public static const VERSION_4_5:uint = 67436544;
        public static const VERSION_4_0:uint = 67108864;
        public static const VERSION_3_0:uint = 50331648;
        public static const VERSION_2_0_1:uint = 33554433;
        public static const VERSION_2_0:uint = 33554432;
        public static const VERSION_ALREADY_SET:String = "versionAlreadySet";
        public static const VERSION_ALREADY_READ:String = "versionAlreadyRead";

        private static var _compatibilityErrorFunction:Function;
        private static var _compatibilityVersion:uint = CURRENT_VERSION;//67502080
        private static var compatibilityVersionChanged:Boolean = false;
        private static var compatibilityVersionRead:Boolean = false;


        public static function get compatibilityErrorFunction():Function
        {
            return (_compatibilityErrorFunction);
        }

        public static function set compatibilityErrorFunction(_arg1:Function):void
        {
            _compatibilityErrorFunction = _arg1;
        }

        public static function get compatibilityVersion():uint
        {
            compatibilityVersionRead = true;
            return (_compatibilityVersion);
        }

        public static function set compatibilityVersion(_arg1:uint):void
        {
            var _local2:String;
            if (_arg1 == _compatibilityVersion)
            {
                return;
            };
            if (compatibilityVersionChanged)
            {
                if (compatibilityErrorFunction == null)
                {
                    _local2 = ResourceManager.getInstance().getString("core", VERSION_ALREADY_SET);
                    throw (new Error(_local2));
                };
                compatibilityErrorFunction(_arg1, VERSION_ALREADY_SET);
            };
            if (compatibilityVersionRead)
            {
                if (compatibilityErrorFunction == null)
                {
                    _local2 = ResourceManager.getInstance().getString("core", VERSION_ALREADY_READ);
                    throw (new Error(_local2));
                };
                compatibilityErrorFunction(_arg1, VERSION_ALREADY_READ);
            };
            _compatibilityVersion = _arg1;
            compatibilityVersionChanged = true;
        }

        public static function get compatibilityVersionString():String
        {
            var _local1:uint = ((compatibilityVersion >> 24) & 0xFF);
            var _local2:uint = ((compatibilityVersion >> 16) & 0xFF);
            var _local3:uint = (compatibilityVersion & 0xFFFF);
            return (((((_local1.toString() + ".") + _local2.toString()) + ".") + _local3.toString()));
        }

        public static function set compatibilityVersionString(_arg1:String):void
        {
            var _local2:Array = _arg1.split(".");
            var _local3:uint = parseInt(_local2[0]);
            var _local4:uint = parseInt(_local2[1]);
            var _local5:uint = parseInt(_local2[2]);
            compatibilityVersion = (((_local3 << 24) + (_local4 << 16)) + _local5);
        }

        mx_internal static function changeCompatibilityVersionString(_arg1:String):void
        {
            var _local2:Array = _arg1.split(".");
            var _local3:uint = parseInt(_local2[0]);
            var _local4:uint = parseInt(_local2[1]);
            var _local5:uint = parseInt(_local2[2]);
            _compatibilityVersion = (((_local3 << 24) + (_local4 << 16)) + _local5);
        }


    }
}//package mx.core
