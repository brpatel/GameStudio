//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.utils
{
    import mx.core.mx_internal;
    import flash.display.LoaderInfo;
    import mx.managers.SystemManagerGlobals;
    import mx.core.IFlexModuleFactory;
    import flash.utils.Dictionary;
    import mx.core.RSLData;
    import mx.core.ApplicationDomainTarget;
    import flash.system.Capabilities;
    import mx.events.Request;
    import flash.display.DisplayObject;
    import __AS3__.vec.Vector;

    use namespace mx_internal;

    public class LoaderUtil 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        mx_internal static var urlFilters:Array = [{
            searchString:"/[[DYNAMIC]]/",
            filterFunction:dynamicURLFilter
        }, {
            searchString:"/[[IMPORT]]/",
            filterFunction:importURLFilter
        }];


        public static function normalizeURL(_arg1:LoaderInfo):String
        {
            var _local3:int;
            var _local4:String;
            var _local5:Function;
            var _local2:String = _arg1.url;
            var _local6:uint = LoaderUtil.urlFilters.length;
            var _local7:uint;
            while (_local7 < _local6)
            {
                _local4 = LoaderUtil.urlFilters[_local7].searchString;
                _local3 = _local2.indexOf(_local4);
                if (_local3 != -1)
                {
                    _local5 = LoaderUtil.urlFilters[_local7].filterFunction;
                    _local2 = _local5(_local2, _local3);
                };
                _local7++;
            };
            if (isMac())
            {
                return (encodeURI(_local2));
            };
            return (_local2);
        }

        public static function createAbsoluteURL(_arg1:String, _arg2:String):String
        {
            var _local4:int;
            var _local5:int;
            var _local3:String = _arg2;
            if (((_arg1) && (!((((((_arg2.indexOf(":") > -1)) || ((_arg2.indexOf("/") == 0)))) || ((_arg2.indexOf("\\") == 0)))))))
            {
                _local4 = _arg1.indexOf("?");
                if (_local4 != -1)
                {
                    _arg1 = _arg1.substring(0, _local4);
                };
                _local4 = _arg1.indexOf("#");
                if (_local4 != -1)
                {
                    _arg1 = _arg1.substring(0, _local4);
                };
                _local5 = Math.max(_arg1.lastIndexOf("\\"), _arg1.lastIndexOf("/"));
                if (_arg2.indexOf("./") == 0)
                {
                    _arg2 = _arg2.substring(2);
                }
                else
                {
                    while (_arg2.indexOf("../") == 0)
                    {
                        _arg2 = _arg2.substring(3);
                        _local5 = Math.max(_arg1.lastIndexOf("\\", (_local5 - 1)), _arg1.lastIndexOf("/", (_local5 - 1)));
                    };
                };
                if (_local5 != -1)
                {
                    _local3 = (_arg1.substr(0, (_local5 + 1)) + _arg2);
                };
            };
            return (_local3);
        }

        mx_internal static function processRequiredRSLs(_arg1:IFlexModuleFactory, _arg2:Array):Array
        {
            var _local12:int;
            var _local13:int;
            var _local14:Array;
            var _local15:int;
            var _local3:Array = [];
            var _local4:IFlexModuleFactory = SystemManagerGlobals.topLevelSystemManagers[0];
            var _local5:IFlexModuleFactory = _local4;
            var _local6:IFlexModuleFactory;
            var _local7:Dictionary = new Dictionary();
            var _local8:int;
            var _local9:Dictionary = new Dictionary();
            var _local10:int;
            var _local11:Array;
            while (_local5 != _arg1)
            {
                _local12 = _arg2.length;
                _local13 = 0;
                while (_local13 < _local12)
                {
                    _local14 = _arg2[_local13];
                    if (!_local7[_local14])
                    {
                        if (isRSLLoaded(_local5, _local14[0].digest))
                        {
                            _local7[_local14] = 1;
                            _local8++;
                            if (_local5 != _local4)
                            {
                                _local15 = _local3.indexOf(_local14);
                                if (_local15 != -1)
                                {
                                    _local3.splice(_local15, 1);
                                };
                            };
                        }
                        else
                        {
                            if (_local3.indexOf(_local14) == -1)
                            {
                                _local3.push(_local14);
                            };
                        };
                    };
                    if (((!(_local7[_local14])) && ((_local9[_local14] == null))))
                    {
                        if (((!(_local6)) && ((RSLData(_local14[0]).applicationDomainTarget == ApplicationDomainTarget.PARENT))))
                        {
                            _local6 = getParentModuleFactory(_arg1);
                        };
                        if (resolveApplicationDomainTarget(_local14, _arg1, _local5, _local6, _local4))
                        {
                            _local9[_local14] = 1;
                            _local10++;
                        };
                    };
                    _local13++;
                };
                if ((_local8 + _local10) >= _arg2.length) break;
                if (!_local11)
                {
                    _local11 = [_arg1];
                    _local5 = _arg1;
                    while (_local5 != _local4)
                    {
                        _local5 = getParentModuleFactory(_local5);
                        if (!_local5) break;
                        if (_local5 != _local4)
                        {
                            _local11.push(_local5);
                        };
                        if (!_local6)
                        {
                            _local6 = _local5;
                        };
                    };
                };
                _local5 = _local11.pop();
            };
            return (_local3);
        }

        mx_internal static function isLocal(_arg1:String):Boolean
        {
            return ((((_arg1.indexOf("file:") == 0)) || ((_arg1.indexOf(":") == 1))));
        }

        mx_internal static function OSToPlayerURI(_arg1:String, _arg2:Boolean):String
        {
            var _local3:int;
            var _local4:int;
            var _local7:int;
            var _local5:String = _arg1;
            _local3 = _local5.indexOf("?");
            if (_local3 != -1)
            {
                _local5 = _local5.substring(0, _local3);
            };
            _local4 = _local5.indexOf("#");
            if (_local4 != -1)
            {
                _local5 = _local5.substring(0, _local4);
            };
            try
            {
                _local5 = decodeURI(_local5);
            }
            catch(e:Error)
            {
            };
            var _local6:String;
            if (((!((_local3 == -1))) || (!((_local4 == -1)))))
            {
                _local7 = _local3;
                if ((((_local3 == -1)) || (((!((_local4 == -1))) && ((_local4 < _local3))))))
                {
                    _local7 = _local4;
                };
                _local6 = _arg1.substr(_local7);
            };
            if (((_arg2) && ((Capabilities.playerType == "ActiveX"))))
            {
                if (_local6)
                {
                    return ((_local5 + _local6));
                };
                return (_local5);
            };
            if (_local6)
            {
                return ((encodeURI(_local5) + _local6));
            };
            return (encodeURI(_local5));
        }

        private static function getParentModuleFactory(_arg1:IFlexModuleFactory):IFlexModuleFactory
        {
            var _local2:Request = new Request(Request.GET_PARENT_FLEX_MODULE_FACTORY_REQUEST);
            DisplayObject(_arg1).dispatchEvent(_local2);
            return ((_local2.value as IFlexModuleFactory));
        }

        private static function resolveApplicationDomainTarget(_arg1:Array, _arg2:IFlexModuleFactory, _arg3:IFlexModuleFactory, _arg4:IFlexModuleFactory, _arg5:IFlexModuleFactory):Boolean
        {
            var _local6:Boolean;
            var _local7:IFlexModuleFactory;
            var _local8:String = _arg1[0].applicationDomainTarget;
            if (isLoadedIntoTopLevelApplicationDomain(_arg2))
            {
                _local7 = _arg5;
            }
            else
            {
                if (_local8 == ApplicationDomainTarget.DEFAULT)
                {
                    if (hasPlaceholderRSL(_arg3, _arg1[0].digest))
                    {
                        _local7 = _arg3;
                    };
                }
                else
                {
                    if (_local8 == ApplicationDomainTarget.TOP_LEVEL)
                    {
                        _local7 = _arg5;
                    }
                    else
                    {
                        if (_local8 == ApplicationDomainTarget.CURRENT)
                        {
                            _local6 = true;
                        }
                        else
                        {
                            if (_local8 == ApplicationDomainTarget.PARENT)
                            {
                                _local7 = _arg4;
                            }
                            else
                            {
                                _local6 = true;
                            };
                        };
                    };
                };
            };
            if (((_local6) || (_local7)))
            {
                if (_local7)
                {
                    updateRSLModuleFactory(_arg1, _local7);
                };
                return (true);
            };
            return (false);
        }

        private static function isRSLLoaded(_arg1:IFlexModuleFactory, _arg2:String):Boolean
        {
            var _local4:Vector.<RSLData>;
            var _local5:int;
            var _local6:int;
            var _local3:Dictionary = _arg1.preloadedRSLs;
            if (_local3)
            {
                for each (_local4 in _local3)
                {
                    _local5 = _local4.length;
                    _local6 = 0;
                    while (_local6 < _local5)
                    {
                        if (_local4[_local6].digest == _arg2)
                        {
                            return (true);
                        };
                        _local6++;
                    };
                };
            };
            return (false);
        }

        private static function hasPlaceholderRSL(_arg1:IFlexModuleFactory, _arg2:String):Boolean
        {
            var _local4:int;
            var _local5:int;
            var _local6:Object;
            var _local7:int;
            var _local8:int;
            var _local3:Array = _arg1.info()["placeholderRsls"];
            if (_local3)
            {
                _local4 = _local3.length;
                _local5 = 0;
                while (_local5 < _local4)
                {
                    _local6 = _local3[_local5];
                    _local7 = _local6.length;
                    _local8 = 0;
                    while (_local8 < _local7)
                    {
                        if (_local6[_local8].digest == _arg2)
                        {
                            return (true);
                        };
                        _local8++;
                    };
                    _local5++;
                };
            };
            return (false);
        }

        private static function isLoadedIntoTopLevelApplicationDomain(_arg1:IFlexModuleFactory):Boolean
        {
            var _local2:DisplayObject;
            var _local3:LoaderInfo;
            if ((_arg1 is DisplayObject))
            {
                _local2 = DisplayObject(_arg1);
                _local3 = _local2.loaderInfo;
                if (((((_local3) && (_local3.applicationDomain))) && ((_local3.applicationDomain.parentDomain == null))))
                {
                    return (true);
                };
            };
            return (false);
        }

        private static function updateRSLModuleFactory(_arg1:Array, _arg2:IFlexModuleFactory):void
        {
            var _local3:int = _arg1.length;
            var _local4:int;
            while (_local4 < _local3)
            {
                _arg1[_local4].moduleFactory = _arg2;
                _local4++;
            };
        }

        private static function isMac():Boolean
        {
            return ((Capabilities.os.substring(0, 3) == "Mac"));
        }

        private static function dynamicURLFilter(_arg1:String, _arg2:int):String
        {
            return (_arg1.substring(0, _arg2));
        }

        private static function importURLFilter(_arg1:String, _arg2:int):String
        {
            var _local3:int = _arg1.indexOf("://");
            return ((_arg1.substring(0, (_local3 + 3)) + _arg1.substring((_arg2 + 12))));
        }


    }
}//package mx.utils
