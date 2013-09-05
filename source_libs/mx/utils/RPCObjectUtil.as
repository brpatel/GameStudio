//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.utils
{
    import mx.core.mx_internal;
    import flash.xml.XMLNode;
    import flash.utils.getQualifiedClassName;
    import flash.utils.Dictionary;
    import flash.utils.describeType;

    use namespace mx_internal;

    public class RPCObjectUtil 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        private static var defaultToStringExcludes:Array = ["password", "credentials"];
        private static var refCount:int = 0;
        private static var CLASS_INFO_CACHE:Object = {};


        public static function toString(_arg1:Object, _arg2:Array=null, _arg3:Array=null):String
        {
            if (_arg3 == null)
            {
                _arg3 = defaultToStringExcludes;
            };
            refCount = 0;
            return (internalToString(_arg1, 0, null, _arg2, _arg3));
        }

        private static function internalToString(_arg1:Object, _arg2:int=0, _arg3:Dictionary=null, _arg4:Array=null, _arg5:Array=null):String
        {
            var str:String;
            var classInfo:Object;
            var properties:Array;
            var id:Object;
            var isArray:Boolean;
            var prop:* = undefined;
            var j:int;
            var value:Object = _arg1;
            var indent:int = _arg2;
            var refs = _arg3;
            var namespaceURIs = _arg4;
            var exclude = _arg5;
            var type:String = (((value == null)) ? "null" : typeof(value));
            switch (type)
            {
                case "boolean":
                case "number":
                    return (value.toString());
                case "string":
                    return ((('"' + value.toString()) + '"'));
                case "object":
                    if ((value is Date))
                    {
                        return (value.toString());
                    };
                    if ((value is XMLNode))
                    {
                        return (value.toString());
                    };
                    if ((value is Class))
                    {
                        return ((("(" + getQualifiedClassName(value)) + ")"));
                    };
                    classInfo = getClassInfo(value, exclude, {
                        includeReadOnly:true,
                        uris:namespaceURIs
                    });
                    properties = classInfo.properties;
                    str = (("(" + classInfo.name) + ")");
                    if (refs == null)
                    {
                        refs = new Dictionary(true);
                    };
                    id = refs[value];
                    if (id != null)
                    {
                        str = (str + ("#" + int(id)));
                        return (str);
                    };
                    if (value != null)
                    {
                        str = (str + ("#" + refCount.toString()));
                        refs[value] = refCount;
                        refCount++;
                    };
                    isArray = (value is Array);
                    indent = (indent + 2);
                    j = 0;
                    while (j < properties.length)
                    {
                        str = newline(str, indent);
                        prop = properties[j];
                        if (isArray)
                        {
                            str = (str + "[");
                        };
                        str = (str + prop.toString());
                        if (isArray)
                        {
                            str = (str + "] ");
                        }
                        else
                        {
                            str = (str + " = ");
                        };
                        try
                        {
                            str = (str + internalToString(value[prop], indent, refs, namespaceURIs, exclude));
                        }
                        catch(e:Error)
                        {
                            str = (str + "?");
                        };
                        j = (j + 1);
                    };
                    indent = (indent - 2);
                    return (str);
                case "xml":
                    return (value.toString());
                default:
                    return ((("(" + type) + ")"));
            };
        }

        private static function newline(_arg1:String, _arg2:int=0):String
        {
            var _local3:String = _arg1;
            _local3 = (_local3 + "\n");
            var _local4:int;
            while (_local4 < _arg2)
            {
                _local3 = (_local3 + " ");
                _local4++;
            };
            return (_local3);
        }

        public static function getClassInfo(_arg1:Object, _arg2:Array=null, _arg3:Object=null):Object
        {
            var n:int;
            var i:int;
            var result:Object;
            var cacheKey:String;
            var className:String;
            var classAlias:String;
            var properties:XMLList;
            var prop:XML;
            var metadataInfo:Object;
            var classInfo:XML;
            var numericIndex:Boolean;
            var p:String;
            var pi:Number;
            var uris:Array;
            var uri:String;
            var qName:QName;
            var j:int;
            var obj:Object = _arg1;
            var excludes = _arg2;
            var options = _arg3;
            if (options == null)
            {
                options = {
                    includeReadOnly:true,
                    uris:null,
                    includeTransient:true
                };
            };
            var propertyNames:Array = [];
            var dynamic:Boolean;
            if (typeof(obj) == "xml")
            {
                className = "XML";
                properties = obj.text();
                if (properties.length())
                {
                    propertyNames.push("*");
                };
                properties = obj.attributes();
            }
            else
            {
                classInfo = describeType(obj);
                className = classInfo.@name.toString();
                classAlias = classInfo.@alias.toString();
                dynamic = (classInfo.@isDynamic.toString() == "true");
                if (options.includeReadOnly)
                {
                    properties = (classInfo..accessor.(@access != "writeonly") + classInfo..variable);
                }
                else
                {
                    properties = (classInfo..accessor.(@access == "readwrite") + classInfo..variable);
                };
                numericIndex = false;
            };
            if (!dynamic)
            {
                cacheKey = getCacheKey(obj, excludes, options);
                result = CLASS_INFO_CACHE[cacheKey];
                if (result != null)
                {
                    return (result);
                };
            };
            result = {};
            result["name"] = className;
            result["alias"] = classAlias;
            result["properties"] = propertyNames;
            result["dynamic"] = dynamic;
            var _local5 = recordMetadata(properties);
            metadataInfo = _local5;
            result["metadata"] = _local5;
            var excludeObject:Object = {};
            if (excludes)
            {
                n = excludes.length;
                i = 0;
                while (i < n)
                {
                    excludeObject[excludes[i]] = 1;
                    i = (i + 1);
                };
            };
            var isArray:Boolean = (className == "Array");
            if (dynamic)
            {
                for (p in obj)
                {
                    if (excludeObject[p] != 1)
                    {
                        if (isArray)
                        {
                            pi = parseInt(p);
                            if (isNaN(pi))
                            {
                                propertyNames.push(new QName("", p));
                            }
                            else
                            {
                                propertyNames.push(pi);
                            };
                        }
                        else
                        {
                            propertyNames.push(new QName("", p));
                        };
                    };
                };
                numericIndex = ((isArray) && (!(isNaN(Number(p)))));
            };
            if (!(((className == "Object")) || (isArray)))
            {
                if (className == "XML")
                {
                    n = properties.length();
                    i = 0;
                    while (i < n)
                    {
                        p = properties[i].name();
                        if (excludeObject[p] != 1)
                        {
                            propertyNames.push(new QName("", ("@" + p)));
                        };
                        i = (i + 1);
                    };
                }
                else
                {
                    n = properties.length();
                    uris = options.uris;
                    i = 0;
                    while (i < n)
                    {
                        prop = properties[i];
                        p = prop.@name.toString();
                        uri = prop.@uri.toString();
                        if (excludeObject[p] != 1)
                        {
                            if (!((!(options.includeTransient)) && (internalHasMetadata(metadataInfo, p, "Transient"))))
                            {
                                if (uris != null)
                                {
                                    if ((((uris.length == 1)) && ((uris[0] == "*"))))
                                    {
                                        qName = new QName(uri, p);
                                        try
                                        {
                                            obj[qName];
                                            propertyNames.push();
                                        }
                                        catch(e:Error)
                                        {
                                        };
                                    }
                                    else
                                    {
                                        j = 0;
                                        while (j < uris.length)
                                        {
                                            uri = uris[j];
                                            if (prop.@uri.toString() == uri)
                                            {
                                                qName = new QName(uri, p);
                                                try
                                                {
                                                    obj[qName];
                                                    propertyNames.push(qName);
                                                }
                                                catch(e:Error)
                                                {
                                                };
                                            };
                                            j = (j + 1);
                                        };
                                    };
                                }
                                else
                                {
                                    if (uri.length == 0)
                                    {
                                        qName = new QName(uri, p);
                                        try
                                        {
                                            obj[qName];
                                            propertyNames.push(qName);
                                        }
                                        catch(e:Error)
                                        {
                                        };
                                    };
                                };
                            };
                        };
                        i = (i + 1);
                    };
                };
            };
            propertyNames.sort((Array.CASEINSENSITIVE | ((numericIndex) ? Array.NUMERIC : 0)));
            i = 0;
            while (i < (propertyNames.length - 1))
            {
                if (propertyNames[i].toString() == propertyNames[(i + 1)].toString())
                {
                    propertyNames.splice(i, 1);
                    i = (i - 1);
                };
                i = (i + 1);
            };
            if (!dynamic)
            {
                cacheKey = getCacheKey(obj, excludes, options);
                CLASS_INFO_CACHE[cacheKey] = result;
            };
            return (result);
        }

        private static function internalHasMetadata(_arg1:Object, _arg2:String, _arg3:String):Boolean
        {
            var _local4:Object;
            if (_arg1 != null)
            {
                _local4 = _arg1[_arg2];
                if (_local4 != null)
                {
                    if (_local4[_arg3] != null)
                    {
                        return (true);
                    };
                };
            };
            return (false);
        }

        private static function recordMetadata(_arg1:XMLList):Object
        {
            var _local3:XML;
            var _local4:String;
            var _local5:XMLList;
            var _local6:Object;
            var _local7:XML;
            var _local8:String;
            var _local9:XMLList;
            var _local10:Object;
            var _local11:XML;
            var _local12:Object;
            var _local13:String;
            var _local14:String;
            var _local15:Array;
            var _local2:Object;
            try
            {
                for each (_local3 in _arg1)
                {
                    _local4 = _local3.attribute("name").toString();
                    _local5 = _local3.metadata;
                    if (_local5.length() > 0)
                    {
                        if (_local2 == null)
                        {
                            _local2 = {};
                        };
                        _local6 = {};
                        _local2[_local4] = _local6;
                        for each (_local7 in _local5)
                        {
                            _local8 = _local7.attribute("name").toString();
                            _local9 = _local7.arg;
                            _local10 = {};
                            for each (_local11 in _local9)
                            {
                                _local13 = _local11.attribute("key").toString();
                                if (_local13 != null)
                                {
                                    _local14 = _local11.attribute("value").toString();
                                    _local10[_local13] = _local14;
                                };
                            };
                            _local12 = _local6[_local8];
                            if (_local12 != null)
                            {
                                if ((_local12 is Array))
                                {
                                    _local15 = (_local12 as Array);
                                }
                                else
                                {
                                    _local15 = [];
                                };
                                _local15.push(_local10);
                                _local12 = _local15;
                            }
                            else
                            {
                                _local12 = _local10;
                            };
                            _local6[_local8] = _local12;
                        };
                    };
                };
            }
            catch(e:Error)
            {
            };
            return (_local2);
        }

        private static function getCacheKey(_arg1:Object, _arg2:Array=null, _arg3:Object=null):String
        {
            var _local5:uint;
            var _local6:String;
            var _local7:String;
            var _local8:String;
            var _local4:String = getQualifiedClassName(_arg1);
            if (_arg2 != null)
            {
                _local5 = 0;
                while (_local5 < _arg2.length)
                {
                    _local6 = (_arg2[_local5] as String);
                    if (_local6 != null)
                    {
                        _local4 = (_local4 + _local6);
                    };
                    _local5++;
                };
            };
            if (_arg3 != null)
            {
                for (_local7 in _arg3)
                {
                    _local4 = (_local4 + _local7);
                    _local8 = (_arg3[_local7] as String);
                    if (_local8 != null)
                    {
                        _local4 = (_local4 + _local8);
                    };
                };
            };
            return (_local4);
        }


    }
}//package mx.utils
