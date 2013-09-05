//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.data
{
    import org.osflash.signals.Signal;
    import org.osflash.signals.ISignal;
    import __AS3__.vec.*;

    public class ListCollection 
    {

        protected var _onChange:Signal;
        protected var _onAdd:Signal;
        protected var _onRemove:Signal;
        protected var _onReplace:Signal;
        protected var _onReset:Signal;
        protected var _onItemUpdate:Signal;
        protected var _data:Object;
        private var _dataDescriptor:IListCollectionDataDescriptor;

        public function ListCollection(_arg1:Object=null)
        {
            this._onChange = new Signal(ListCollection);
            this._onAdd = new Signal(ListCollection, int);
            this._onRemove = new Signal(ListCollection, int);
            this._onReplace = new Signal(ListCollection, int);
            this._onReset = new Signal(ListCollection);
            this._onItemUpdate = new Signal(ListCollection, int);
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

        public function get onReset():ISignal
        {
            return (this._onReset);
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
            if ((((this._data is Array)) && (!((this._dataDescriptor is ArrayListCollectionDataDescriptor)))))
            {
                this.dataDescriptor = new ArrayListCollectionDataDescriptor();
            }
            else
            {
                if ((((this._data is Vector.<Number>)) && (!((this._dataDescriptor is VectorNumberListCollectionDataDescriptor)))))
                {
                    this.dataDescriptor = new VectorNumberListCollectionDataDescriptor();
                }
                else
                {
                    if ((((this._data is Vector.<int>)) && (!((this._dataDescriptor is VectorIntListCollectionDataDescriptor)))))
                    {
                        this.dataDescriptor = new VectorIntListCollectionDataDescriptor();
                    }
                    else
                    {
                        if ((((this._data is Vector.<uint>)) && (!((this._dataDescriptor is VectorUintListCollectionDataDescriptor)))))
                        {
                            this.dataDescriptor = new VectorUintListCollectionDataDescriptor();
                        }
                        else
                        {
                            if ((((this._data is Vector.<*>)) && (!((this._dataDescriptor is VectorListCollectionDataDescriptor)))))
                            {
                                this.dataDescriptor = new VectorListCollectionDataDescriptor();
                            }
                            else
                            {
                                if ((((this._data is XMLList)) && (!((this._dataDescriptor is XMLListListCollectionDataDescriptor)))))
                                {
                                    this.dataDescriptor = new XMLListListCollectionDataDescriptor();
                                };
                            };
                        };
                    };
                };
            };
            this._onReset.dispatch(this);
            this._onChange.dispatch(this);
        }

        public function get dataDescriptor():IListCollectionDataDescriptor
        {
            return (this._dataDescriptor);
        }

        public function set dataDescriptor(_arg1:IListCollectionDataDescriptor):void
        {
            if (this._dataDescriptor == _arg1)
            {
                return;
            };
            this._dataDescriptor = _arg1;
            this._onReset.dispatch(this);
            this._onChange.dispatch(this);
        }

        public function get length():int
        {
            return (this._dataDescriptor.getLength(this._data));
        }

        public function updateItemAt(_arg1:int):void
        {
            this._onItemUpdate.dispatch(this, _arg1);
        }

        public function getItemAt(_arg1:int):Object
        {
            return (this._dataDescriptor.getItemAt(this._data, _arg1));
        }

        public function getItemIndex(_arg1:Object):int
        {
            return (this._dataDescriptor.getItemIndex(this._data, _arg1));
        }

        public function addItemAt(_arg1:Object, _arg2:int):void
        {
            this._dataDescriptor.addItemAt(this._data, _arg1, _arg2);
            this._onChange.dispatch(this);
            this._onAdd.dispatch(this, _arg2);
        }

        public function removeItemAt(_arg1:int):Object
        {
            var _local2:Object = this._dataDescriptor.removeItemAt(this._data, _arg1);
            this._onChange.dispatch(this);
            this._onRemove.dispatch(this, _arg1);
            return (_local2);
        }

        public function removeItem(_arg1:Object):void
        {
            var _local2:int = this.getItemIndex(_arg1);
            if (_local2 >= 0)
            {
                this.removeItemAt(_local2);
            };
        }

        public function setItemAt(_arg1:Object, _arg2:int):void
        {
            this._dataDescriptor.setItemAt(this._data, _arg1, _arg2);
            this._onReplace.dispatch(this, _arg2);
            this._onChange.dispatch(this);
        }

        public function push(_arg1:Object):void
        {
            this.addItemAt(_arg1, this.length);
        }

        public function pop():Object
        {
            return (this.removeItemAt((this.length - 1)));
        }

        public function unshift(_arg1:Object):void
        {
            this.addItemAt(_arg1, 0);
        }

        public function shift():Object
        {
            return (this.removeItemAt(0));
        }


    }
}//package org.josht.starling.foxhole.data
