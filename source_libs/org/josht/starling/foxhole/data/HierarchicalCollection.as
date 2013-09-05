//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.data
{
    import org.osflash.signals.Signal;
    import org.osflash.signals.ISignal;
    import __AS3__.vec.Vector;

    public class HierarchicalCollection 
    {

        protected var _onChange:Signal;
        protected var _onReset:Signal;
        protected var _onAdd:Signal;
        protected var _onRemove:Signal;
        protected var _onReplace:Signal;
        protected var _onItemUpdate:Signal;
        protected var _data:Object;
        private var _dataDescriptor:IHierarchicalCollectionDataDescriptor;

        public function HierarchicalCollection(_arg1:Object=null)
        {
            this._onChange = new Signal(HierarchicalCollection);
            this._onReset = new Signal(HierarchicalCollection);
            this._onAdd = new Signal(HierarchicalCollection, int);
            this._onRemove = new Signal(HierarchicalCollection, int);
            this._onReplace = new Signal(HierarchicalCollection, int);
            this._onItemUpdate = new Signal(HierarchicalCollection, int);
            this._dataDescriptor = new ArrayChildrenHierarchicalCollectionDataDescriptor();
            super();
            if (!_arg1)
            {
                _arg1 = [];
            };
            this.data = _arg1;
        }

        public function get onChange():ISignal
        {
            return (this._onChange);
        }

        public function get onReset():ISignal
        {
            return (this._onReset);
        }

        public function get onAdd():ISignal
        {
            return (this._onAdd);
        }

        public function get onRemove():ISignal
        {
            return (this._onRemove);
        }

        public function get onReplace():ISignal
        {
            return (this._onReplace);
        }

        public function get onItemUpdate():ISignal
        {
            return (this._onItemUpdate);
        }

        public function get data():Object
        {
            return (this._data);
        }

        public function set data(_arg1:Object):void
        {
            if (this._data == _arg1)
            {
                return;
            };
            this._data = _arg1;
            this._onReset.dispatch(this);
            this._onChange.dispatch(this);
        }

        public function get dataDescriptor():IHierarchicalCollectionDataDescriptor
        {
            return (this._dataDescriptor);
        }

        public function set dataDescriptor(_arg1:IHierarchicalCollectionDataDescriptor):void
        {
            if (this._dataDescriptor == _arg1)
            {
                return;
            };
            this._dataDescriptor = _arg1;
            this._onReset.dispatch(this);
            this._onChange.dispatch(this);
        }

        public function isBranch(_arg1:Object):Boolean
        {
            return (this._dataDescriptor.isBranch(_arg1));
        }

        public function getLength(... _args):int
        {
            _args.unshift(this._data);
            return (this._dataDescriptor.getLength.apply(null, _args));
        }

        public function updateItemAt(_arg1:int, ... _args):void
        {
            _args.unshift(_arg1);
            _args.unshift(this);
            this._onItemUpdate.dispatch.apply(null, _args);
        }

        public function getItemAt(_arg1:int, ... _args):Object
        {
            _args.unshift(_arg1);
            _args.unshift(this._data);
            return (this._dataDescriptor.getItemAt.apply(null, _args));
        }

        public function getItemLocation(_arg1:Object, _arg2:Vector.<int>=null):Vector.<int>
        {
            return (this._dataDescriptor.getItemLocation(this._data, _arg1, _arg2));
        }

        public function addItemAt(_arg1:Object, _arg2:int, ... _args):void
        {
            _args.unshift(_arg2);
            _args.unshift(_arg1);
            _args.unshift(this._data);
            this._dataDescriptor.addItemAt.apply(null, _args);
            this._onChange.dispatch(this);
            _args.shift();
            _args.shift();
            _args.unshift(this);
            this._onAdd.dispatch.apply(null, _args);
        }

        public function removeItemAt(_arg1:int, ... _args):Object
        {
            _args.push(_arg1);
            _args.push(this._data);
            var _local3:Object = this._dataDescriptor.removeItemAt.apply(null, _args);
            this._onChange.dispatch(this);
            _args.shift();
            _args.unshift(this);
            this._onRemove.dispatch.apply(null, _args);
            return (_local3);
        }

        public function removeItem(_arg1:Object):void
        {
            var _local2:Vector.<int> = this.getItemLocation(_arg1);
            if (_local2)
            {
                this.removeItemAt.apply(this, _local2);
            };
        }

        public function setItemAt(_arg1:Object, _arg2:int, ... _args):void
        {
            _args.push(_arg2);
            _args.push(_arg1);
            _args.push(this._data);
            this._dataDescriptor.setItemAt.apply(null, _args);
            _args.shift();
            _args.shift();
            _args.unshift(this);
            this._onReplace.dispatch.apply(null, _args);
            this._onChange.dispatch(this);
        }


    }
}//package org.josht.starling.foxhole.data
