//Created by Action Script Viewer - http://www.buraks.com/asv
package com.adobe.serializers.utility
{
    import flash.utils.Dictionary;
    import mx.utils.DescribeTypeCache;
    import mx.utils.ObjectUtil;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    import mx.collections.ArrayCollection;
    import mx.rpc.AbstractOperation;
    import mx.rpc.events.FaultEvent;
    import mx.collections.IList;

    public class TypeUtility 
    {

        private static var TYPE_INT:String = "int";
        private static var TYPE_STRING:String = "String";
        private static var TYPE_BOOLEAN:String = "Boolean";
        private static var TYPE_NUMBER:String = "Number";
        private static var TYPE_DATE:String = "Date";
        private static var TYPE_ARRAYCOLLECTION:String = "mx.collections::ArrayCollection";
        private static var TYPE_ARRAY:String = "Array";
        private static var propertyTypeMap:Dictionary;
        private static var arrayTypeMap:Dictionary;


        public static function getType(_arg1:Class, _arg2:String):String
        {
            var clazz:Class = _arg1;
            var propertyName:String = _arg2;
            if (!propertyTypeMap)
            {
                propertyTypeMap = new Dictionary(false);
            };
            if (!propertyTypeMap[clazz])
            {
                propertyTypeMap[clazz] = new Dictionary(false);
            };
            var type:String = propertyTypeMap[clazz][propertyName];
            if (type != null)
            {
                return (type);
            };
            var description:XML = DescribeTypeCache.describeType(new (clazz)()).typeDescription;
            type = description..*.(((name() == "variable")) || ((name() == "accessor"))).(@name == propertyName).@type;
            propertyTypeMap[clazz][propertyName] = type;
            return (type);
        }

        public static function getArrayType(_arg1:Class, _arg2:String):Class
        {
            var _local6:String;
            var _local7:Object;
            var _local8:Object;
            var _local9:String;
            if (!arrayTypeMap)
            {
                arrayTypeMap = new Dictionary(false);
            };
            if (!arrayTypeMap[_arg1])
            {
                arrayTypeMap[_arg1] = new Dictionary(false);
            };
            var _local3:Class = arrayTypeMap[_arg1][_arg2];
            if (_local3 != null)
            {
                return (_local3);
            };
            var _local4:Object = ObjectUtil.getClassInfo(_arg1, null, null);
            var _local5:Object = _local4["metadata"];
            if (((_local5.hasOwnProperty(_arg2)) && (_local5[_arg2].hasOwnProperty("ArrayElementType"))))
            {
                for each (_local6 in _local5[_arg2]["ArrayElementType"])
                {
                    _local3 = (getDefinitionByName(_local6) as Class);
                    break;
                };
            }
            else
            {
                _local7 = new (_arg1)();
                _local8 = getModel(_local7);
                if (((!((_local8 == null))) && (_local8.hasOwnProperty("getCollectionBase"))))
                {
                    _local9 = _local8.getCollectionBase(_arg2);
                    if (((!((_local9 == null))) && ((_local9.length > 0))))
                    {
                        _local3 = (getDefinitionByName(_local9) as Class);
                    };
                };
            };
            if (_local3 != null)
            {
                arrayTypeMap[_arg1][_arg2] = _local3;
            };
            return (_local3);
        }

        public static function getProperties(_arg1:Object):Array
        {
            var _local2:Object = getModel(_arg1);
            if (((!((_local2 == null))) && (_local2.hasOwnProperty("getDataProperties"))))
            {
                if (_local2.hasOwnProperty("getDataProperties"))
                {
                    return (_local2.getDataProperties());
                };
            };
            return (null);
        }

        private static function getModel(_arg1:Object):Object
        {
            var model:Object;
            var description:XML;
            var list:XMLList;
            var obj:Object = _arg1;
            if (obj.hasOwnProperty("_model"))
            {
                model = obj["_model"];
                description = DescribeTypeCache.describeType(model).typeDescription;
                list = description..implementsInterface.(@type == "com.adobe.fiber.valueobjects::IModelType");
                if (list.length() > 0)
                {
                    return (model);
                };
            };
            return (null);
        }

        public static function getXPathArray(_arg1:String):Array
        {
            if ((((((_arg1 == null)) || ((_arg1 == "")))) || ((_arg1 == "/"))))
            {
                return (null);
            };
            var _local2:Array = _arg1.split("/");
            _local2.shift();
            return (_local2);
        }

        public static function isPrimitive(_arg1:String):Boolean
        {
            return ((((((((((_arg1 == TYPE_INT)) || ((_arg1 == TYPE_STRING)))) || ((_arg1 == TYPE_BOOLEAN)))) || ((_arg1 == TYPE_NUMBER)))) || ((_arg1 == TYPE_DATE))));
        }

        public static function isDate(_arg1:String):Boolean
        {
            return ((_arg1 == TYPE_DATE));
        }

        public static function isArrayCollection(_arg1:String):Boolean
        {
            return ((_arg1 == TYPE_ARRAYCOLLECTION));
        }

        public static function isArray(_arg1:String):Boolean
        {
            return ((_arg1 == TYPE_ARRAY));
        }

        public static function getDate(_arg1:Object):Date
        {
            return (new Date(Date.parse(_arg1)));
        }

        public static function getUnderScoreName(_arg1:Class, _arg2:Object, _arg3:String):String
        {
            if (((((_arg1) && (!(_arg2.hasOwnProperty(_arg3))))) && (_arg2.hasOwnProperty(("_" + _arg3)))))
            {
                return (("_" + _arg3));
            };
            return (_arg3);
        }

        public static function clear():void
        {
            propertyTypeMap = null;
            arrayTypeMap = null;
        }

        private static function isObject(_arg1:Object):Boolean
        {
            return ((((getQualifiedClassName(_arg1) == "Object")) || ((getQualifiedClassName(_arg1) == "mx.utils::ObjectProxy"))));
        }

        public static function convertResultHandler(_arg1, _arg2:AbstractOperation)
        {
            var _local4:String;
            if (((((!((_arg2.properties == null))) && (_arg2.properties.hasOwnProperty("singleValueResult")))) && ((_arg2.properties["singleValueResult"] == true))))
            {
                if (isObject(_arg1))
                {
                    for (_local4 in _arg1)
                    {
                        _arg1 = _arg1[_local4];
                        break;
                    };
                };
            };
            var _local3:* = _arg1;
            if (((((!((_arg2.resultElementType == null))) && (!(isObject(_arg2.resultElementType))))) && (!((_arg1 == null)))))
            {
                if ((((((((_arg1 is ArrayCollection)) || ((_arg1 is Array)))) && ((_arg1.length > 0)))) && (((isObject(_arg1[0])) || ((_arg1[0] is Array))))))
                {
                    _local3 = convertListToStrongType(_arg1, _arg2.resultElementType);
                };
            }
            else
            {
                if (((((((!((_arg2.resultType == null))) && (!(isObject(_arg2.resultType))))) && (!((_arg1 == null))))) && (((isObject(_arg1)) || ((_arg1 is Array))))))
                {
                    _local3 = convertToStrongType(_arg1, _arg2.resultType);
                };
            };
            clear();
            if ((_local3 is Array))
            {
                _local3 = new ArrayCollection((_local3 as Array));
            };
            return (_local3);
        }

        public static function convertCFAMFParametersHandler(_arg1:Array):Array
        {
            if (((!((_arg1 == null))) && ((_arg1.length == 1))))
            {
                if ((((((((((((_arg1[0] is int)) || ((_arg1[0] is uint)))) || ((_arg1[0] is Number)))) || ((_arg1[0] is String)))) || ((_arg1[0] is Date)))) || ((_arg1[0] is Boolean))))
                {
                    return (_arg1);
                };
                return (_arg1.concat(null));
            };
            return (_arg1);
        }

        public static function emptyEventHandler(_arg1:FaultEvent, _arg2:AbstractOperation):void
        {
        }

        public static function convertListToStrongType(_arg1:Object, _arg2:Class, _arg3:Dictionary=null):Object
        {
            if (!(((_arg1 is ArrayCollection)) || ((_arg1 is Array))))
            {
                return (_arg1);
            };
            if (_arg3 == null)
            {
                _arg3 = new Dictionary();
            };
            if (_arg3[_arg1] != null)
            {
                return (_arg3[_arg1]);
            };
            var _local4:Array = [];
            var _local5:int;
            while (_local5 < _arg1.length)
            {
                if (_arg3[_arg1[_local5]] == null)
                {
                    _local4[_local5] = convertToStrongType(_arg1[_local5], _arg2, _arg3);
                    _arg3[_arg1[_local5]] = _local4[_local5];
                }
                else
                {
                    _local4[_local5] = _arg3[_arg1[_local5]];
                };
                _local5++;
            };
            var _local6:ArrayCollection = new ArrayCollection(_local4);
            _arg3[_arg1] = _local6;
            return (_local6);
        }

        public static function convertToStrongType(_arg1:Object, _arg2:Class, _arg3:Dictionary=null):Object
        {
            var _local5:String;
            if (_arg2 == null)
            {
                return (_arg1);
            };
            if (_arg3 == null)
            {
                _arg3 = new Dictionary();
            };
            if (_arg3[_arg1] != null)
            {
                return (_arg3[_arg1]);
            };
            if ((_arg1 is _arg2))
            {
                return (_arg1);
            };
            var _local4:Object = new (_arg2)();
            for (_local5 in _arg1)
            {
                assignProperty(_arg1, _local4, _local5, _arg2, _arg3);
            };
            _arg3[_arg1] = _local4;
            return (_local4);
        }

        private static function assignProperty(_arg1:Object, _arg2:Object, _arg3:String, _arg4:Class, _arg5:Dictionary):void
        {
            var _local6:String = getUnderScoreName(_arg4, _arg2, _arg3);
            var _local7:Class = _arg4;
            var _local8:String = TypeUtility.getType(_arg4, _local6);
            var _local9:Boolean = TypeUtility.isPrimitive(_local8);
            var _local10:Boolean = TypeUtility.isArray(_local8);
            var _local11:Boolean = TypeUtility.isArrayCollection(_local8);
            if (((_local10) || (_local11)))
            {
                _local10 = true;
                _local7 = TypeUtility.getArrayType(_arg4, _local6);
            }
            else
            {
                if (((((!((_local8 == null))) && ((_local8.length > 0)))) && (!(_local9))))
                {
                    _local7 = (getDefinitionByName(_local8) as Class);
                };
            };
            if (_arg2.hasOwnProperty(_local6))
            {
                if (((_local9) || (isObject(_local7))))
                {
                    if ((((_local8 == TYPE_NUMBER)) && ((_arg1[_arg3] == null))))
                    {
                        _arg2[_local6] = Number.NaN;
                    }
                    else
                    {
                        _arg2[_local6] = _arg1[_arg3];
                    };
                }
                else
                {
                    if (((_local11) || (_local10)))
                    {
                        if (_arg1[_arg3] == null)
                        {
                            _arg2[_local6] = null;
                            return;
                        };
                        if (_arg5[_arg1[_arg3]] == null)
                        {
                            _arg2[_local6] = convertListToStrongType(_arg1[_arg3], _local7, _arg5);
                            _arg5[_arg1[_arg3]] = _arg2[_local6];
                        }
                        else
                        {
                            _arg2[_local6] = _arg5[_arg1[_arg3]];
                        };
                    }
                    else
                    {
                        if (_arg1[_arg3] == null)
                        {
                            _arg2[_local6] = null;
                            return;
                        };
                        if (_arg5[_arg1[_arg3]] == null)
                        {
                            _arg2[_local6] = convertToStrongType(_arg1[_arg3], _local7, _arg5);
                            _arg5[_arg1[_arg3]] = _arg2[_local6];
                        }
                        else
                        {
                            _arg2[_local6] = _arg5[_arg1[_arg3]];
                        };
                    };
                };
            };
        }

        public static function convertToCollection(_arg1:Object):IList
        {
            if (_arg1 == null)
            {
                return (null);
            };
            if ((_arg1 is ArrayCollection))
            {
                return ((_arg1 as ArrayCollection));
            };
            if ((_arg1 is Array))
            {
                return (new ArrayCollection((_arg1 as Array)));
            };
            return (new ArrayCollection([_arg1]));
        }


    }
}//package com.adobe.serializers.utility
