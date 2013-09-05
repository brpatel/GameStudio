//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.utils
{
    import flash.utils.Proxy;
    import flash.utils.flash_proxy

    public dynamic class DescribeTypeCacheRecord extends Proxy 
    {

        private var cache:Object;
        public var typeDescription:XML;
        public var typeName:String;

        public function DescribeTypeCacheRecord()
        {
            this.cache = {};
            super();
        }

        override flash_proxy function getProperty(_arg1)
        {
            var _local2:* = this.cache[_arg1];
            if (_local2 === undefined)
            {
                _local2 = DescribeTypeCache.extractValue(_arg1, this);
                this.cache[_arg1] = _local2;
            };
            return (_local2);
        }

        override flash_proxy function hasProperty(_arg1):Boolean
        {
            if ((_arg1 in this.cache))
            {
                return (true);
            };
            var _local2:* = DescribeTypeCache.extractValue(_arg1, this);
            if (_local2 === undefined)
            {
                return (false);
            };
            this.cache[_arg1] = _local2;
            return (true);
        }


    }
}//package mx.utils
