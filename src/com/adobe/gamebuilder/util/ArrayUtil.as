package com.adobe.gamebuilder.util
{
    public class ArrayUtil 
    {


        public static function findMatchIndex(_arg1:Array, _arg2, _arg3:int=0, _arg4:Boolean=false):Number
        {
            var _local5:Boolean;
            var _local6:int = _arg1.length;
            var _local7:int = _arg3;
            while (_local7 < _local6)
            {
                if (_arg4)
                {
                    _local5 = !((_arg1[_local7].indexOf(_arg2) == -1));
                }
                else
                {
                    _local5 = (_arg1[_local7] == _arg2);
                };
                if (_local5)
                {
                    return (_local7);
                };
                _local7++;
            };
            return (-1);
        }

        public static function findLastIndex(_arg1:Array, _arg2, _arg3:int=0, _arg4:Boolean=false):Number
        {
            var _local5:Boolean;
            _arg3 = (((_arg3 > 0)) ? _arg3 : (_arg1.length - 1));
            var _local6:int = _arg3;
            while (_local6 >= 0)
            {
                if (_arg4)
                {
                    _local5 = !((_arg1[_local6].indexOf(_arg2) == -1));
                }
                else
                {
                    _local5 = (_arg1[_local6] == _arg2);
                };
                if (_local5)
                {
                    return (_local6);
                };
                _local6--;
            };
            return (-1);
        }

        public static function findMatchIndices(_arg1:Array, _arg2, _arg3:Boolean=false):Array
        {
            var _local4:Array = new Array();
            var _local5:Number = findMatchIndex(_arg1, _arg2, 0, _arg3);
            while (_local5 != -1)
            {
                _local4.push(_local5);
                _local5 = findMatchIndex(_arg1, _arg2, (_local5 + 1), _arg3);
            };
            return (_local4);
        }

        public static function contains(_arg1:Array, _arg2):Boolean
        {
            return ((findMatchIndex(_arg1, _arg2) > -1));
        }

        public static function remove(_arg1:Array, _arg2):Boolean
        {
            var _local3:uint = _arg1.length;
            while (_local3--)
            {
                if (_arg1[_local3] == _arg2)
                {
                    _arg1.splice(_local3, 1);
                    return (true);
                };
            };
            return (false);
        }

        public static function xmlListToArray(_arg1:XMLList):Array
        {
            var _local2:Array = new Array();
            var _local3:uint = _arg1.length();
            while (_local3--)
            {
                _local2.push(_arg1[_local3]);
            };
            return (_local2.reverse());
        }


    }
}//package at.cmd.framework.util
