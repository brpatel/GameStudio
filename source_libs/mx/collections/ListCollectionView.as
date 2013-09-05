//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.collections
{
    import flash.utils.Proxy;
    import mx.core.mx_internal;
    import flash.events.EventDispatcher;
    import mx.resources.IResourceManager;
    import mx.resources.ResourceManager;
    import mx.events.CollectionEvent;
    import flash.events.Event;
    import mx.utils.ObjectUtil;
    import flash.utils.getQualifiedClassName;
    import mx.collections.errors.CollectionViewError;
    import mx.events.CollectionEventKind;
    import mx.collections.errors.SortError;
    import mx.events.PropertyChangeEvent;
    import mx.collections.errors.ItemPendingError;
    import mx.core.*;
    import flash.utils.flash_proxy

    use namespace mx_internal;

    public class ListCollectionView extends Proxy implements ICollectionView, IList, IMXMLObject 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        private var eventDispatcher:EventDispatcher;
        private var revision:int;
        private var autoUpdateCounter:int;
        private var pendingUpdates:Array;
        mx_internal var dispatchResetEvent:Boolean = true;
        private var resourceManager:IResourceManager;
        protected var localIndex:Array;
        private var _list:IList;
        private var _filterFunction:Function;
        private var _sort:ISort;

        public function ListCollectionView(_arg1:IList=null)
        {
            this.resourceManager = ResourceManager.getInstance();
            super();
            this.eventDispatcher = new EventDispatcher(this);
            this.list = _arg1;
        }

        public function initialized(_arg1:Object, _arg2:String):void
        {
            this.refresh();
        }

        [Bindable("collectionChange")]
        public function get length():int
        {
            if (this.localIndex)
            {
                return (this.localIndex.length);
            };
            if (this.list)
            {
                return (this.list.length);
            };
            return (0);
        }

        [Bindable("listChanged")]
        public function get list():IList
        {
            return (this._list);
        }

        public function set list(_arg1:IList):void
        {
            var _local2:Boolean;
            var _local3:Boolean;
            if (this._list != _arg1)
            {
                if (this._list)
                {
                    this._list.removeEventListener(CollectionEvent.COLLECTION_CHANGE, this.listChangeHandler);
                    _local2 = (this._list.length > 0);
                };
                this._list = _arg1;
                if (this._list)
                {
                    this._list.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.listChangeHandler, false, 0, true);
                    _local3 = (this._list.length > 0);
                };
                if (((_local2) || (_local3)))
                {
                    this.reset();
                };
                this.dispatchEvent(new Event("listChanged"));
            };
        }

        [Bindable("filterFunctionChanged")]
        public function get filterFunction():Function
        {
            return (this._filterFunction);
        }

        public function set filterFunction(_arg1:Function):void
        {
            this._filterFunction = _arg1;
            this.dispatchEvent(new Event("filterFunctionChanged"));
        }

        [Bindable("sortChanged")]
        public function get sort():ISort
        {
            return (this._sort);
        }

        public function set sort(_arg1:ISort):void
        {
            this._sort = _arg1;
            this.dispatchEvent(new Event("sortChanged"));
        }

        public function contains(_arg1:Object):Boolean
        {
            return (!((this.getItemIndex(_arg1) == -1)));
        }

        public function disableAutoUpdate():void
        {
            this.autoUpdateCounter++;
        }

        public function enableAutoUpdate():void
        {
            if (this.autoUpdateCounter > 0)
            {
                this.autoUpdateCounter--;
                if (this.autoUpdateCounter == 0)
                {
                    this.handlePendingUpdates();
                };
            };
        }

        public function createCursor():IViewCursor
        {
            return (new ListCollectionViewCursor(this));
        }

        public function itemUpdated(_arg1:Object, _arg2:Object=null, _arg3:Object=null, _arg4:Object=null):void
        {
            this.list.itemUpdated(_arg1, _arg2, _arg3, _arg4);
        }

        public function refresh():Boolean
        {
            return (this.internalRefresh(true));
        }

        [Bindable("collectionChange")]
        public function getItemAt(_arg1:int, _arg2:int=0):Object
        {
            var _local3:String;
            if ((((_arg1 < 0)) || ((_arg1 >= this.length))))
            {
                _local3 = this.resourceManager.getString("collections", "outOfBounds", [_arg1]);
                throw (new RangeError(_local3));
            };
            if (this.localIndex)
            {
                return (this.localIndex[_arg1]);
            };
            if (this.list)
            {
                return (this.list.getItemAt(_arg1, _arg2));
            };
            return (null);
        }

        public function setItemAt(_arg1:Object, _arg2:int):Object
        {
            var _local4:String;
            var _local5:Object;
            if ((((((_arg2 < 0)) || (!(this.list)))) || ((_arg2 >= this.length))))
            {
                _local4 = this.resourceManager.getString("collections", "outOfBounds", [_arg2]);
                throw (new RangeError(_local4));
            };
            var _local3:int = _arg2;
            if (this.localIndex)
            {
                if (_arg2 > this.localIndex.length)
                {
                    _local3 = this.list.length;
                }
                else
                {
                    _local5 = this.localIndex[_arg2];
                    _local3 = this.list.getItemIndex(_local5);
                };
            };
            return (this.list.setItemAt(_arg1, _local3));
        }

        public function addItem(_arg1:Object):void
        {
            this.addItemAt(_arg1, this.length);
        }

        public function addItemAt(_arg1:Object, _arg2:int):void
        {
            var _local4:String;
            if ((((((_arg2 < 0)) || (!(this.list)))) || ((_arg2 > this.length))))
            {
                _local4 = this.resourceManager.getString("collections", "outOfBounds", [_arg2]);
                throw (new RangeError(_local4));
            };
            var _local3:int = _arg2;
            if (((this.localIndex) && (this.sort)))
            {
                _local3 = this.list.length;
            }
            else
            {
                if (((this.localIndex) && (!((this.filterFunction == null)))))
                {
                    if (_local3 == this.localIndex.length)
                    {
                        _local3 = this.list.length;
                    }
                    else
                    {
                        _local3 = this.list.getItemIndex(this.localIndex[_arg2]);
                    };
                };
            };
            this.list.addItemAt(_arg1, _local3);
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
            var _local2:int;
            var _local3:int;
            var _local4:int;
            var _local5:int;
            if (((this.localIndex) && (this.sort)))
            {
                _local3 = this.findItem(_arg1, Sort.FIRST_INDEX_MODE);
                if (_local3 == -1)
                {
                    return (-1);
                };
                _local4 = this.findItem(_arg1, Sort.LAST_INDEX_MODE);
                _local2 = _local3;
                while (_local2 <= _local4)
                {
                    if (this.localIndex[_local2] == _arg1)
                    {
                        return (_local2);
                    };
                    _local2++;
                };
                return (-1);
            };
            if (((this.localIndex) && (!((this.filterFunction == null)))))
            {
                _local5 = this.localIndex.length;
                _local2 = 0;
                while (_local2 < _local5)
                {
                    if (this.localIndex[_local2] == _arg1)
                    {
                        return (_local2);
                    };
                    _local2++;
                };
                return (-1);
            };
            return (this.list.getItemIndex(_arg1));
        }

        mx_internal function getLocalItemIndex(_arg1:Object):int
        {
            var _local2:int;
            var _local3:int = this.localIndex.length;
            _local2 = 0;
            while (_local2 < _local3)
            {
                if (this.localIndex[_local2] == _arg1)
                {
                    return (_local2);
                };
                _local2++;
            };
            return (-1);
        }

        private function getFilteredItemIndex(_arg1:Object):int
        {
            var _local4:Object;
            var _local5:int;
            var _local6:int;
            var _local2:int = this.list.getItemIndex(_arg1);
            if (_local2 == 0)
            {
                return (0);
            };
            var _local3:int = (_local2 - 1);
            while (_local3 >= 0)
            {
                _local4 = this.list.getItemAt(_local3);
                if (this.filterFunction(_local4))
                {
                    _local5 = this.localIndex.length;
                    _local6 = 0;
                    while (_local6 < _local5)
                    {
                        if (this.localIndex[_local6] == _local4)
                        {
                            return ((_local6 + 1));
                        };
                        _local6++;
                    };
                };
                _local3--;
            };
            return (0);
        }

        public function removeItemAt(_arg1:int):Object
        {
            var _local3:String;
            var _local4:Object;
            if ((((_arg1 < 0)) || ((_arg1 >= this.length))))
            {
                _local3 = this.resourceManager.getString("collections", "outOfBounds", [_arg1]);
                throw (new RangeError(_local3));
            };
            var _local2:int = _arg1;
            if (this.localIndex)
            {
                _local4 = this.localIndex[_arg1];
                _local2 = this.list.getItemIndex(_local4);
            };
            return (this.list.removeItemAt(_local2));
        }

        public function removeAll():void
        {
            var _local2:int;
            var _local1:int = this.length;
            if (_local1 > 0)
            {
                if (this.localIndex)
                {
                    _local2 = (_local1 - 1);
                    while (_local2 >= 0)
                    {
                        this.removeItemAt(_local2);
                        _local2--;
                    };
                }
                else
                {
                    this.list.removeAll();
                };
            };
        }

        public function toArray():Array
        {
            var _local1:Array;
            if (this.localIndex)
            {
                _local1 = this.localIndex.concat();
            }
            else
            {
                _local1 = this.list.toArray();
            };
            return (_local1);
        }

        public function toString():String
        {
            if (this.localIndex)
            {
                return (ObjectUtil.toString(this.localIndex));
            };
            if (((this.list) && (Object(this.list).toString)))
            {
                return (Object(this.list).toString());
            };
            return (getQualifiedClassName(this));
        }

        override flash_proxy function getProperty(_arg1)
        {
            var _local3:Number;
            var _local4:String;
            if ((_arg1 is QName))
            {
                _arg1 = _arg1.localName;
            };
            var _local2:int = -1;
            try
            {
                _local3 = parseInt(String(_arg1));
                if (!isNaN(_local3))
                {
                    _local2 = int(_local3);
                };
            }
            catch(e:Error)
            {
            };
            if (_local2 == -1)
            {
                _local4 = this.resourceManager.getString("collections", "unknownProperty", [_arg1]);
                throw (new Error(_local4));
            };
            return (this.getItemAt(_local2));
        }

        override flash_proxy function setProperty(_arg1, _arg2):void
        {
            var _local4:Number;
            var _local5:String;
            if ((_arg1 is QName))
            {
                _arg1 = _arg1.localName;
            };
            var _local3:int = -1;
            try
            {
                _local4 = parseInt(String(_arg1));
                if (!isNaN(_local4))
                {
                    _local3 = int(_local4);
                };
            }
            catch(e:Error)
            {
            };
            if (_local3 == -1)
            {
                _local5 = this.resourceManager.getString("collections", "unknownProperty", [_arg1]);
                throw (new Error(_local5));
            };
            this.setItemAt(_arg2, _local3);
        }

        override flash_proxy function hasProperty(_arg1):Boolean
        {
            var _local3:Number;
            if ((_arg1 is QName))
            {
                _arg1 = _arg1.localName;
            };
            var _local2:int = -1;
            try
            {
                _local3 = parseInt(String(_arg1));
                if (!isNaN(_local3))
                {
                    _local2 = int(_local3);
                };
            }
            catch(e:Error)
            {
            };
            if (_local2 == -1)
            {
                return (false);
            };
            return ((((_local2 >= 0)) && ((_local2 < this.length))));
        }

        override flash_proxy function nextNameIndex(_arg1:int):int
        {
            return ((((_arg1 < this.length)) ? (_arg1 + 1) : 0));
        }

        override flash_proxy function nextName(_arg1:int):String
        {
            return ((_arg1 - 1).toString());
        }

        override flash_proxy function nextValue(_arg1:int)
        {
            return (this.getItemAt((_arg1 - 1)));
        }

        override flash_proxy function callProperty(_arg1, ... _args)
        {
            return (null);
        }

        public function addEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false, _arg4:int=0, _arg5:Boolean=false):void
        {
            this.eventDispatcher.addEventListener(_arg1, _arg2, _arg3, _arg4, _arg5);
        }

        public function removeEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false):void
        {
            this.eventDispatcher.removeEventListener(_arg1, _arg2, _arg3);
        }

        public function dispatchEvent(_arg1:Event):Boolean
        {
            return (this.eventDispatcher.dispatchEvent(_arg1));
        }

        public function hasEventListener(_arg1:String):Boolean
        {
            return (this.eventDispatcher.hasEventListener(_arg1));
        }

        public function willTrigger(_arg1:String):Boolean
        {
            return (this.eventDispatcher.willTrigger(_arg1));
        }

        private function addItemsToView(_arg1:Array, _arg2:int, _arg3:Boolean=true):int
        {
            var _local7:int;
            var _local8:int;
            var _local9:Object;
            var _local10:String;
            var _local11:CollectionEvent;
            var _local4:Array = ((this.localIndex) ? [] : _arg1);
            var _local5:int = _arg2;
            var _local6:Boolean = true;
            if (this.localIndex)
            {
                _local7 = _arg2;
                _local8 = 0;
                while (_local8 < _arg1.length)
                {
                    _local9 = _arg1[_local8];
                    if ((((this.filterFunction == null)) || (this.filterFunction(_local9))))
                    {
                        if (this.sort)
                        {
                            _local7 = this.findItem(_local9, Sort.ANY_INDEX_MODE, true);
                            if (_local6)
                            {
                                _local5 = _local7;
                                _local6 = false;
                            };
                        }
                        else
                        {
                            _local7 = this.getFilteredItemIndex(_local9);
                            if (_local6)
                            {
                                _local5 = _local7;
                                _local6 = false;
                            };
                        };
                        if (((((this.sort) && (this.sort.unique))) && ((this.sort.compareFunction(_local9, this.localIndex[_local7]) == 0))))
                        {
                            _local10 = this.resourceManager.getString("collections", "incorrectAddition");
                            throw (new CollectionViewError(_local10));
                        };
                        var _temp1 = _local7;
                        _local7 = (_local7 + 1);
                        this.localIndex.splice(_temp1, 0, _local9);
                        _local4.push(_local9);
                    }
                    else
                    {
                        _local5 = -1;
                    };
                    _local8++;
                };
            };
            if (((this.localIndex) && ((_local4.length > 1))))
            {
                _local5 = -1;
            };
            if (((_arg3) && ((_local4.length > 0))))
            {
                _local11 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                _local11.kind = CollectionEventKind.ADD;
                _local11.location = _local5;
                _local11.items = _local4;
                this.dispatchEvent(_local11);
            };
            return (_local5);
        }

        mx_internal function findItem(_arg1:Object, _arg2:String, _arg3:Boolean=false):int
        {
            var _local4:String;
            if (((!(this.sort)) || (!(this.localIndex))))
            {
                _local4 = this.resourceManager.getString("collections", "itemNotFound");
                throw (new CollectionViewError(_local4));
            };
            if (this.localIndex.length == 0)
            {
                return (((_arg3) ? 0 : -1));
            };
            try
            {
                return (this.sort.findItem(this.localIndex, _arg1, _arg2, _arg3));
            }
            catch(e:SortError)
            {
            };
            return (-1);
        }

        mx_internal function getBookmark(_arg1:int):ListCollectionViewBookmark
        {
            var value:Object;
            var message:String;
            var index:int = _arg1;
            if ((((index < 0)) || ((index > this.length))))
            {
                message = this.resourceManager.getString("collections", "invalidIndex", [index]);
                throw (new CollectionViewError(message));
            };
            try
            {
                value = this.getItemAt(index);
            }
            catch(e:Error)
            {
                value = null;
            };
            return (new ListCollectionViewBookmark(value, this, this.revision, index));
        }

        mx_internal function getBookmarkIndex(_arg1:CursorBookmark):int
        {
            var bm:ListCollectionViewBookmark;
            var message:String;
            var bookmark:CursorBookmark = _arg1;
            if (((!((bookmark is ListCollectionViewBookmark))) || (!((ListCollectionViewBookmark(bookmark).view == this)))))
            {
                message = this.resourceManager.getString("collections", "bookmarkNotFound");
                throw (new CollectionViewError(message));
            };
            bm = ListCollectionViewBookmark(bookmark);
            if (bm.viewRevision != this.revision)
            {
                if ((((((bm.index < 0)) || ((bm.index >= this.length)))) || (!((this.getItemAt(bm.index) == bm.value)))))
                {
                    try
                    {
                        bm.index = this.getItemIndex(bm.value);
                    }
                    catch(e:SortError)
                    {
                        bm.index = getLocalItemIndex(bm.value);
                    };
                };
                bm.viewRevision = this.revision;
            };
            return (bm.index);
        }

        private function listChangeHandler(_arg1:CollectionEvent):void
        {
            var _local2:int;
            var _local3:int;
            if (this.autoUpdateCounter > 0)
            {
                if (!this.pendingUpdates)
                {
                    this.pendingUpdates = [];
                };
                this.pendingUpdates.push(_arg1);
            }
            else
            {
                switch (_arg1.kind)
                {
                    case CollectionEventKind.ADD:
                        this.addItemsToView(_arg1.items, _arg1.location);
                        return;
                    case CollectionEventKind.MOVE:
                        _local2 = _arg1.items.length;
                        _local3 = 0;
                        while (_local3 < _local2)
                        {
                            this.moveItemInView(_arg1.items[_local3]);
                            _local3++;
                        };
                        return;
                    case CollectionEventKind.RESET:
                        this.reset();
                        return;
                    case CollectionEventKind.REMOVE:
                        this.removeItemsFromView(_arg1.items, _arg1.location);
                        return;
                    case CollectionEventKind.REPLACE:
                        this.replaceItemsInView(_arg1.items, _arg1.location);
                        return;
                    case CollectionEventKind.UPDATE:
                        this.handlePropertyChangeEvents(_arg1.items);
                        return;
                    default:
                        this.dispatchEvent(_arg1);
                };
            };
        }

        private function handlePropertyChangeEvents(_arg1:Array):void
        {
            var _local3:Array;
            var _local4:Object;
            var _local5:int;
            var _local6:Array;
            var _local7:int;
            var _local8:PropertyChangeEvent;
            var _local9:Object;
            var _local10:Boolean;
            var _local11:int;
            var _local12:int;
            var _local13:int;
            var _local14:int;
            var _local15:CollectionEvent;
            var _local2:Array = _arg1;
            if (((this.sort) || (!((this.filterFunction == null)))))
            {
                _local3 = [];
                _local5 = 0;
                while (_local5 < _arg1.length)
                {
                    _local8 = _arg1[_local5];
                    if (_local8.target)
                    {
                        _local9 = _local8.target;
                        _local10 = !((_local8.target == _local8.source));
                    }
                    else
                    {
                        _local9 = _local8.source;
                        _local10 = false;
                    };
                    _local11 = 0;
                    while (_local11 < _local3.length)
                    {
                        if (_local3[_local11].item == _local9)
                        {
                            _arg1 = _local3[_local11].events;
                            _local12 = _arg1.length;
                            _local13 = 0;
                            while (_local13 < _local12)
                            {
                                if (_arg1[_local13].property != _local8.property)
                                {
                                    _arg1.push(_local8);
                                    break;
                                };
                                _local13++;
                            };
                            break;
                        };
                        _local11++;
                    };
                    if (_local11 < _local3.length)
                    {
                        _local4 = _local3[_local11];
                    }
                    else
                    {
                        _local4 = {
                            item:_local9,
                            move:_local10,
                            events:[_local8]
                        };
                        _local3.push(_local4);
                    };
                    _local4.move = ((((((_local4.move) || (this.filterFunction))) || (!(_local8.property)))) || (((this.sort) && (this.sort.propertyAffectsSort(String(_local8.property))))));
                    _local5++;
                };
                _local2 = [];
                _local5 = 0;
                while (_local5 < _local3.length)
                {
                    _local4 = _local3[_local5];
                    if (_local4.move)
                    {
                        this.moveItemInView(_local4.item, _local4.item, _local2);
                    }
                    else
                    {
                        _local2.push(_local4.item);
                    };
                    _local5++;
                };
                _local6 = [];
                _local7 = 0;
                while (_local7 < _local2.length)
                {
                    _local14 = 0;
                    while (_local14 < _local3.length)
                    {
                        if (_local2[_local7] == _local3[_local14].item)
                        {
                            _local6 = _local6.concat(_local3[_local14].events);
                        };
                        _local14++;
                    };
                    _local7++;
                };
                _local2 = _local6;
            };
            if (_local2.length > 0)
            {
                _local15 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                _local15.kind = CollectionEventKind.UPDATE;
                _local15.items = _local2;
                this.dispatchEvent(_local15);
            };
        }

        private function handlePendingUpdates():void
        {
            var _local1:Array;
            var _local2:CollectionEvent;
            var _local3:int;
            var _local4:CollectionEvent;
            var _local5:int;
            if (this.pendingUpdates)
            {
                _local1 = this.pendingUpdates;
                this.pendingUpdates = null;
                _local3 = 0;
                while (_local3 < _local1.length)
                {
                    _local4 = _local1[_local3];
                    if (_local4.kind == CollectionEventKind.UPDATE)
                    {
                        if (!_local2)
                        {
                            _local2 = _local4;
                        }
                        else
                        {
                            _local5 = 0;
                            while (_local5 < _local4.items.length)
                            {
                                _local2.items.push(_local4.items[_local5]);
                                _local5++;
                            };
                        };
                    }
                    else
                    {
                        this.listChangeHandler(_local4);
                    };
                    _local3++;
                };
                if (_local2)
                {
                    this.listChangeHandler(_local2);
                };
            };
        }

        private function internalRefresh(_arg1:Boolean):Boolean
        {
            var tmp:Array;
            var len:int;
            var i:int;
            var item:Object;
            var refreshEvent:CollectionEvent;
            var dispatch:Boolean = _arg1;
            if (((this.sort) || (!((this.filterFunction == null)))))
            {
                try
                {
                    this.populateLocalIndex();
                }
                catch(pending:ItemPendingError)
                {
                    pending.addResponder(new ItemResponder(function (_arg1:Object, _arg2:Object=null):void
                    {
                        internalRefresh(dispatch);
                    }, function (_arg1:Object, _arg2:Object=null):void
                    {
                    }));
                    return (false);
                };
                if (this.filterFunction != null)
                {
                    tmp = [];
                    len = this.localIndex.length;
                    i = 0;
                    while (i < len)
                    {
                        item = this.localIndex[i];
                        if (this.filterFunction(item))
                        {
                            tmp.push(item);
                        };
                        i = (i + 1);
                    };
                    this.localIndex = tmp;
                };
                if (this.sort)
                {
                    this.sort.sort(this.localIndex);
                    dispatch = true;
                };
            }
            else
            {
                if (this.localIndex)
                {
                    this.localIndex = null;
                };
            };
            this.revision++;
            this.pendingUpdates = null;
            if (dispatch)
            {
                refreshEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                refreshEvent.kind = CollectionEventKind.REFRESH;
                this.dispatchEvent(refreshEvent);
            };
            return (true);
        }

        private function moveItemInView(_arg1:Object, _arg2:Boolean=true, _arg3:Array=null):void
        {
            var _local4:int;
            var _local5:int;
            var _local6:int;
            var _local7:CollectionEvent;
            if (this.localIndex)
            {
                _local4 = -1;
                _local5 = 0;
                while (_local5 < this.localIndex.length)
                {
                    if (this.localIndex[_local5] == _arg1)
                    {
                        _local4 = _local5;
                        break;
                    };
                    _local5++;
                };
                if (_local4 > -1)
                {
                    this.localIndex.splice(_local4, 1);
                };
                _local6 = this.addItemsToView([_arg1], _local4, false);
                if (_arg2)
                {
                    _local7 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                    _local7.items.push(_arg1);
                    if (((((_arg3) && ((_local6 == _local4)))) && ((_local6 > -1))))
                    {
                        _arg3.push(_arg1);
                        return;
                    };
                    if ((((_local6 > -1)) && ((_local4 > -1))))
                    {
                        _local7.kind = CollectionEventKind.MOVE;
                        _local7.location = _local6;
                        _local7.oldLocation = _local4;
                    }
                    else
                    {
                        if (_local6 > -1)
                        {
                            _local7.kind = CollectionEventKind.ADD;
                            _local7.location = _local6;
                        }
                        else
                        {
                            if (_local4 > -1)
                            {
                                _local7.kind = CollectionEventKind.REMOVE;
                                _local7.location = _local4;
                            }
                            else
                            {
                                _arg2 = false;
                            };
                        };
                    };
                    if (_arg2)
                    {
                        this.dispatchEvent(_local7);
                    };
                };
            };
        }

        private function populateLocalIndex():void
        {
            if (this.list)
            {
                this.localIndex = this.list.toArray();
            }
            else
            {
                this.localIndex = [];
            };
        }

        private function removeItemsFromView(_arg1:Array, _arg2:int, _arg3:Boolean=true):void
        {
            var _local6:int;
            var _local7:Object;
            var _local8:int;
            var _local9:CollectionEvent;
            var _local4:Array = ((this.localIndex) ? [] : _arg1);
            var _local5:int = _arg2;
            if (this.localIndex)
            {
                _local6 = 0;
                while (_local6 < _arg1.length)
                {
                    _local7 = _arg1[_local6];
                    _local8 = this.getItemIndex(_local7);
                    if (_local8 > -1)
                    {
                        this.localIndex.splice(_local8, 1);
                        _local4.push(_local7);
                        _local5 = _local8;
                    };
                    _local6++;
                };
            };
            if (((_arg3) && ((_local4.length > 0))))
            {
                _local9 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                _local9.kind = CollectionEventKind.REMOVE;
                _local9.location = ((((!(this.localIndex)) || ((_local4.length == 1)))) ? _local5 : -1);
                _local9.items = _local4;
                this.dispatchEvent(_local9);
            };
        }

        private function replaceItemsInView(_arg1:Array, _arg2:int, _arg3:Boolean=true):void
        {
            var _local4:int;
            var _local5:Array;
            var _local6:Array;
            var _local7:int;
            var _local8:PropertyChangeEvent;
            var _local9:CollectionEvent;
            if (this.localIndex)
            {
                _local4 = _arg1.length;
                _local5 = [];
                _local6 = [];
                _local7 = 0;
                while (_local7 < _local4)
                {
                    _local8 = _arg1[_local7];
                    _local5.push(_local8.oldValue);
                    _local6.push(_local8.newValue);
                    _local7++;
                };
                this.removeItemsFromView(_local5, _arg2, _arg3);
                this.addItemsToView(_local6, _arg2, _arg3);
            }
            else
            {
                _local9 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                _local9.kind = CollectionEventKind.REPLACE;
                _local9.location = _arg2;
                _local9.items = _arg1;
                this.dispatchEvent(_local9);
            };
        }

        mx_internal function reset():void
        {
            var _local1:CollectionEvent;
            this.internalRefresh(false);
            if (this.dispatchResetEvent)
            {
                _local1 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                _local1.kind = CollectionEventKind.RESET;
                this.dispatchEvent(_local1);
            };
        }


    }
}//package mx.collections

