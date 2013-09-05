//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging.config
{
    import flash.utils.Proxy;
    import mx.utils.object_proxy;
    import flash.utils.flash_proxy

    use namespace object_proxy;

    public dynamic class ConfigMap extends Proxy 
    {

        object_proxy var propertyList:Array;
        private var _item:Object;

        public function ConfigMap(_arg1:Object=null)
        {
            if (!_arg1)
            {
                _arg1 = {};
            };
            this._item = _arg1;
            this.propertyList = [];
        }

        override flash_proxy function getProperty(_arg1)
        {
            var _local2:Object;
            _local2 = this._item[_arg1];
            return (_local2);
        }

        override flash_proxy function callProperty(_arg1, ... _args)
        {
            return (this._item[_arg1].apply(this._item, _args));
        }

        override flash_proxy function deleteProperty(_arg1):Boolean
        {
            var _local2:Object = this._item[_arg1];
            var _local3 = delete this._item[_arg1];
            var _local4:int = -1;
            var _local5:int;
            while (_local5 < this.propertyList.length)
            {
                if (this.propertyList[_local5] == _arg1)
                {
                    _local4 = _local5;
                    break;
                };
                _local5++;
            };
            if (_local4 > -1)
            {
                this.propertyList.splice(_local4, 1);
            };
            return (_local3);
        }

        override flash_proxy function hasProperty(_arg1):Boolean
        {
            return ((_arg1 in this._item));
        }

        override flash_proxy function nextName(_arg1:int):String
        {
            return (this.propertyList[(_arg1 - 1)]);
        }

        override flash_proxy function nextNameIndex(_arg1:int):int
        {
            if (_arg1 < this.propertyList.length)
            {
                return ((_arg1 + 1));
            };
            return (0);
        }

        override flash_proxy function nextValue(_arg1:int)
        {
            return (this._item[this.propertyList[(_arg1 - 1)]]);
        }

        override flash_proxy function setProperty(_arg1, _arg2):void
        {
            var _local4:int;
            var _local3:* = this._item[_arg1];
            if (_local3 !== _arg2)
            {
                this._item[_arg1] = _arg2;
                _local4 = 0;
                while (_local4 < this.propertyList.length)
                {
                    if (this.propertyList[_local4] == _arg1)
                    {
                        return;
                    };
                    _local4++;
                };
                this.propertyList.push(_arg1);
            };
        }


    }
}//package mx.messaging.config
