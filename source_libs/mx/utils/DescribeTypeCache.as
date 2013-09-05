//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.utils
{
    import mx.core.mx_internal;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getDefinitionByName;
    import flash.utils.describeType;
    import mx.binding.BindabilityInfo;

    use namespace mx_internal;

    public class DescribeTypeCache 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        private static var typeCache:Object = {};
        private static var cacheHandlers:Object = {};

        {
            registerCacheHandler("bindabilityInfo", bindabilityInfoHandler);
        }


        public static function describeType(_arg1):DescribeTypeCacheRecord
        {
            var _local2:String;
            var _local3:String;
            var _local4:XML;
            var _local5:DescribeTypeCacheRecord;
            if ((_arg1 is String))
            {
                _local2 = _arg1;
                _local3 = _local2;
            }
            else
            {
                _local2 = getQualifiedClassName(_arg1);
                _local3 = _local2;
            };
            if ((_arg1 is Class))
            {
                _local3 = (_local3 + "$");
            };
            if ((_local3 in typeCache))
            {
                return (typeCache[_local3]);
            };
            if ((_arg1 is String))
            {
                try
                {
                    _arg1 = getDefinitionByName(_arg1);
                }
                catch(error:ReferenceError)
                {
                };
            };
            _local4 = describeType(_arg1) as XML;
            _local5 = new DescribeTypeCacheRecord();
            _local5.typeDescription = _local4;
            _local5.typeName = _local2;
            typeCache[_local3] = _local5;
            return (_local5);
        }

        public static function registerCacheHandler(_arg1:String, _arg2:Function):void
        {
            cacheHandlers[_arg1] = _arg2;
        }

        static function extractValue(_arg1:String, _arg2:DescribeTypeCacheRecord)
        {
            if ((_arg1 in cacheHandlers))
            {
                return (cacheHandlers[_arg1](_arg2));
            };
            return (undefined);
        }

        private static function bindabilityInfoHandler(_arg1:DescribeTypeCacheRecord)
        {
            return (new BindabilityInfo(_arg1.typeDescription));
        }


    }
}//package mx.utils