import flash.events.EventDispatcher;
import mx.collections.ListCollectionView;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;
import mx.events.CollectionEvent;
import mx.collections.errors.ItemPendingError;
import mx.collections.ICollectionView;
import mx.collections.CursorBookmark;
import mx.core.mx_internal;
import mx.collections.Sort;
import mx.collections.errors.SortError;
import mx.collections.errors.CursorError;
import mx.collections.errors.CollectionViewError;
import mx.events.CollectionEventKind;
import mx.events.FlexEvent;
import mx.collections.*;

use namespace mx_internal;

class ListCollectionViewCursor extends EventDispatcher implements IViewCursor 
{

    private static const BEFORE_FIRST_INDEX:int = -1;
    private static const AFTER_LAST_INDEX:int = -2;

    private var _view:ListCollectionView;
    private var currentIndex:int;
    private var currentValue:Object;
    private var invalid:Boolean;
    private var resourceManager:IResourceManager;

    public function ListCollectionViewCursor(_arg1:ListCollectionView)
    {
        var view:ListCollectionView = _arg1;
        this.resourceManager = ResourceManager.getInstance();
        super();
        this._view = view;
        this._view.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.collectionEventHandler, false, 0, true);
        this.currentIndex = (((view.length > 0)) ? 0 : AFTER_LAST_INDEX);
        if (this.currentIndex == 0)
        {
            try
            {
                this.setCurrent(view.getItemAt(0), false);
            }
            catch(e:ItemPendingError)
            {
                currentIndex = BEFORE_FIRST_INDEX;
                setCurrent(null, false);
            };
        };
    }

    public function get view():ICollectionView
    {
        this.checkValid();
        return (this._view);
    }

    [Bindable("cursorUpdate")]
    public function get current():Object
    {
        this.checkValid();
        return (this.currentValue);
    }

    [Bindable("cursorUpdate")]
    public function get bookmark():CursorBookmark
    {
        this.checkValid();
        if ((((this.view.length == 0)) || (this.beforeFirst)))
        {
            return (CursorBookmark.FIRST);
        };
        if (this.afterLast)
        {
            return (CursorBookmark.LAST);
        };
        return (ListCollectionView(this.view).getBookmark(this.currentIndex));
    }

    [Bindable("cursorUpdate")]
    public function get beforeFirst():Boolean
    {
        this.checkValid();
        return ((((this.currentIndex == BEFORE_FIRST_INDEX)) || ((this.view.length == 0))));
    }

    [Bindable("cursorUpdate")]
    public function get afterLast():Boolean
    {
        this.checkValid();
        return ((((this.currentIndex == AFTER_LAST_INDEX)) || ((this.view.length == 0))));
    }

    public function findAny(_arg1:Object):Boolean
    {
        var index:int;
        var values:Object = _arg1;
        this.checkValid();
        var lcView:ListCollectionView = ListCollectionView(this.view);
        try
        {
            index = lcView.findItem(values, Sort.ANY_INDEX_MODE);
        }
        catch(e:SortError)
        {
            throw (new CursorError(e.message));
        };
        if (index > -1)
        {
            this.currentIndex = index;
            this.setCurrent(lcView.getItemAt(this.currentIndex));
        };
        return ((index > -1));
    }

    public function findFirst(_arg1:Object):Boolean
    {
        var index:int;
        var values:Object = _arg1;
        this.checkValid();
        var lcView:ListCollectionView = ListCollectionView(this.view);
        try
        {
            index = lcView.findItem(values, Sort.FIRST_INDEX_MODE);
        }
        catch(sortError:SortError)
        {
            throw (new CursorError(sortError.message));
        };
        if (index > -1)
        {
            this.currentIndex = index;
            this.setCurrent(lcView.getItemAt(this.currentIndex));
        };
        return ((index > -1));
    }

    public function findLast(_arg1:Object):Boolean
    {
        var index:int;
        var values:Object = _arg1;
        this.checkValid();
        var lcView:ListCollectionView = ListCollectionView(this.view);
        try
        {
            index = lcView.findItem(values, Sort.LAST_INDEX_MODE);
        }
        catch(sortError:SortError)
        {
            throw (new CursorError(sortError.message));
        };
        if (index > -1)
        {
            this.currentIndex = index;
            this.setCurrent(lcView.getItemAt(this.currentIndex));
        };
        return ((index > -1));
    }

    public function insert(_arg1:Object):void
    {
        var _local2:int;
        var _local3:String;
        if (this.afterLast)
        {
            _local2 = this.view.length;
        }
        else
        {
            if (this.beforeFirst)
            {
                if (this.view.length > 0)
                {
                    _local3 = this.resourceManager.getString("collections", "invalidInsert");
                    throw (new CursorError(_local3));
                };
                _local2 = 0;
            }
            else
            {
                _local2 = this.currentIndex;
            };
        };
        ListCollectionView(this.view).addItemAt(_arg1, _local2);
    }

    public function moveNext():Boolean
    {
        if (this.afterLast)
        {
            return (false);
        };
        var _local1:int = ((this.beforeFirst) ? 0 : (this.currentIndex + 1));
        if (_local1 >= this.view.length)
        {
            _local1 = AFTER_LAST_INDEX;
            this.setCurrent(null);
        }
        else
        {
            this.setCurrent(ListCollectionView(this.view).getItemAt(_local1));
        };
        this.currentIndex = _local1;
        return (!(this.afterLast));
    }

    public function movePrevious():Boolean
    {
        if (this.beforeFirst)
        {
            return (false);
        };
        var _local1:int = ((this.afterLast) ? (this.view.length - 1) : (this.currentIndex - 1));
        if (_local1 == -1)
        {
            _local1 = BEFORE_FIRST_INDEX;
            this.setCurrent(null);
        }
        else
        {
            this.setCurrent(ListCollectionView(this.view).getItemAt(_local1));
        };
        this.currentIndex = _local1;
        return (!(this.beforeFirst));
    }

    public function remove():Object
    {
        var oldIndex:int;
        var message:String;
        if (((this.beforeFirst) || (this.afterLast)))
        {
            message = this.resourceManager.getString("collections", "invalidRemove");
            throw (new CursorError(message));
        };
        oldIndex = this.currentIndex;
        this.currentIndex++;
        if (this.currentIndex >= this.view.length)
        {
            this.currentIndex = AFTER_LAST_INDEX;
            this.setCurrent(null);
        }
        else
        {
            try
            {
                this.setCurrent(ListCollectionView(this.view).getItemAt(this.currentIndex));
            }
            catch(e:ItemPendingError)
            {
                setCurrent(null, false);
                ListCollectionView(view).removeItemAt(oldIndex);
                throw (e);
            };
        };
        var removed:Object = ListCollectionView(this.view).removeItemAt(oldIndex);
        return (removed);
    }

    public function seek(_arg1:CursorBookmark, _arg2:int=0, _arg3:int=0):void
    {
        var message:String;
        var bookmark:CursorBookmark = _arg1;
        var offset:int = _arg2;
        var prefetch:int = _arg3;
        this.checkValid();
        if (this.view.length == 0)
        {
            this.currentIndex = AFTER_LAST_INDEX;
            this.setCurrent(null, false);
            return;
        };
        var newIndex:int = this.currentIndex;
        if (bookmark == CursorBookmark.FIRST)
        {
            newIndex = 0;
        }
        else
        {
            if (bookmark == CursorBookmark.LAST)
            {
                newIndex = (this.view.length - 1);
            }
            else
            {
                if (bookmark != CursorBookmark.CURRENT)
                {
                    try
                    {
                        newIndex = ListCollectionView(this.view).getBookmarkIndex(bookmark);
                        if (newIndex < 0)
                        {
                            this.setCurrent(null);
                            message = this.resourceManager.getString("collections", "bookmarkInvalid");
                            throw (new CursorError(message));
                        };
                    }
                    catch(bmError:CollectionViewError)
                    {
                        message = resourceManager.getString("collections", "bookmarkInvalid");
                        throw (new CursorError(message));
                    };
                };
            };
        };
        newIndex = (newIndex + offset);
        var newCurrent:Object;
        if (newIndex >= this.view.length)
        {
            this.currentIndex = AFTER_LAST_INDEX;
        }
        else
        {
            if (newIndex < 0)
            {
                this.currentIndex = BEFORE_FIRST_INDEX;
            }
            else
            {
                newCurrent = ListCollectionView(this.view).getItemAt(newIndex, prefetch);
                this.currentIndex = newIndex;
            };
        };
        this.setCurrent(newCurrent);
    }

    private function checkValid():void
    {
        var _local1:String;
        if (this.invalid)
        {
            _local1 = this.resourceManager.getString("collections", "invalidCursor");
            throw (new CursorError(_local1));
        };
    }

    private function collectionEventHandler(_arg1:CollectionEvent):void
    {
        var event:CollectionEvent = _arg1;
        switch (event.kind)
        {
            case CollectionEventKind.ADD:
                if (event.location <= this.currentIndex)
                {
                    this.currentIndex = (this.currentIndex + event.items.length);
                };
                return;
            case CollectionEventKind.REMOVE:
                if (event.location < this.currentIndex)
                {
                    this.currentIndex = (this.currentIndex - event.items.length);
                }
                else
                {
                    if (event.location == this.currentIndex)
                    {
                        if (this.currentIndex < this.view.length)
                        {
                            try
                            {
                                this.setCurrent(ListCollectionView(this.view).getItemAt(this.currentIndex));
                            }
                            catch(error:ItemPendingError)
                            {
                                setCurrent(null, false);
                            };
                        }
                        else
                        {
                            this.currentIndex = AFTER_LAST_INDEX;
                            this.setCurrent(null);
                        };
                    };
                };
                return;
            case CollectionEventKind.MOVE:
                if (event.oldLocation == this.currentIndex)
                {
                    this.currentIndex = event.location;
                }
                else
                {
                    if (event.oldLocation < this.currentIndex)
                    {
                        this.currentIndex = (this.currentIndex - event.items.length);
                    };
                    if (event.location <= this.currentIndex)
                    {
                        this.currentIndex = (this.currentIndex + event.items.length);
                    };
                };
                return;
            case CollectionEventKind.REFRESH:
                if (!((this.beforeFirst) || (this.afterLast)))
                {
                    try
                    {
                        this.currentIndex = ListCollectionView(this.view).getItemIndex(this.currentValue);
                    }
                    catch(e:SortError)
                    {
                        if (ListCollectionView(view).sort)
                        {
                            currentIndex = ListCollectionView(view).getLocalItemIndex(currentValue);
                        };
                    };
                    if (this.currentIndex == -1)
                    {
                        this.setCurrent(null);
                    };
                };
                return;
            case CollectionEventKind.REPLACE:
                if (event.location == this.currentIndex)
                {
                    try
                    {
                        this.setCurrent(ListCollectionView(this.view).getItemAt(this.currentIndex));
                    }
                    catch(error:ItemPendingError)
                    {
                        setCurrent(null, false);
                    };
                };
                return;
            case CollectionEventKind.RESET:
                this.currentIndex = BEFORE_FIRST_INDEX;
                this.setCurrent(null);
                return;
        };
    }

    private function setCurrent(_arg1:Object, _arg2:Boolean=true):void
    {
        this.currentValue = _arg1;
        if (_arg2)
        {
            dispatchEvent(new FlexEvent(FlexEvent.CURSOR_UPDATE));
        };
    }


}
class ListCollectionViewBookmark extends CursorBookmark 
{

    mx_internal var index:int;
    mx_internal var view:ListCollectionView;
    mx_internal var viewRevision:int;

    public function ListCollectionViewBookmark(_arg1:Object, _arg2:ListCollectionView, _arg3:int, _arg4:int)
    {
        super(_arg1);
        this.view = _arg2;
        this.viewRevision = _arg3;
        this.index = _arg4;
    }

    override public function getViewIndex():int
    {
        return (this.view.getBookmarkIndex(this));
    }


}
