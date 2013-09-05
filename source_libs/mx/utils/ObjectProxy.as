//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.utils
{
    import flash.utils.Proxy;
    import flash.events.EventDispatcher;
    import mx.events.PropertyChangeEvent;
    import mx.core.IPropertyChangeNotifier;
    import mx.events.PropertyChangeEventKind;
    import flash.utils.getQualifiedClassName;
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    import flash.events.Event;
    import flash.utils.*;
    import mx.core.*;
    import flash.utils.flash_proxy

    [Bindable("propertyChange")]
    public dynamic class ObjectProxy extends Proxy implements IExternalizable, IPropertyChangeNotifier 
    {

        protected var dispatcher:EventDispatcher;
        protected var notifiers:Object;
        protected var proxyClass:Class;
        protected var propertyList:Array;
        private var _proxyLevel:int;
        private var _item:Object;
        private var _type:QName;
        private var _id:String;

        public function ObjectProxy(_arg1:Object=null, _arg2:String=null, _arg3:int=-1)
        {
            this.proxyClass = ObjectProxy;
            super();
            if (!_arg1)
            {
                _arg1 = {};
            };
            this._item = _arg1;
            this._proxyLevel = _arg3;
            this.notifiers = {};
            this.dispatcher = new EventDispatcher(this);
            if (_arg2)
            {
                this._id = _arg2;
            };
        }

        object_proxy function get object():Object
        {
            return (this._item);
        }

        object_proxy function get type():QName
        {
            return (this._type);
        }

        object_proxy function set type(_arg1:QName):void
        {
            this._type = _arg1;
        }

        public function get uid():String
        {
            if (this._id === null)
            {
                this._id = UIDUtil.createUID();
            };
            return (this._id);
        }

        public function set uid(_arg1:String):void
        {
            this._id = _arg1;
        }

        override flash_proxy function getProperty(_arg1)
        {
            var _local2:*;
            if (this.notifiers[_arg1.toString()])
            {
                return (this.notifiers[_arg1]);
            };
            _local2 = this._item[_arg1];
            if (_local2)
            {
                if ((((this._proxyLevel == 0)) || (ObjectUtil.isSimple(_local2))))
                {
                    return (_local2);
                };
                _local2 = this.getComplexProperty(_arg1, _local2);
            };
            return (_local2);
        }

        override flash_proxy function callProperty(_arg1, ... _args)
        {
            return (this._item[_arg1].apply(this._item, _args));
        }

        override flash_proxy function deleteProperty(_arg1):Boolean
        {
            var _local5:PropertyChangeEvent;
            var _local2:IPropertyChangeNotifier = IPropertyChangeNotifier(this.notifiers[_arg1]);
            if (_local2)
            {
                _local2.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this.propertyChangeHandler);
                delete this.notifiers[_arg1];
            };
            var _local3:* = this._item[_arg1];
            var _local4 = delete this._item[_arg1];
            if (this.dispatcher.hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
            {
                _local5 = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
                _local5.kind = PropertyChangeEventKind.DELETE;
                _local5.property = _arg1;
                _local5.oldValue = _local3;
                _local5.source = this;
                this.dispatcher.dispatchEvent(_local5);
            };
            return (_local4);
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
            if (_arg1 == 0)
            {
                this.setupPropertyList();
            };
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
            var _local4:IPropertyChangeNotifier;
            var _local5:PropertyChangeEvent;
            var _local3:* = this._item[_arg1];
            if (_local3 !== _arg2)
            {
                this._item[_arg1] = _arg2;
                _local4 = IPropertyChangeNotifier(this.notifiers[_arg1]);
                if (_local4)
                {
                    _local4.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this.propertyChangeHandler);
                    delete this.notifiers[_arg1];
                };
                if (this.dispatcher.hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
                {
                    if ((_arg1 is QName))
                    {
                        _arg1 = QName(_arg1).localName;
                    };
                    _local5 = PropertyChangeEvent.createUpdateEvent(this, _arg1.toString(), _local3, _arg2);
                    this.dispatcher.dispatchEvent(_local5);
                };
            };
        }

        object_proxy function getComplexProperty(_arg1, _arg2)
        {
            if ((_arg2 is IPropertyChangeNotifier))
            {
                _arg2.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this.propertyChangeHandler);
                this.notifiers[_arg1] = _arg2;
                return (_arg2);
            };
            if (getQualifiedClassName(_arg2) == "Object")
            {
                _arg2 = new this.proxyClass(this._item[_arg1], null, (((this._proxyLevel > 0)) ? (this._proxyLevel - 1) : this._proxyLevel));
                _arg2.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this.propertyChangeHandler);
                this.notifiers[_arg1] = _arg2;
                return (_arg2);
            };
            return (_arg2);
        }

        public function readExternal(_arg1:IDataInput):void
        {
            var _local2:Object = _arg1.readObject();
            this._item = _local2;
        }

        public function writeExternal(_arg1:IDataOutput):void
        {
            _arg1.writeObject(this._item);
        }

        public function addEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false, _arg4:int=0, _arg5:Boolean=false):void
        {
            this.dispatcher.addEventListener(_arg1, _arg2, _arg3, _arg4, _arg5);
        }

        public function removeEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false):void
        {
            this.dispatcher.removeEventListener(_arg1, _arg2, _arg3);
        }

        public function dispatchEvent(_arg1:Event):Boolean
        {
            return (this.dispatcher.dispatchEvent(_arg1));
        }

        public function hasEventListener(_arg1:String):Boolean
        {
            return (this.dispatcher.hasEventListener(_arg1));
        }

        public function willTrigger(_arg1:String):Boolean
        {
            return (this.dispatcher.willTrigger(_arg1));
        }

        public function propertyChangeHandler(_arg1:PropertyChangeEvent):void
        {
            this.dispatcher.dispatchEvent(_arg1);
        }

        protected function setupPropertyList():void
        {
            var _local1:String;
            if (getQualifiedClassName(this._item) == "Object")
            {
                this.propertyList = [];
                for (_local1 in this._item)
                {
                    this.propertyList.push(_local1);
                };
            }
            else
            {
                this.propertyList = ObjectUtil.getClassInfo(this._item, null, {
                    includeReadOnly:true,
                    uris:["*"]
                }).properties;
            };
        }


    }
}//package mx.utils
