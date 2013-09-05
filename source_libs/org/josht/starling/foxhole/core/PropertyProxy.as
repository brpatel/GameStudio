//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.core
{
    import flash.utils.Proxy;
    import org.osflash.signals.Signal;
    import org.osflash.signals.ISignal;
    import flash.utils.flash_proxy

    public dynamic class PropertyProxy extends Proxy 
    {

        private var _names:Array;
        private var _storage:Object;
        private var _onChange:Signal;

        public function PropertyProxy(_arg1:Function=null)
        {
            this._names = [];
            this._storage = {};
            this._onChange = new Signal(PropertyProxy, Object);
            super();
            if (_arg1 != null)
            {
                this._onChange.add(_arg1);
            };
        }

        public static function fromObject(_arg1:Object, _arg2:Function=null):PropertyProxy
        {
            var _local4:String;
            var _local3:PropertyProxy = new PropertyProxy(_arg2);
            for (_local4 in _arg1)
            {
                _local3[_local4] = _arg1[_local4];
            };
            return (_local3);
        }


        public function get onChange():ISignal
        {
            return (this._onChange);
        }

        override flash_proxy function hasProperty(_arg1):Boolean
        {
            return (this._storage.hasOwnProperty(_arg1));
        }

        override flash_proxy function getProperty(_arg1)
        {
            var _local2:String;
            if (this.isAttribute(_arg1))
            {
                _local2 = (((_arg1 is QName)) ? QName(_arg1).localName : _arg1.toString());
                if (!this._storage.hasOwnProperty(_local2))
                {
                    this._storage[_local2] = new PropertyProxy();
                    this._names.push(_local2);
                    this._onChange.dispatch(this, _local2);
                };
                return (this._storage[_local2]);
            };
            return (this._storage[_arg1]);
        }

        override flash_proxy function setProperty(_arg1, _arg2):void
        {
            this._storage[_arg1] = _arg2;
            if (this._names.indexOf(_arg1) < 0)
            {
                this._names.push(_arg1);
            };
            this._onChange.dispatch(this, _arg1);
        }

        override flash_proxy function deleteProperty(_arg1):Boolean
        {
            var _local2:int = this._names.indexOf(_arg1);
            if (_local2 >= 0)
            {
                this._names.splice(_local2, 1);
            };
            var _local3 = delete this._storage[_arg1];
            if (_local3)
            {
                this._onChange.dispatch(this, _arg1);
            };
            return (_local3);
        }

        override flash_proxy function nextNameIndex(_arg1:int):int
        {
            if (_arg1 < this._names.length)
            {
                return ((_arg1 + 1));
            };
            return (0);
        }

        override flash_proxy function nextName(_arg1:int):String
        {
            return (this._names[(_arg1 - 1)]);
        }

        override flash_proxy function nextValue(_arg1:int)
        {
            var _local2:* = this._names[(_arg1 - 1)];
            return (this._storage[_local2]);
        }
		
		override flash_proxy function callProperty(methodName:*, ... args):* {
			
			/*var res:*;
			res = _names[methodName].apply(_names, args);
			return res;*/
		}


    }
}//package org.josht.starling.foxhole.core
