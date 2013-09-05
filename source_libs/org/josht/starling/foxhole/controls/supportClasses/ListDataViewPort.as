//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls.supportClasses
{
    import org.josht.starling.foxhole.core.FoxholeControl;
    import flash.geom.Point;
    import org.josht.starling.foxhole.layout.ViewPortBounds;
    import org.josht.starling.foxhole.layout.LayoutBoundsResult;
    import __AS3__.vec.Vector;
    import starling.display.DisplayObject;
    import org.josht.starling.foxhole.controls.renderers.IListItemRenderer;
    import flash.utils.Dictionary;
    import org.josht.starling.foxhole.controls.List;
    import org.josht.starling.foxhole.data.ListCollection;
    import org.josht.starling.foxhole.core.PropertyProxy;
    import org.josht.starling.foxhole.layout.ILayout;
    import org.osflash.signals.Signal;
    import starling.events.TouchEvent;
    import org.osflash.signals.ISignal;
    import org.josht.starling.foxhole.layout.IVirtualLayout;
    import starling.events.TouchPhase;
    import starling.events.Touch;
    import __AS3__.vec.*;
    import org.josht.starling.foxhole.controls.*;

    public class ListDataViewPort extends FoxholeControl implements IViewPort 
    {

        protected static const INVALIDATION_FLAG_ITEM_RENDERER_FACTORY:String = "itemRendererFactory";
        private static const helperPoint:Point = new Point();
        private static const helperBounds:ViewPortBounds = new ViewPortBounds();
        private static const helperResult:LayoutBoundsResult = new LayoutBoundsResult();

        private var _minVisibleWidth:Number = 0;
        private var _maxVisibleWidth:Number = Infinity;
        protected var actualVisibleWidth:Number = 0;
        protected var explicitVisibleWidth:Number = NaN;
        private var _minVisibleHeight:Number = 0;
        private var _maxVisibleHeight:Number = Infinity;
        protected var actualVisibleHeight:Number = 0;
        protected var explicitVisibleHeight:Number = NaN;
        private var _unrenderedData:Array;
        private var _layoutItems:Vector.<DisplayObject>;
        private var _inactiveRenderers:Vector.<IListItemRenderer>;
        private var _activeRenderers:Vector.<IListItemRenderer>;
        private var _rendererMap:Dictionary;
        private var _isScrolling:Boolean = false;
        private var _owner:List;
        private var _dataProvider:ListCollection;
        private var _itemRendererType:Class;
        private var _itemRendererFactory:Function;
        protected var _itemRendererName:String;
        private var _typicalItemWidth:Number = NaN;
        private var _typicalItemHeight:Number = NaN;
        private var _typicalItem:Object = null;
        private var _itemRendererProperties:PropertyProxy;
        private var _ignoreLayoutChanges:Boolean = false;
        private var _layout:ILayout;
        private var _horizontalScrollPosition:Number = 0;
        private var _verticalScrollPosition:Number = 0;
        private var _ignoreSelectionChanges:Boolean = false;
        private var _isSelectable:Boolean = true;
        private var _selectedIndex:int = -1;
        protected var _onChange:Signal;
        protected var _onItemTouch:Signal;

        public function ListDataViewPort()
        {
            this._unrenderedData = [];
            this._layoutItems = new <DisplayObject>[];
            this._inactiveRenderers = new <IListItemRenderer>[];
            this._activeRenderers = new <IListItemRenderer>[];
            this._rendererMap = new Dictionary(true);
            this._onChange = new Signal(ListDataViewPort);
            this._onItemTouch = new Signal(ListDataViewPort, Object, int, TouchEvent);
            super();
        }

        public function get minVisibleWidth():Number
        {
            return (this._minVisibleWidth);
        }

        public function set minVisibleWidth(_arg1:Number):void
        {
            if (this._minVisibleWidth == _arg1)
            {
                return;
            };
            if (isNaN(_arg1))
            {
                throw (new ArgumentError("minVisibleWidth cannot be NaN"));
            };
            this._minVisibleWidth = _arg1;
            this.invalidate(INVALIDATION_FLAG_SIZE);
        }

        public function get maxVisibleWidth():Number
        {
            return (this._maxVisibleWidth);
        }

        public function set maxVisibleWidth(_arg1:Number):void
        {
            if (this._maxVisibleWidth == _arg1)
            {
                return;
            };
            if (isNaN(_arg1))
            {
                throw (new ArgumentError("maxVisibleWidth cannot be NaN"));
            };
            this._maxVisibleWidth = _arg1;
            this.invalidate(INVALIDATION_FLAG_SIZE);
        }

        public function get visibleWidth():Number
        {
            return (this.actualVisibleWidth);
        }

        public function set visibleWidth(_arg1:Number):void
        {
            if ((((this.explicitVisibleWidth == _arg1)) || (((isNaN(_arg1)) && (isNaN(this.explicitVisibleWidth))))))
            {
                return;
            };
            this.explicitVisibleWidth = _arg1;
            this.invalidate(INVALIDATION_FLAG_SIZE);
        }

        public function get minVisibleHeight():Number
        {
            return (this._minVisibleHeight);
        }

        public function set minVisibleHeight(_arg1:Number):void
        {
            if (this._minVisibleHeight == _arg1)
            {
                return;
            };
            if (isNaN(_arg1))
            {
                throw (new ArgumentError("minVisibleHeight cannot be NaN"));
            };
            this._minVisibleHeight = _arg1;
            this.invalidate(INVALIDATION_FLAG_SIZE);
        }

        public function get maxVisibleHeight():Number
        {
            return (this._maxVisibleHeight);
        }

        public function set maxVisibleHeight(_arg1:Number):void
        {
            if (this._maxVisibleHeight == _arg1)
            {
                return;
            };
            if (isNaN(_arg1))
            {
                throw (new ArgumentError("maxVisibleHeight cannot be NaN"));
            };
            this._maxVisibleHeight = _arg1;
            this.invalidate(INVALIDATION_FLAG_SIZE);
        }

        public function get visibleHeight():Number
        {
            return (this.actualVisibleHeight);
        }

        public function set visibleHeight(_arg1:Number):void
        {
            if ((((this.explicitVisibleHeight == _arg1)) || (((isNaN(_arg1)) && (isNaN(this.explicitVisibleHeight))))))
            {
                return;
            };
            this.explicitVisibleHeight = _arg1;
            this.invalidate(INVALIDATION_FLAG_SIZE);
        }

        public function get owner():List
        {
            return (this._owner);
        }

        public function set owner(_arg1:List):void
        {
            if (this._owner == _arg1)
            {
                return;
            };
            if (this._owner)
            {
                this._owner.onScroll.remove(this.owner_onScroll);
            };
            this._owner = _arg1;
            if (this._owner)
            {
                this._owner.onScroll.add(this.owner_onScroll);
            };
        }

        public function get dataProvider():ListCollection
        {
            return (this._dataProvider);
        }

        public function set dataProvider(_arg1:ListCollection):void
        {
            if (this._dataProvider == _arg1)
            {
                return;
            };
            if (this._dataProvider)
            {
                this._dataProvider.onChange.remove(this.dataProvider_onChange);
                this._dataProvider.onItemUpdate.remove(this.dataProvider_onItemUpdate);
            };
            this._dataProvider = _arg1;
            if (this._dataProvider)
            {
                this._dataProvider.onChange.add(this.dataProvider_onChange);
                this._dataProvider.onItemUpdate.add(this.dataProvider_onItemUpdate);
            };
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get itemRendererType():Class
        {
            return (this._itemRendererType);
        }

        public function set itemRendererType(_arg1:Class):void
        {
            if (this._itemRendererType == _arg1)
            {
                return;
            };
            this._itemRendererType = _arg1;
            this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
        }

        public function get itemRendererFactory():Function
        {
            return (this._itemRendererFactory);
        }

        public function set itemRendererFactory(_arg1:Function):void
        {
            if (this._itemRendererFactory === _arg1)
            {
                return;
            };
            this._itemRendererFactory = _arg1;
            this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
        }

        public function get itemRendererName():String
        {
            return (this._itemRendererName);
        }

        public function set itemRendererName(_arg1:String):void
        {
            var _local2:Object;
            var _local3:FoxholeControl;
            if (this._itemRendererName == _arg1)
            {
                return;
            };
            if (this._itemRendererName)
            {
                for (_local2 in this._rendererMap)
                {
                    _local3 = (this._rendererMap[_local2] as FoxholeControl);
                    if (_local3)
                    {
                        _local3.nameList.remove(this._itemRendererName);
                    };
                };
            };
            this._itemRendererName = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get typicalItemWidth():Number
        {
            return (this._typicalItemWidth);
        }

        public function get typicalItemHeight():Number
        {
            return (this._typicalItemHeight);
        }

        public function get typicalItem():Object
        {
            return (this._typicalItem);
        }

        public function set typicalItem(_arg1:Object):void
        {
            if (this._typicalItem == _arg1)
            {
                return;
            };
            this._typicalItem = _arg1;
            this.invalidate(INVALIDATION_FLAG_SCROLL);
        }

        public function get itemRendererProperties():PropertyProxy
        {
            return (this._itemRendererProperties);
        }

        public function set itemRendererProperties(_arg1:PropertyProxy):void
        {
            if (this._itemRendererProperties == _arg1)
            {
                return;
            };
            if (this._itemRendererProperties)
            {
                this._itemRendererProperties.onChange.remove(this.itemRendererProperties_onChange);
            };
            this._itemRendererProperties = PropertyProxy(_arg1);
            if (this._itemRendererProperties)
            {
                this._itemRendererProperties.onChange.add(this.itemRendererProperties_onChange);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES, INVALIDATION_FLAG_SCROLL);
        }

        public function get layout():ILayout
        {
            return (this._layout);
        }

        public function set layout(_arg1:ILayout):void
        {
            if (this._layout == _arg1)
            {
                return;
            };
            if (this._layout)
            {
                this._layout.onLayoutChange.remove(this.layout_onLayoutChange);
            };
            this._layout = _arg1;
            if (this._layout)
            {
                this._layout.onLayoutChange.add(this.layout_onLayoutChange);
            };
            this.invalidate(INVALIDATION_FLAG_SCROLL);
        }

        public function get horizontalScrollPosition():Number
        {
            return (this._horizontalScrollPosition);
        }

        public function set horizontalScrollPosition(_arg1:Number):void
        {
            if (this._horizontalScrollPosition == _arg1)
            {
                return;
            };
            this._horizontalScrollPosition = _arg1;
            this.invalidate(INVALIDATION_FLAG_SCROLL);
        }

        public function get verticalScrollPosition():Number
        {
            return (this._verticalScrollPosition);
        }

        public function set verticalScrollPosition(_arg1:Number):void
        {
            if (this._verticalScrollPosition == _arg1)
            {
                return;
            };
            this._verticalScrollPosition = _arg1;
            this.invalidate(INVALIDATION_FLAG_SCROLL);
        }

        public function get isSelectable():Boolean
        {
            return (this._isSelectable);
        }

        public function set isSelectable(_arg1:Boolean):void
        {
            if (this._isSelectable == _arg1)
            {
                return;
            };
            this._isSelectable = _arg1;
            if (!_arg1)
            {
                this.selectedIndex = -1;
            };
        }

        public function get selectedIndex():int
        {
            return (this._selectedIndex);
        }

        public function set selectedIndex(_arg1:int):void
        {
            if (this._selectedIndex == _arg1)
            {
                return;
            };
            this._selectedIndex = _arg1;
            this.invalidate(INVALIDATION_FLAG_SELECTED);
            this._onChange.dispatch(this);
        }

        public function get onChange():ISignal
        {
            return (this._onChange);
        }

        public function get onItemTouch():ISignal
        {
            return (this._onItemTouch);
        }

        override public function dispose():void
        {
            this._onChange.removeAll();
            this._onItemTouch.removeAll();
            super.dispose();
        }

        override protected function draw():void
        {
            var _local10:DisplayObject;
            var _local11:FoxholeControl;
            var _local1:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
            var _local2:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
            var _local3:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
            var _local4:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
            var _local5:Boolean = this.isInvalid(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
            var _local6:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
            var _local7:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
            if (((((_local6) || (_local1))) || (_local5)))
            {
                this.calculateTypicalValues();
            };
            if (((((((_local2) || (_local3))) || (_local1))) || (_local5)))
            {
                this.refreshRenderers(_local5);
            };
            if (((((((((_local2) || (_local3))) || (_local1))) || (_local6))) || (_local5)))
            {
                this.refreshItemRendererStyles();
            };
            if (((((((((_local2) || (_local4))) || (_local3))) || (_local1))) || (_local5)))
            {
                this.refreshSelection();
            };
            var _local8:int = this._activeRenderers.length;
            var _local9:int;
            while (_local9 < _local8)
            {
                _local10 = DisplayObject(this._activeRenderers[_local9]);
                if ((_local10 is FoxholeControl))
                {
                    _local11 = FoxholeControl(_local10);
                    if (((((((_local7) || (_local1))) || (_local2))) || (_local5)))
                    {
                        _local11.isEnabled = this._isEnabled;
                    };
                    if (((((_local6) && (this._itemRendererName))) && (!(_local11.nameList.contains(this._itemRendererName)))))
                    {
                        _local11.nameList.add(this._itemRendererName);
                    };
                    _local11.validate();
                };
                _local9++;
            };
            if (((((((_local2) || (_local1))) || (_local5))) || (_local3)))
            {
                this._layout.layout(this._layoutItems, helperBounds, helperResult);
                this.setSizeInternal(helperResult.contentWidth, helperResult.contentHeight, false);
                this.actualVisibleWidth = helperResult.viewPortWidth;
                this.actualVisibleHeight = helperResult.viewPortHeight;
            };
        }

        protected function calculateTypicalValues():void
        {
            var _local1:Object = this._typicalItem;
            if (((((!(_local1)) && (this._dataProvider))) && ((this._dataProvider.length > 0))))
            {
                _local1 = this._dataProvider.getItemAt(0);
            };
            var _local2:IListItemRenderer = this.createRenderer(_local1, 0, true);
            this.refreshOneItemRendererStyles(_local2);
            if ((_local2 is FoxholeControl))
            {
                FoxholeControl(_local2).validate();
            };
            this._typicalItemWidth = DisplayObject(_local2).width;
            this._typicalItemHeight = DisplayObject(_local2).height;
            this.destroyRenderer(_local2);
        }

        public function itemToItemRenderer(_arg1:Object):IListItemRenderer
        {
            return (IListItemRenderer(this._rendererMap[_arg1]));
        }

        protected function refreshItemRendererStyles():void
        {
            var _local1:IListItemRenderer;
            for each (_local1 in this._activeRenderers)
            {
                this.refreshOneItemRendererStyles(_local1);
            };
        }

        protected function refreshOneItemRendererStyles(_arg1:IListItemRenderer):void
        {
            var _local3:String;
            var _local4:Object;
            var _local2:DisplayObject = DisplayObject(_arg1);
            for (_local3 in this._itemRendererProperties)
            {
                if (_local2.hasOwnProperty(_local3))
                {
                    _local4 = this._itemRendererProperties[_local3];
                    _local2[_local3] = _local4;
                };
            };
        }

        protected function refreshSelection():void
        {
            var _local1:IListItemRenderer;
            this._ignoreSelectionChanges = true;
            for each (_local1 in this._activeRenderers)
            {
                _local1.isSelected = (_local1.index == this._selectedIndex);
            };
            this._ignoreSelectionChanges = false;
        }

        protected function refreshRenderers(_arg1:Boolean):void
        {
            var _local2:Vector.<IListItemRenderer> = this._inactiveRenderers;
            this._inactiveRenderers = this._activeRenderers;
            this._activeRenderers = _local2;
            this._activeRenderers.length = 0;
            if (_arg1)
            {
                this.recoverInactiveRenderers();
                this.freeInactiveRenderers();
            };
            this._layoutItems.length = ((this._dataProvider) ? this._dataProvider.length : 0);
            helperBounds.x = (helperBounds.y = 0);
            helperBounds.explicitWidth = this.explicitVisibleWidth;
            helperBounds.explicitHeight = this.explicitVisibleHeight;
            helperBounds.minWidth = this._minVisibleWidth;
            helperBounds.minHeight = this._minVisibleHeight;
            helperBounds.maxWidth = this._maxVisibleWidth;
            helperBounds.maxHeight = this._maxVisibleHeight;
            this.findUnrenderedData();
            this.recoverInactiveRenderers();
            this.renderUnrenderedData();
            this.freeInactiveRenderers();
        }

        private function findUnrenderedData():void
        {
            var _local4:IVirtualLayout;
            var _local7:Object;
            var _local8:IListItemRenderer;
            var _local9:DisplayObject;
            var _local1:int = ((this._dataProvider) ? this._dataProvider.length : 0);
            var _local2:int;
            var _local3:int = (_local1 - 1);
            _local4 = (this._layout as IVirtualLayout);
            var _local5:Boolean = ((_local4) && (_local4.useVirtualLayout));
            if (_local5)
            {
                this._ignoreLayoutChanges = true;
                _local4.typicalItemWidth = this._typicalItemWidth;
                _local4.typicalItemHeight = this._typicalItemHeight;
                this._ignoreLayoutChanges = false;
                _local4.measureViewPort(_local1, helperBounds, helperPoint);
                _local2 = _local4.getMinimumItemIndexAtScrollPosition(this._horizontalScrollPosition, this._verticalScrollPosition, helperPoint.x, helperPoint.y, _local1);
                _local3 = _local4.getMaximumItemIndexAtScrollPosition(this._horizontalScrollPosition, this._verticalScrollPosition, helperPoint.x, helperPoint.y, _local1);
            };
            var _local6:int;
            while (_local6 < _local1)
            {
                if ((((_local6 < _local2)) || ((_local6 > _local3))))
                {
                    this._layoutItems[_local6] = null;
                }
                else
                {
                    _local7 = this._dataProvider.getItemAt(_local6);
                    _local8 = IListItemRenderer(this._rendererMap[_local7]);
                    if (_local8)
                    {
                        _local8.index = _local6;
                        this._activeRenderers.push(_local8);
                        this._inactiveRenderers.splice(this._inactiveRenderers.indexOf(_local8), 1);
                        _local9 = DisplayObject(_local8);
                        this._layoutItems[_local6] = _local9;
                    }
                    else
                    {
                        this._unrenderedData.push(_local7);
                    };
                };
                _local6++;
            };
        }

        private function renderUnrenderedData():void
        {
            var _local3:Object;
            var _local4:int;
            var _local5:IListItemRenderer;
            var _local6:DisplayObject;
            var _local1:int = this._unrenderedData.length;
            var _local2:int;
            while (_local2 < _local1)
            {
                _local3 = this._unrenderedData.shift();
                _local4 = this._dataProvider.getItemIndex(_local3);
                _local5 = this.createRenderer(_local3, _local4, false);
                _local6 = DisplayObject(_local5);
                this._layoutItems[_local4] = _local6;
                _local2++;
            };
        }

        private function recoverInactiveRenderers():void
        {
            var _local3:IListItemRenderer;
            var _local1:int = this._inactiveRenderers.length;
            var _local2:int;
            while (_local2 < _local1)
            {
                _local3 = this._inactiveRenderers[_local2];
                delete this._rendererMap[_local3.data];
                _local2++;
            };
        }

        private function freeInactiveRenderers():void
        {
            var _local3:IListItemRenderer;
            var _local1:int = this._inactiveRenderers.length;
            var _local2:int;
            while (_local2 < _local1)
            {
                _local3 = this._inactiveRenderers.shift();
                this.destroyRenderer(_local3);
                _local2++;
            };
        }

        private function createRenderer(_arg1:Object, _arg2:int, _arg3:Boolean=false):IListItemRenderer
        {
            var _local4:IListItemRenderer;
            var _local5:DisplayObject;
            if (((_arg3) || ((this._inactiveRenderers.length == 0))))
            {
                if (this._itemRendererFactory != null)
                {
                    _local4 = IListItemRenderer(this._itemRendererFactory());
                }
                else
                {
                    _local4 = new this._itemRendererType();
                };
                _local4.onChange.add(this.renderer_onChange);
                _local5 = DisplayObject(_local4);
                _local5.addEventListener(TouchEvent.TOUCH, this.renderer_touchHandler);
                this.addChild(_local5);
            }
            else
            {
                _local4 = this._inactiveRenderers.shift();
            };
            _local4.data = _arg1;
            _local4.index = _arg2;
            _local4.owner = this._owner;
            if (!_arg3)
            {
                this._rendererMap[_arg1] = _local4;
                this._activeRenderers.push(_local4);
            };
            return (_local4);
        }

        private function destroyRenderer(_arg1:IListItemRenderer):void
        {
            _arg1.onChange.remove(this.renderer_onChange);
            var _local2:DisplayObject = DisplayObject(_arg1);
            _local2.removeEventListener(TouchEvent.TOUCH, this.renderer_touchHandler);
            this.removeChild(_local2, true);
        }

        private function itemRendererProperties_onChange(_arg1:PropertyProxy, _arg2:Object):void
        {
            this.invalidate(INVALIDATION_FLAG_SCROLL, INVALIDATION_FLAG_STYLES);
        }

        private function owner_onScroll(_arg1:List):void
        {
            this._isScrolling = true;
        }

        private function dataProvider_onChange(_arg1:ListCollection):void
        {
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        private function dataProvider_onItemUpdate(_arg1:ListCollection, _arg2:int):void
        {
            var _local3:Object;
            _local3 = this._dataProvider.getItemAt(_arg2);
            var _local4:IListItemRenderer = IListItemRenderer(this._rendererMap[_local3]);
            _local4.data = null;
            _local4.data = _local3;
        }

        private function layout_onLayoutChange(_arg1:ILayout):void
        {
            if (this._ignoreLayoutChanges)
            {
                return;
            };
            this.invalidate(INVALIDATION_FLAG_SCROLL);
        }

        private function renderer_onChange(_arg1:IListItemRenderer):void
        {
            if (this._ignoreSelectionChanges)
            {
                return;
            };
            if (((((!(this._isSelectable)) || (this._isScrolling))) || ((this._selectedIndex == _arg1.index))))
            {
                _arg1.isSelected = (this._selectedIndex == _arg1.index);
                return;
            };
            this.selectedIndex = _arg1.index;
        }

        private function renderer_touchHandler(_arg1:TouchEvent):void
        {
            var _local2:IListItemRenderer;
            var _local3:DisplayObject;
            if (!this._isEnabled)
            {
                return;
            };
            _local2 = IListItemRenderer(_arg1.currentTarget);
            _local3 = DisplayObject(_local2);
            var _local4:Touch = _arg1.getTouch(_local3, TouchPhase.BEGAN);
            if (_local4)
            {
                this._isScrolling = false;
            };
            this._onItemTouch.dispatch(this, _local2.data, _local2.index, _arg1);
        }


    }
}//package org.josht.starling.foxhole.controls.supportClasses
