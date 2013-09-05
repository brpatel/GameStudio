//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.system
{
    import flash.system.Capabilities;
    import flash.display.Stage;

    public class PhysicalCapabilities 
    {

        public static var IS_TABLET_MINIMUM_INCHES:Number = 5;
        public static var CUSTOM_SCREEN_WIDTH:Number = NaN;
        public static var CUSTOM_SCREEN_HEIGHT:Number = NaN;
        public static var CUSTOM_SCREEN_DPI:Number = NaN;


        public static function isTablet(_arg1:Stage):Boolean
        {
            var _local2:Number = ((isNaN(CUSTOM_SCREEN_WIDTH)) ? _arg1.fullScreenWidth : CUSTOM_SCREEN_WIDTH);
            var _local3:Number = ((isNaN(CUSTOM_SCREEN_HEIGHT)) ? _arg1.fullScreenHeight : CUSTOM_SCREEN_HEIGHT);
            var _local4:Number = ((isNaN(CUSTOM_SCREEN_DPI)) ? Capabilities.screenDPI : CUSTOM_SCREEN_DPI);
            return (((Math.max(_local2, _local3) / _local4) >= IS_TABLET_MINIMUM_INCHES));
        }

        public static function isPhone(_arg1:Stage):Boolean
        {
            return (!(isTablet(_arg1)));
        }

        public static function screenInchesX(_arg1:Stage):Number
        {
            var _local2:Number = ((isNaN(CUSTOM_SCREEN_WIDTH)) ? _arg1.fullScreenWidth : CUSTOM_SCREEN_WIDTH);
            var _local3:Number = ((isNaN(CUSTOM_SCREEN_DPI)) ? Capabilities.screenDPI : CUSTOM_SCREEN_DPI);
            return ((_local2 / _local3));
        }

        public static function screenInchesY(_arg1:Stage):Number
        {
            var _local2:Number = ((isNaN(CUSTOM_SCREEN_HEIGHT)) ? _arg1.fullScreenHeight : CUSTOM_SCREEN_HEIGHT);
            var _local3:Number = ((isNaN(CUSTOM_SCREEN_DPI)) ? Capabilities.screenDPI : CUSTOM_SCREEN_DPI);
            return ((_local2 / _local3));
        }


    }
}//package org.josht.system
