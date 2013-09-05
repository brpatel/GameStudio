//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.utils
{
    import mx.core.mx_internal;

    use namespace mx_internal;

    public class StringUtil 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";


        public static function trim(_arg1:String):String
        {
            if (_arg1 == null)
            {
                return ("");
            };
            var _local2:int;
            while (isWhitespace(_arg1.charAt(_local2)))
            {
                _local2++;
            };
            var _local3:int = (_arg1.length - 1);
            while (isWhitespace(_arg1.charAt(_local3)))
            {
                _local3--;
            };
            if (_local3 >= _local2)
            {
                return (_arg1.slice(_local2, (_local3 + 1)));
            };
            return ("");
        }

        public static function trimArrayElements(_arg1:String, _arg2:String):String
        {
            var _local3:Array;
            var _local4:int;
            var _local5:int;
            if (((!((_arg1 == ""))) && (!((_arg1 == null)))))
            {
                _local3 = _arg1.split(_arg2);
                _local4 = _local3.length;
                _local5 = 0;
                while (_local5 < _local4)
                {
                    _local3[_local5] = StringUtil.trim(_local3[_local5]);
                    _local5++;
                };
                if (_local4 > 0)
                {
                    _arg1 = _local3.join(_arg2);
                };
            };
            return (_arg1);
        }

        public static function isWhitespace(_arg1:String):Boolean
        {
            switch (_arg1)
            {
                case " ":
                case "\t":
                case "\r":
                case "\n":
                case "\f":
                    return (true);
                default:
                    return (false);
            };
        }

        public static function substitute(_arg1:String, ... _args):String
        {
            var _local4:Array;
            if (_arg1 == null)
            {
                return ("");
            };
            var _local3:uint = _args.length;
            if ((((_local3 == 1)) && ((_args[0] is Array))))
            {
                _local4 = (_args[0] as Array);
                _local3 = _local4.length;
            }
            else
            {
                _local4 = _args;
            };
            var _local5:int;
            while (_local5 < _local3)
            {
                _arg1 = _arg1.replace(new RegExp((("\\{" + _local5) + "\\}"), "g"), _local4[_local5]);
                _local5++;
            };
            return (_arg1);
        }

        public static function repeat(_arg1:String, _arg2:int):String
        {
            if (_arg2 == 0)
            {
                return ("");
            };
            var _local3:String = _arg1;
            var _local4:int = 1;
            while (_local4 < _arg2)
            {
                _local3 = (_local3 + _arg1);
                _local4++;
            };
            return (_local3);
        }

        public static function restrict(_arg1:String, _arg2:String):String
        {
            var _local6:uint;
            if (_arg2 == null)
            {
                return (_arg1);
            };
            if (_arg2 == "")
            {
                return ("");
            };
            var _local3:Array = [];
            var _local4:int = _arg1.length;
            var _local5:int;
            while (_local5 < _local4)
            {
                _local6 = _arg1.charCodeAt(_local5);
                if (testCharacter(_local6, _arg2))
                {
                    _local3.push(_local6);
                };
                _local5++;
            };
            return (String.fromCharCode.apply(null, _local3));
        }

        private static function testCharacter(_arg1:uint, _arg2:String):Boolean
        {
            var _local9:uint;
            var _local11:Boolean;
            var _local3:Boolean;
            var _local4:Boolean;
            var _local5:Boolean;
            var _local6:Boolean = true;
            var _local7:uint;
            var _local8:int = _arg2.length;
            if (_local8 > 0)
            {
                _local9 = _arg2.charCodeAt(0);
                if (_local9 == 94)
                {
                    _local3 = true;
                };
            };
            var _local10:int;
            while (_local10 < _local8)
            {
                _local9 = _arg2.charCodeAt(_local10);
                _local11 = false;
                if (!_local4)
                {
                    if (_local9 == 45)
                    {
                        _local5 = true;
                    }
                    else
                    {
                        if (_local9 == 94)
                        {
                            _local6 = !(_local6);
                        }
                        else
                        {
                            if (_local9 == 92)
                            {
                                _local4 = true;
                            }
                            else
                            {
                                _local11 = true;
                            };
                        };
                    };
                }
                else
                {
                    _local11 = true;
                    _local4 = false;
                };
                if (_local11)
                {
                    if (_local5)
                    {
                        if ((((_local7 <= _arg1)) && ((_arg1 <= _local9))))
                        {
                            _local3 = _local6;
                        };
                        _local5 = false;
                        _local7 = 0;
                    }
                    else
                    {
                        if (_arg1 == _local9)
                        {
                            _local3 = _local6;
                        };
                        _local7 = _local9;
                    };
                };
                _local10++;
            };
            return (_local3);
        }


    }
}//package mx.utils
