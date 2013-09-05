//Created by Action Script Viewer - http://www.buraks.com/asv
package com.gskinner.motion.easing
{
    public class Cubic 
    {


        public static function easeIn(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Number
        {
            return (((_arg1 * _arg1) * _arg1));
        }

        public static function easeOut(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Number
        {
            --_arg1;
            return ((((_arg1 * _arg1) * _arg1) + 1));
        }

        public static function easeInOut(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Number
        {
            return ((((_arg1)<0.5) ? (((4 * _arg1) * _arg1) * _arg1) :  ((((4 * (_arg1-=1)) * _arg1) * _arg1) + 1)));
        }


    }
}//package com.gskinner.motion.easing
