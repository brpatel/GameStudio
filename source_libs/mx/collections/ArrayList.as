//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.collections
{
    import flash.events.EventDispatcher;
    import mx.core.mx_internal;
    import mx.resources.IResourceManager;
    import mx.resources.ResourceManager;
    import mx.utils.UIDUtil;
    import mx.events.CollectionEvent;
    import mx.events.CollectionEventKind;
    import mx.events.PropertyChangeEvent;
    import mx.events.PropertyChangeEventKind;
    import mx.utils.ArrayUtil;
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    import flash.utils.getQualifiedClassName;
    import flash.events.IEventDispatcher;
    import flash.utils.*;
    import mx.core.*;

    use namespace mx_internal;

    public class ArrayList extends EventDispatcher implements IList, IExternalizable, IPropertyChangeNotifier 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        private var resourceManager:IResourceManager;
        private var _dispatchEvents:int = 0;
        private var _source:Array;
        private var _uid:String;

        public function ArrayList(_arg1:Array=null)
        {
            this.resourceManager = ResourceManager.getInstance();
            super();
            this.disableEvents();
            this.source = _arg1;
            this.enableEvents();
            this._uid = UIDUtil.createUID();
        }

        [Bindable("collectionChange")]
        public function get length():int
        {
            if (this.source)
            {
                return (this.source.length);
            };
            return (0);
        }

        public function get source():Array
        {
            return (this._source);
        }

        public function set source(_arg1:Array):void
        {
            var _local2:int;
            var _local3:int;
            var _local4:CollectionEvent;
            if (((this._source) && (this._source.length)))
            {
                _local3 = this._source.length;
                _local2 = 0;
                while (_local2 < _local3)
                {
                    this.stopTrackUpdates(this._source[_local2]);
                    _local2++;
                };
            };
            this._source = ((_arg1) ? _arg1 : []);
            _local3 = this._source.length;
            _local2 = 0;
            while (_local2 < _local3)
            {
                this.startTrackUpdates(this._source[_local2]);
                _local2++;
            };
            if (this._dispatchEvents == 0)
            {
                _local4 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                _local4.kind = CollectionEventKind.RESET;
                dispatchEvent(_local4);
            };
        }

        public function get uid():String
        {
            return (this._uid);
        }

        public function set uid(_arg1:String):void
        {
            this._uid = _arg1;
        }

        public function getItemAt(_arg1:int, _arg2:int=0):Object
        {
            var _local3:String;
            if ((((_arg1 < 0)) || ((_arg1 >= this.length))))
            {
                _local3 = this.resourceManager.getString("collections", "outOfBounds", [_arg1]);
                throw (new RangeError(_local3));
            };
            return (this.source[_arg1]);
        }

        public function setItemAt(_arg1:Object, _arg2:int):Object
        {
            var _local4:String;
            var _local5:Boolean;
            var _local6:Boolean;
            var _local7:PropertyChangeEvent;
            var _local8:CollectionEvent;
            if ((((_arg2 < 0)) || ((_arg2 >= this.length))))
            {
                _local4 = this.resourceManager.getString("collections", "outOfBounds", [_arg2]);
                throw (new RangeError(_local4));
            };
            var _local3:Object = this.source[_arg2];
            this.source[_arg2] = _arg1;
            this.stopTrackUpdates(_local3);
            this.startTrackUpdates(_arg1);
            if (this._dispatchEvents == 0)
            {
                _local5 = hasEventListener(CollectionEvent.COLLECTION_CHANGE);
                _local6 = hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE);
                if (((_local5) || (_local6)))
                {
                    _local7 = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
                    _local7.kind = PropertyChangeEventKind.UPDATE;
                    _local7.oldValue = _local3;
                    _local7.newValue = _arg1;
                    _local7.property = _arg2;
                };
                if (_local5)
                {
                    _local8 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                    _local8.kind = CollectionEventKind.REPLACE;
                    _local8.location = _arg2;
                    _local8.items.push(_local7);
                    dispatchEvent(_local8);
                };
                if (_local6)
                {
                    dispatchEvent(_local7);
                };
            };
            return (_local3);
        }

        public function addItem(_arg1:Object):void
        {
            this.addItemAt(_arg1, this.length);
        }

        public function addItemAt(_arg1:Object, _arg2:int):void
        {
            var _local3:String;
            if ((((_arg2 < 0)) || ((_arg2 > this.length))))
            {
                _local3 = this.resourceManager.getString("collections", "outOfBounds", [_arg2]);
                throw (new RangeError(_local3));
            };
            this.source.splice(_arg2, 0, _arg1);
            this.startTrackUpdates(_arg1);
            this.internalDispatchEvent(CollectionEventKind.ADD, _arg1, _arg2);
        }

        public function addAll(_arg1:IList):void
        {
            this.addAllAt(_arg1, this.length);
        }

        public function addAllAt(_arg1:IList, _arg2:int):void
        {
            var _local3:int = _arg1.length;
            var _local4:int;
            while (_local4 < _local3)
            {
                this.addItemAt(_arg1.getItemAt(_local4), (_local4 + _arg2));
                _local4++;
            };
        }

        public function getItemIndex(_arg1:Object):int
        {
            return (ArrayUtil.getItemIndex(_arg1, this.source));
        }

        public function removeItem(_arg1:Object):Boolean
        {
            var _local2:int = this.getItemIndex(_arg1);
            var _local3 = (_local2 >= 0);
            if (_local3)
            {
                this.removeItemAt(_local2);
            };
            return (_local3);
        }

        public function removeItemAt(_arg1:int):Object
        {
            var _local3:String;
            if ((((_arg1 < 0)) || ((_arg1 >= this.length))))
            {
                _local3 = this.resourceManager.getString("collections", "outOfBounds", [_arg1]);
                throw (new RangeError(_local3));
            };
            var _local2:Object = this.source.splice(_arg1, 1)[0];
            this.stopTrackUpdates(_local2);
            this.internalDispatchEvent(CollectionEventKind.REMOVE, _local2, _arg1);
            return (_local2);
        }

        public function removeAll():void
        {
            var _local1:int;
            var _local2:int;
            if (this.length > 0)
            {
                _local1 = this.length;
                _local2 = 0;
                while (_local2 < _local1)
                {
                    this.stopTrackUpdates(this.source[_local2]);
                    _local2++;
                };
                this.source.splice(0, this.length);
                this.internalDispatchEvent(CollectionEventKind.RESET);
            };
        }

        public function itemUpdated(_arg1:Object, _arg2:Object=null, _arg3:Object=null, _arg4:Object=null):void
        {
            var _local5:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _local5.kind = PropertyChangeEventKind.UPDATE;
            _local5.source = _arg1;
            _local5.property = _arg2;
            _local5.oldValue = _arg3;
            _local5.newValue = _arg4;
            this.itemUpdateHandler(_local5);
        }

        public function toArray():Array
        {
            return (this.source.concat());
        }

        public function readExternal(_arg1:IDataInput):void
        {
            this.source = _arg1.readObject();
        }

        public function writeExternal(_arg1:IDataOutput):void
        {
            _arg1.writeObject(this._source);
        }

        override public function toString():String
        {
            if (this.source)
            {
                return (this.source.toString());
            };
            return (getQualifiedClassName(this));
        }

        private function enableEvents():void
        {
            this._dispatchEvents++;
            if (this._dispatchEvents > 0)
            {
                this._dispatchEvents = 0;
            };
        }

        private function disableEvents():void
        {
            this._dispatchEvents--;
        }

        private function internalDispatchEvent(_arg1:String, _arg2:Object=null, _arg3:int=-1):void
        {
            var _local4:CollectionEvent;
            var _local5:PropertyChangeEvent;
            if (this._dispatchEvents == 0)
            {
                if (hasEventListener(CollectionEvent.COLLECTION_CHANGE))
                {
                    _local4 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                    _local4.kind = _arg1;
                    _local4.items.push(_arg2);
                    _local4.location = _arg3;
                    dispatchEvent(_local4);
                };
                if (((hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) && ((((_arg1 == CollectionEventKind.ADD)) || ((_arg1 == CollectionEventKind.REMOVE))))))
                {
                    _local5 = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
                    _local5.property = _arg3;
                    if (_arg1 == CollectionEventKind.ADD)
                    {
                        _local5.newValue = _arg2;
                    }
                    else
                    {
                        _local5.oldValue = _arg2;
                    };
                    dispatchEvent(_local5);
                };
            };
        }

        protected function itemUpdateHandler(_arg1:PropertyChangeEvent):void
        {
            var _local2:PropertyChangeEvent;
            var _local3:uint;
            this.internalDispatchEvent(CollectionEventKind.UPDATE, _arg1);
            if ((((this._dispatchEvents == 0)) && (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))))
            {
                _local2 = PropertyChangeEvent(_arg1.clone());
                _local3 = this.getItemIndex(_arg1.target);
                _local2.property = ((_local3.toString() + ".") + _arg1.property);
                dispatchEvent(_local2);
            };
        }

        protected function startTrackUpdates(_arg1:Object):void
        {
            if (((_arg1) && ((_arg1 is IEventDispatcher))))
            {
                IEventDispatcher(_arg1).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this.itemUpdateHandler, false, 0, true);
            };
        }

        protected function stopTrackUpdates(_arg1:Object):void
        {
            if (((_arg1) && ((_arg1 is IEventDispatcher))))
            {
                IEventDispatcher(_arg1).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this.itemUpdateHandler);
            };
        }


    }
}//package mx.collections
