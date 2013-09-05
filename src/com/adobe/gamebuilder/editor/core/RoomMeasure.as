package com.adobe.gamebuilder.editor.core
{
    import starling.display.DisplayObject;

    public class RoomMeasure 
    {

        public static const WALL_SIZE:int = 14;
        public static const WALL_SIZE_HALF:int = 7;
        public static const WALL_SIZE_ONLINE:int = 14;


        public static function px2cm(_arg1:Number, _arg2:Boolean=true):Number
        {
			// Modified for level editor
           /* var _local3:Number = ((_arg1 / 284) * 200);
            return (((_arg2) ? Math.round(_local3) : _local3));*/
			
			
			return _arg1;
        }

        public static function cm2px(_arg1:Number, _arg2:Boolean=true):Number
        {
			// Modified for level editor
           /* var _local3:Number = ((_arg1 / 200) * 284);
            return (((_arg2) ? Math.round(_local3) : _local3));*/
			return _arg1;
        }

        public static function verticalSort(_arg1:DisplayObject, _arg2:DisplayObject):Number
        {
            return ((_arg1.y - _arg2.y));
        }

        public static function horizontalSort(_arg1:DisplayObject, _arg2:DisplayObject):Number
        {
            return ((_arg1.x - _arg2.x));
        }

        public static function measureDisplay(_arg1:Number):String
        {
            var _local2:Number = px2cm(_arg1, false);
            if (Settings.gridSnap)
            {
                _local2 = (Math.round((_local2 / Settings.gridSnapCm)) * Settings.gridSnapCm);
            };
            return (_local2.toFixed(0));
        }

        public static function productPos(_arg1:Number):Number
        {
            var _local2:Number;
            if (Settings.gridSnap)
            {
                _local2 = px2cm(_arg1, false);
                _local2 = (Math.round((_local2 / Settings.gridSnapCm)) * Settings.gridSnapCm);
                _arg1 = cm2px(_local2);
            };
            return (_arg1);
        }

        public static function pointPos(_arg1:Number, _arg2:String, _arg3:String, _arg4:String):Number
        {
            var _local5:uint;
            var _local6:Number;
            if (Settings.gridSnap)
            {
                if (_arg2 == "x")
                {
                    _local5 = (((_arg3)=="left") ? WALL_SIZE_HALF : WALL_SIZE_HALF);
                }
                else
                {
                    _local5 = (((_arg4)=="top") ? WALL_SIZE_HALF : WALL_SIZE_HALF);
                };
                _arg1 = (_arg1 + _local5);
                _local6 = px2cm(_arg1, false);
                _local6 = (Math.round((_local6 / Settings.gridSnapCm)) * Settings.gridSnapCm);
                _arg1 = cm2px(_local6, false);
                _arg1 = Math.round(_arg1);
                _arg1 = (_arg1 - _local5);
            };
            return (_arg1);
        }

        public static function productAngle(_arg1:Number):Number
        {
            if (Settings.angleSnap)
            {
                _arg1 = (Settings.angleSnapRad * Math.round((_arg1 / Settings.angleSnapRad)));
            };
            return (_arg1);
        }


    }
}//package at.polypex.badplaner.core
