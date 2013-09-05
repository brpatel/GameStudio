//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.utils
{
    import mx.core.mx_internal;
    import mx.core.IFlexModuleFactory;
    import flash.system.Capabilities;

    use namespace mx_internal;

    public class MediaQueryParser 
    {

        public static var platformMap:Object = {
            AND:"android",
            IOS:"ios",
            MAC:"macintosh",
            WIN:"windows",
            LNX:"linux",
            QNX:"qnx"
        };
        private static var _instance:MediaQueryParser;

        mx_internal var goodQueries:Object;
        mx_internal var badQueries:Object;
        public var type:String = "screen";
        public var applicationDpi:Number;
        public var osPlatform:String;

        public function MediaQueryParser(_arg1:IFlexModuleFactory=null)
        {
            this.goodQueries = {};
            this.badQueries = {};
            super();
            this.applicationDpi = DensityUtil.getRuntimeDPI();
            if (_arg1)
            {
                if (_arg1.info()["applicationDPI"] != null)
                {
                    this.applicationDpi = _arg1.info()["applicationDPI"];
                };
            };
            this.osPlatform = this.getPlatform();
        }

        public static function get instance():MediaQueryParser
        {
            return (_instance);
        }

        public static function set instance(_arg1:MediaQueryParser):void
        {
            if (!_instance)
            {
                _instance = _arg1;
            };
        }


        public function parse(_arg1:String):Boolean
        {
            var _local5:Boolean;
            var _local6:String;
            var _local7:Boolean;
            var _local8:Array;
            var _local9:int;
            _arg1 = StringUtil.trim(_arg1);
            _arg1 = _arg1.toLowerCase();
            if (_arg1 == "")
            {
                return (true);
            };
            if (_arg1 == "all")
            {
                return (true);
            };
            if (this.goodQueries[_arg1])
            {
                return (true);
            };
            if (this.badQueries[_arg1])
            {
                return (false);
            };
            var _local2:Array = _arg1.split(", ");
            var _local3:int = _local2.length;
            var _local4:int;
            while (_local4 < _local3)
            {
                _local6 = _local2[_local4];
                _local7 = false;
                if (_local6.indexOf("only ") == 0)
                {
                    _local6 = _local6.substr(5);
                };
                if (_local6.indexOf("not ") == 0)
                {
                    _local7 = true;
                    _local6 = _local6.substr(4);
                };
                _local8 = this.tokenizeMediaQuery(_local6);
                _local9 = _local8.length;
                if ((((_local8[0] == "all")) || ((_local8[0] == this.type))))
                {
                    if ((((_local9 == 1)) && (!(_local7))))
                    {
                        this.goodQueries[_arg1] = true;
                        return (true);
                    };
                    if (_local9 == 2)
                    {
                        return (false);
                    };
                    _local8.shift();
                    _local8.shift();
                    _local5 = this.evalExpressions(_local8);
                    if (((((_local5) && (!(_local7)))) || (((!(_local5)) && (_local7)))))
                    {
                        this.goodQueries[_arg1] = true;
                        return (true);
                    };
                }
                else
                {
                    if (_local7)
                    {
                        this.goodQueries[_arg1] = true;
                        return (true);
                    };
                };
                _local4++;
            };
            this.badQueries[_arg1] = true;
            return (false);
        }

        private function tokenizeMediaQuery(_arg1:String):Array
        {
            var _local9:String;
            var _local2:Array = [];
            var _local3:int = _arg1.indexOf("(");
            if (_local3 == 0)
            {
                _local2.push("all");
                _local2.push("and");
            }
            else
            {
                if (_local3 == -1)
                {
                    return ([_arg1]);
                };
            };
            var _local4:int;
            var _local5:Boolean;
            var _local6:int = _arg1.length;
            var _local7:Array = [];
            var _local8:int;
            while (_local8 < _local6)
            {
                _local9 = _arg1.charAt(_local8);
                if (!((StringUtil.isWhitespace(_local9)) && ((_local7.length == 0))))
                {
                    if ((((((_local9 == "/")) && ((_local8 < (_local6 - 1))))) && ((_arg1.charAt((_local8 + 1)) == "*"))))
                    {
                        _local5 = true;
                        _local8++;
                    }
                    else
                    {
                        if (_local5)
                        {
                            if ((((((_local9 == "*")) && ((_local8 < (_local6 - 1))))) && ((_arg1.charAt((_local8 + 1)) == "/"))))
                            {
                                _local5 = false;
                                _local8++;
                            };
                        }
                        else
                        {
                            if (_local9 == "(")
                            {
                                _local4++;
                            }
                            else
                            {
                                if (_local9 == ")")
                                {
                                    _local4--;
                                }
                                else
                                {
                                    _local7.push(_local9);
                                };
                            };
                            if ((((_local4 == 0)) && (((StringUtil.isWhitespace(_local9)) || ((_local9 == ")"))))))
                            {
                                if (_local9 != ")")
                                {
                                    _local7.length--;
                                };
                                _local2.push(_local7.join(""));
                                _local7.length = 0;
                            };
                        };
                    };
                };
                _local8++;
            };
            return (_local2);
        }

        private function evalExpressions(_arg1:Array):Boolean
        {
            var _local4:String;
            var _local5:Array;
            var _local6:Boolean;
            var _local7:Boolean;
            var _local2:int = _arg1.length;
            var _local3:int;
            while (_local3 < _local2)
            {
                _local4 = _arg1[_local3];
                if (_local4 != "and")
                {
                    _local5 = _local4.split(":");
                    _local6 = false;
                    _local7 = false;
                    if (_local5[0].indexOf("min-") == 0)
                    {
                        _local6 = true;
                        _local5[0] = _local5[0].substr(4);
                    }
                    else
                    {
                        if (_local5[0].indexOf("max-") == 0)
                        {
                            _local7 = true;
                            _local5[0] = _local5[0].substr(4);
                        };
                    };
                    if (_local5[0].indexOf("-") > 0)
                    {
                        _local5[0] = this.deHyphenate(_local5[0]);
                    };
                    if (_local5.length == 1)
                    {
                        if (!(_local5[0] in this))
                        {
                            return (false);
                        };
                    };
                    if (_local5.length == 2)
                    {
                        if (!(_local5[0] in this))
                        {
                            return (false);
                        };
                        if (_local6)
                        {
                            if (this[_local5[0]] < this.normalize(_local5[1], typeof(this[_local5[0]])))
                            {
                                return (false);
                            };
                        }
                        else
                        {
                            if (_local7)
                            {
                                if (this[_local5[0]] > this.normalize(_local5[1], typeof(this[_local5[0]])))
                                {
                                    return (false);
                                };
                            }
                            else
                            {
                                if (this[_local5[0]] != this.normalize(_local5[1], typeof(this[_local5[0]])))
                                {
                                    return (false);
                                };
                            };
                        };
                    };
                };
                _local3++;
            };
            return (true);
        }

        private function normalize(_arg1:String, _arg2:String):Object
        {
            var _local3:int;
            if (_arg1.charAt(0) == " ")
            {
                _arg1 = _arg1.substr(1);
            };
            if (_arg2 == "number")
            {
                _local3 = _arg1.indexOf("dpi");
                if (_local3 != -1)
                {
                    _arg1 = _arg1.substr(0, _local3);
                };
                return (Number(_arg1));
            };
            if (_arg2 == "int")
            {
                return (int(_arg1));
            };
            if (_arg2 == "string")
            {
                if (_arg1.indexOf('"') == 0)
                {
                    if (_arg1.lastIndexOf('"') == (_arg1.length - 1))
                    {
                        _arg1 = _arg1.substr(1, (_arg1.length - 2));
                    }
                    else
                    {
                        _arg1 = _arg1.substr(1);
                    };
                };
            };
            return (_arg1);
        }

        private function deHyphenate(_arg1:String):String
        {
            var _local3:String;
            var _local4:String;
            var _local2:int = _arg1.indexOf("-");
            while (_local2 > 0)
            {
                _local3 = _arg1.substr((_local2 + 1));
                _arg1 = _arg1.substr(0, _local2);
                _local4 = _local3.charAt(0);
                _local4 = _local4.toUpperCase();
                _arg1 = (_arg1 + (_local4 + _local3.substr(1)));
                _local2 = _arg1.indexOf("-");
            };
            return (_arg1);
        }

        private function getPlatform():String
        {
            var _local1:String = Capabilities.version.substr(0, 3);
            if (platformMap.hasOwnProperty(_local1))
            {
                return ((platformMap[_local1] as String));
            };
            return (_local1.toLowerCase());
        }


    }
}//package mx.utils
