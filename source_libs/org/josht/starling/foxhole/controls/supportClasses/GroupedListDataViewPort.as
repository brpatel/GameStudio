//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls.supportClasses
{
    import org.josht.starling.foxhole.core.FoxholeControl;
    import flash.geom.Point;
    import org.josht.starling.foxhole.layout.ViewPortBounds;
    import org.josht.starling.foxhole.layout.LayoutBoundsResult;
    import __AS3__.vec.Vector;
    import starling.display.DisplayObject;
    import org.josht.starling.foxhole.controls.renderers.IGroupedListItemRenderer;
    import flash.utils.Dictionary;
    import org.josht.starling.foxhole.controls.renderers.IGroupedListHeaderOrFooterRenderer;
    import org.josht.starling.foxhole.controls.GroupedList;
    import org.josht.starling.foxhole.data.HierarchicalCollection;
    import org.josht.starling.foxhole.core.PropertyProxy;
    import org.josht.starling.foxhole.layout.ILayout;
    import org.osflash.signals.Signal;
    import starling.events.TouchEvent;
    import org.osflash.signals.ISignal;
    import org.josht.starling.foxhole.layout.IVariableVirtualLayout;
    import starling.events.TouchPhase;
    import starling.events.Touch;
    import __AS3__.vec.*;

    public class GroupedListDataViewPort extends FoxholeControl implements IViewPort 
    {

        protected static const INVALIDATION_FLAG_ITEM_RENDERER_FACTORY:String = "itemRendererFactory";
        private static const helperPoint:Point = new Point();
        private static const helperBounds:ViewPortBounds = new ViewPortBounds();
        private static const helperResult:LayoutBoundsResult = new LayoutBoundsResult();

        private var _minVisibleWidth:Number = 0;
        private var _maxVisibleWidth:Number = Infinity;
        protected var actualVisibleWidth:Number = NaN;
        protected var explicitVisibleWidth:Number = NaN;
        private var _minVisibleHeight:Number = 0;
        private var _maxVisibleHeight:Number = Infinity;
        protected var actualVisibleHeight:Number;
        protected var explicitVisibleHeight:Number = NaN;
        private var _typicalItemWidth:Number = NaN;
        private var _typicalItemHeight:Number = NaN;
        private var _typicalHeaderWidth:Number = NaN;
        private var _typicalHeaderHeight:Number = NaN;
        private var _typicalFooterWidth:Number = NaN;
        private var _typicalFooterHeight:Number = NaN;
        private var _layoutItems:Vector.<DisplayObject>;
        private var _unrenderedItems:Array;
        private var _inactiveItemRenderers:Vector.<IGroupedListItemRenderer>;
        private var _activeItemRenderers:Vector.<IGroupedListItemRenderer>;
        private var _itemRendererMap:Dictionary;
        private var _unrenderedHeaders:Vector.<int>;
        private var _inactiveHeaderRenderers:Vector.<IGroupedListHeaderOrFooterRenderer>;
        private var _activeHeaderRenderers:Vector.<IGroupedListHeaderOrFooterRenderer>;
        private var _headerRendererMap:Dictionary;
        private var _unrenderedFooters:Vector.<int>;
        private var _inactiveFooterRenderers:Vector.<IGroupedListHeaderOrFooterRenderer>;
        private var _activeFooterRenderers:Vector.<IGroupedListHeaderOrFooterRenderer>;
        private var _footerRendererMap:Dictionary;
        private var _headerIndices:Vector.<int>;
        private var _footerIndices:Vector.<int>;
        private var _isScrolling:Boolean = false;
        private var _owner:GroupedList;
        private var _dataProvider:HierarchicalCollection;
        protected var _isSelectable:Boolean = true;
        protected var _selectedGroupIndex:int = -1;
        private var _selectedItemIndex:int = -1;
        private var _itemRendererType:Class;
        private var _itemRendererFactory:Function;
        protected var _itemRendererName:String;
        private var _typicalItem:Object = null;
        private var _typicalHeader:Object = null;
        private var _typicalFooter:Object = null;
        private var _itemRendererProperties:PropertyProxy;
        private var _headerRendererType:Class;
        private var _headerRendererFactory:Function;
        protected var _headerRendererName:String;
        private var _headerRendererProperties:PropertyProxy;
        private var _footerRendererType:Class;
        private var _footerRendererFactory:Function;
        protected var _footerRendererName:String;
        private var _footerRendererProperties:PropertyProxy;
        private var _ignoreLayoutChanges:Boolean = false;
        private var _layout:ILayout;
        private var _horizontalScrollPosition:Number = 0;
        private var _verticalScrollPosition:Number = 0;
        private var _minimumItemCount:int;
        private var _minimumHeaderCount:int;
        private var _minimumFooterCount:int;
        private var _ignoreSelectionChanges:Boolean = false;
        protected var _onChange:Signal;
        protected var _onItemTouch:Signal;

        public function GroupedListDataViewPort()
        {
            this._layoutItems = new <DisplayObject>[];
            this._unrenderedItems = [];
            this._inactiveItemRenderers = new <IGroupedListItemRenderer>[];
            this._activeItemRenderers = new <IGroupedListItemRenderer>[];
            this._itemRendererMap = new Dictionary(true);
            this._unrenderedHeaders = new <int>[];
            this._inactiveHeaderRenderers = new <IGroupedListHeaderOrFooterRenderer>[];
            this._activeHeaderRenderers = new <IGroupedListHeaderOrFooterRenderer>[];
            this._headerRendererMap = new Dictionary(true);
            this._unrenderedFooters = new <int>[];
            this._inactiveFooterRenderers = new <IGroupedListHeaderOrFooterRenderer>[];
            this._activeFooterRenderers = new <IGroupedListHeaderOrFooterRenderer>[];
            this._footerRendererMap = new Dictionary(true);
            this._headerIndices = new <int>[];
            this._footerIndices = new <int>[];
            this._onChange = new Signal(GroupedListDataViewPort);
            this._onItemTouch = new Signal(GroupedListDataViewPort, Object, int, int, TouchEvent);
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

        public function get typicalItemWidth():Number
        {
            return (this._typicalItemWidth);
        }

        public function get typicalItemHeight():Number
        {
            return (this._typicalItemHeight);
        }

        public function get typicalHeaderWidth():Number
        {
            return (this._typicalHeaderWidth);
        }

        public function get typicalHeaderHeight():Number
        {
            return (this._typicalHeaderHeight);
        }

        public function get typicalFooterWidth():Number
        {
            return (this._typicalFooterWidth);
        }

        public function get typicalFooterHeight():Number
        {
            return (this._typicalFooterHeight);
        }

        public function get owner():GroupedList
        {
            return (this._owner);
        }

        public function set owner(_arg1:GroupedList):void
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

        public function get dataProvider():HierarchicalCollection
        {
            return (this._dataProvider);
        }

        public function set dataProvider(_arg1:HierarchicalCollection):void
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
            if (!this._isSelectable)
            {
                this.setSelectedLocation(-1, -1);
            };
            this.invalidate(INVALIDATION_FLAG_SELECTED);
        }

        public function get selectedGroupIndex():int
        {
            return (this._selectedGroupIndex);
        }

        public function get selectedItemIndex():int
        {
            return (this._selectedItemIndex);
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
                for (_local2 in this._itemRendererMap)
                {
                    _local3 = (this._itemRendererMap[_local2] as FoxholeControl);
                    if (_local3)
                    {
                        _local3.nameList.remove(this._itemRendererName);
                    };
                };
            };
            this._itemRendererName = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
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

        public function get typicalHeader():Object
        {
            return (this._typicalHeader);
        }

        public function set typicalHeader(_arg1:Object):void
        {
            if (this._typicalHeader == _arg1)
            {
                return;
            };
            this._typicalHeader = _arg1;
            this.invalidate(INVALIDATION_FLAG_SCROLL);
        }

        public function get typicalFooter():Object
        {
            return (this._typicalFooter);
        }

        public function set typicalFooter(_arg1:Object):void
        {
            if (this._typicalFooter == _arg1)
            {
                return;
            };
            this._typicalFooter = _arg1;
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

        public function get headerRendererType():Class
        {
            return (this._headerRendererType);
        }

        public function set headerRendererType(_arg1:Class):void
        {
            if (this._headerRendererType == _arg1)
            {
                return;
            };
            this._headerRendererType = _arg1;
            this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
        }

        public function get headerRendererFactory():Function
        {
            return (this._headerRendererFactory);
        }

        public function set headerRendererFactory(_arg1:Function):void
        {
            if (this._headerRendererFactory === _arg1)
            {
                return;
            };
            this._headerRendererFactory = _arg1;
            this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
        }

        public function get headerRendererName():String
        {
            return (this._headerRendererName);
        }

        public function set headerRendererName(_arg1:String):void
        {
            var _local2:Object;
            var _local3:FoxholeControl;
            if (this._headerRendererName == _arg1)
            {
                return;
            };
            if (this._headerRendererName)
            {
                for (_local2 in this._headerRendererMap)
                {
                    _local3 = (this._headerRendererMap[_local2] as FoxholeControl);
                    if (_local3)
                    {
                        _local3.nameList.remove(this._headerRendererName);
                    };
                };
            };
            this._headerRendererName = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get headerRendererProperties():PropertyProxy
        {
            return (this._headerRendererProperties);
        }

        public function set headerRendererProperties(_arg1:PropertyProxy):void
        {
            if (this._headerRendererProperties == _arg1)
            {
                return;
            };
            if (this._headerRendererProperties)
            {
                this._headerRendererProperties.onChange.remove(this.headerRendererProperties_onChange);
            };
            this._headerRendererProperties = PropertyProxy(_arg1);
            if (this._headerRendererProperties)
            {
                this._headerRendererProperties.onChange.add(this.headerRendererProperties_onChange);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES, INVALIDATION_FLAG_SCROLL);
        }

        public function get footerRendererType():Class
        {
            return (this._footerRendererType);
        }

        public function set footerRendererType(_arg1:Class):void
        {
            if (this._footerRendererType == _arg1)
            {
                return;
            };
            this._footerRendererType = _arg1;
            this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
        }

        public function get footerRendererFactory():Function
        {
            return (this._footerRendererFactory);
        }

        public function set footerRendererFactory(_arg1:Function):void
        {
            if (this._footerRendererFactory === _arg1)
            {
                return;
            };
            this._footerRendererFactory = _arg1;
            this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
        }

        public function get footerRendererName():String
        {
            return (this._footerRendererName);
        }

        public function set footerRendererName(_arg1:String):void
        {
            var _local2:Object;
            var _local3:FoxholeControl;
            if (this._footerRendererName == _arg1)
            {
                return;
            };
            if (this._footerRendererName)
            {
                for (_local2 in this._footerRendererMap)
                {
                    _local3 = (this._footerRendererMap[_local2] as FoxholeControl);
                    if (_local3)
                    {
                        _local3.nameList.remove(this._footerRendererName);
                    };
                };
            };
            this._footerRendererName = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get footerRendererProperties():PropertyProxy
        {
            return (this._footerRendererProperties);
        }

        public function set footerRendererProperties(_arg1:PropertyProxy):void
        {
            if (this._footerRendererProperties == _arg1)
            {
                return;
            };
            if (this._footerRendererProperties)
            {
                this._footerRendererProperties.onChange.remove(this.footerRendererProperties_onChange);
            };
            this._footerRendererProperties = PropertyProxy(_arg1);
            if (this._footerRendererProperties)
            {
                this._footerRendererProperties.onChange.add(this.footerRendererProperties_onChange);
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

        public function setSelectedLocation(_arg1:int, _arg2:int):void
        {
            if ((((this._selectedGroupIndex == _arg1)) && ((this._selectedItemIndex == _arg2))))
            {
                return;
            };
            if ((((((_arg1 < 0)) && ((_arg2 >= 0)))) || ((((_arg1 >= 0)) && ((_arg2 < 0))))))
            {
                throw (new ArgumentError("To deselect items, group index and item index must both be < 0."));
            };
            this._selectedGroupIndex = _arg1;
            this._selectedItemIndex = _arg2;
            this.invalidate(INVALIDATION_FLAG_SELECTED);
            this._onChange.dispatch(this);
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
                this.refreshHeaderRendererStyles();
                this.refreshFooterRendererStyles();
                this.refreshItemRendererStyles();
            };
            if (((((((((_local2) || (_local4))) || (_local3))) || (_local1))) || (_local5)))
            {
                this.refreshSelection();
            };
            var _local8:int = this._activeItemRenderers.length;
            var _local9:int;
            while (_local9 < _local8)
            {
                _local10 = DisplayObject(this._activeItemRenderers[_local9]);
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
            _local8 = this._activeHeaderRenderers.length;
            _local9 = 0;
            while (_local9 < _local8)
            {
                _local10 = DisplayObject(this._activeHeaderRenderers[_local9]);
                if ((_local10 is FoxholeControl))
                {
                    _local11 = FoxholeControl(_local10);
                    if (((((((_local7) || (_local1))) || (_local2))) || (_local5)))
                    {
                        _local11.isEnabled = this._isEnabled;
                    };
                    if (((((_local6) && (this._headerRendererName))) && (!(_local11.nameList.contains(this._headerRendererName)))))
                    {
                        _local11.nameList.add(this._headerRendererName);
                    };
                    _local11.validate();
                };
                _local9++;
            };
            _local8 = this._activeFooterRenderers.length;
            _local9 = 0;
            while (_local9 < _local8)
            {
                _local10 = DisplayObject(this._activeFooterRenderers[_local9]);
                if ((_local10 is FoxholeControl))
                {
                    _local11 = FoxholeControl(_local10);
                    if (((((((_local7) || (_local1))) || (_local2))) || (_local5)))
                    {
                        _local11.isEnabled = this._isEnabled;
                    };
                    if (((((_local6) && (this._footerRendererName))) && (!(_local11.nameList.contains(this._footerRendererName)))))
                    {
                        _local11.nameList.add(this._footerRendererName);
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
            var _local5:Object;
            var _local6:IGroupedListHeaderOrFooterRenderer;
            var _local7:DisplayObject;
            var _local8:IGroupedListHeaderOrFooterRenderer;
            var _local1:Object = this._typicalHeader;
            var _local2:Object = this._typicalFooter;
            if (((((((!(_local1)) || (!(this._typicalFooter)))) && (this._dataProvider))) && ((this._dataProvider.getLength() > 0))))
            {
                _local5 = this._dataProvider.getItemAt(0);
                if (!_local1)
                {
                    _local1 = this._owner.groupToHeaderData(_local5);
                };
                if (!_local2)
                {
                    _local2 = this._owner.groupToFooterData(_local5);
                };
            };
            if (_local1)
            {
                _local6 = this.createHeaderRenderer(_local1, 0, true);
                this.refreshOneHeaderRendererStyles(_local6);
                if ((_local6 is FoxholeControl))
                {
                    FoxholeControl(_local6).validate();
                };
                _local7 = DisplayObject(_local6);
                this._typicalHeaderWidth = _local7.width;
                this._typicalHeaderHeight = _local7.height;
                this.destroyHeaderRenderer(_local6);
            };
            if (_local2)
            {
                _local8 = this.createFooterRenderer(_local2, 0, true);
                this.refreshOneFooterRendererStyles(_local8);
                if ((_local8 is FoxholeControl))
                {
                    FoxholeControl(_local8).validate();
                };
                _local7 = DisplayObject(_local8);
                this._typicalFooterWidth = _local7.width;
                this._typicalFooterHeight = _local7.height;
                this.destroyFooterRenderer(_local8);
            };
            var _local3:Object = this._typicalItem;
            if (((((!(_local3)) && (this._dataProvider))) && ((this._dataProvider.getLength() > 0))))
            {
                _local3 = this._dataProvider.getItemAt(0);
            };
            var _local4:IGroupedListItemRenderer = this.createItemRenderer(_local3, 0, 0, true);
            this.refreshOneItemRendererStyles(_local4);
            if ((_local4 is FoxholeControl))
            {
                FoxholeControl(_local4).validate();
            };
            _local7 = DisplayObject(_local4);
            this._typicalItemWidth = _local7.width;
            this._typicalItemHeight = _local7.height;
            this.destroyItemRenderer(_local4);
        }

        public function itemToItemRenderer(_arg1:Object):IGroupedListItemRenderer
        {
            return (IGroupedListItemRenderer(this._itemRendererMap[_arg1]));
        }

        protected function refreshItemRendererStyles():void
        {
            var _local1:IGroupedListItemRenderer;
            for each (_local1 in this._activeItemRenderers)
            {
                this.refreshOneItemRendererStyles(_local1);
            };
        }

        protected function refreshHeaderRendererStyles():void
        {
            var _local1:IGroupedListHeaderOrFooterRenderer;
            for each (_local1 in this._activeHeaderRenderers)
            {
                this.refreshOneHeaderRendererStyles(_local1);
            };
        }

        protected function refreshFooterRendererStyles():void
        {
            var _local1:IGroupedListHeaderOrFooterRenderer;
            for each (_local1 in this._activeFooterRenderers)
            {
                this.refreshOneFooterRendererStyles(_local1);
            };
        }

        protected function refreshOneItemRendererStyles(_arg1:IGroupedListItemRenderer):void
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

        protected function refreshOneHeaderRendererStyles(_arg1:IGroupedListHeaderOrFooterRenderer):void
        {
            var _local3:String;
            var _local4:Object;
            var _local2:DisplayObject = DisplayObject(_arg1);
            for (_local3 in this._headerRendererProperties)
            {
                if (_local2.hasOwnProperty(_local3))
                {
                    _local4 = this._headerRendererProperties[_local3];
                    _local2[_local3] = _local4;
                };
            };
        }

        protected function refreshOneFooterRendererStyles(_arg1:IGroupedListHeaderOrFooterRenderer):void
        {
            var _local3:String;
            var _local4:Object;
            var _local2:DisplayObject = DisplayObject(_arg1);
            for (_local3 in this._footerRendererProperties)
            {
                if (_local2.hasOwnProperty(_local3))
                {
                    _local4 = this._footerRendererProperties[_local3];
                    _local2[_local3] = _local4;
                };
            };
        }

        protected function refreshSelection():void
        {
            var _local1:IGroupedListItemRenderer;
            this._ignoreSelectionChanges = true;
            for each (_local1 in this._activeItemRenderers)
            {
                _local1.isSelected = (((_local1.groupIndex == this._selectedGroupIndex)) && ((_local1.itemIndex == this._selectedItemIndex)));
            };
            this._ignoreSelectionChanges = false;
        }

        protected function refreshRenderers(_arg1:Boolean):void
        {
            var _local2:Vector.<IGroupedListItemRenderer> = this._inactiveItemRenderers;
            this._inactiveItemRenderers = this._activeItemRenderers;
            this._activeItemRenderers = _local2;
            this._activeItemRenderers.length = 0;
            var _local3:Vector.<IGroupedListHeaderOrFooterRenderer> = this._inactiveHeaderRenderers;
            this._inactiveHeaderRenderers = this._activeHeaderRenderers;
            this._activeHeaderRenderers = _local3;
            this._activeHeaderRenderers.length = 0;
            _local3 = this._inactiveFooterRenderers;
            this._inactiveFooterRenderers = this._activeFooterRenderers;
            this._activeFooterRenderers = _local3;
            this._activeFooterRenderers.length = 0;
            if (_arg1)
            {
                this.recoverInactiveRenderers();
                this.freeInactiveRenderers();
            };
            this._headerIndices.length = 0;
            this._footerIndices.length = 0;
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
            var _local9:IVariableVirtualLayout;
            var _local12:Object;
            var _local13:int;
            var _local14:Object;
            var _local15:int;
            var _local16:Object;
            var _local17:IGroupedListHeaderOrFooterRenderer;
            var _local18:DisplayObject;
            var _local19:Object;
            var _local20:IGroupedListItemRenderer;
            var _local1:int = ((this._dataProvider) ? this._dataProvider.getLength() : 0);
            var _local2:int;
            var _local3:int;
            var _local4:int;
            var _local5:int;
            var _local6:int;
            while (_local6 < _local1)
            {
                _local12 = this._dataProvider.getItemAt(_local6);
                if (this._owner.groupToHeaderData(_local12) !== null)
                {
                    this._headerIndices.push(_local2);
                    _local2++;
                    _local3++;
                };
                _local13 = this._dataProvider.getLength(_local6);
                _local2 = (_local2 + _local13);
                _local5 = (_local5 + _local13);
                if (this._owner.groupToFooterData(_local12) !== null)
                {
                    this._footerIndices.push(_local2);
                    _local2++;
                    _local4++;
                };
                _local6++;
            };
            this._layoutItems.length = _local2;
            var _local7:int;
            var _local8:int = (_local2 - 1);
            _local9 = (this._layout as IVariableVirtualLayout);
            var _local10:Boolean = ((_local9) && (_local9.useVirtualLayout));
            if (_local10)
            {
                this._ignoreLayoutChanges = true;
                _local9.indexToItemBoundsFunction = this.indexToItemBoundsFunction;
                this._ignoreLayoutChanges = false;
                _local9.measureViewPort(_local2, helperBounds, helperPoint);
                _local7 = _local9.getMinimumItemIndexAtScrollPosition(this._horizontalScrollPosition, this._verticalScrollPosition, helperPoint.x, helperPoint.y, _local2);
                _local8 = _local9.getMaximumItemIndexAtScrollPosition(this._horizontalScrollPosition, this._verticalScrollPosition, helperPoint.x, helperPoint.y, _local2);
                _local5 = (_local5 / _local1);
                this._minimumHeaderCount = (this._minimumFooterCount = Math.ceil((helperPoint.y / (this._typicalItemHeight * _local5))));
                this._minimumHeaderCount = Math.min(this._minimumHeaderCount, _local3);
                this._minimumFooterCount = Math.min(this._minimumFooterCount, _local4);
                this._minimumItemCount = (Math.ceil((helperPoint.y / this._typicalItemHeight)) + 1);
            };
            var _local11:int;
            _local6 = 0;
            while (_local6 < _local1)
            {
                _local12 = this._dataProvider.getItemAt(_local6);
                _local14 = this._owner.groupToHeaderData(_local12);
                if (_local14 !== null)
                {
                    if ((((_local11 < _local7)) || ((_local11 > _local8))))
                    {
                        this._layoutItems[_local11] = null;
                    }
                    else
                    {
                        _local17 = IGroupedListHeaderOrFooterRenderer(this._headerRendererMap[_local14]);
                        if (_local17)
                        {
                            _local17.groupIndex = _local6;
                            this._activeHeaderRenderers.push(_local17);
                            this._inactiveHeaderRenderers.splice(this._inactiveHeaderRenderers.indexOf(_local17), 1);
                            _local18 = DisplayObject(_local17);
                            _local18.visible = true;
                            this._layoutItems[_local11] = _local18;
                        }
                        else
                        {
                            this._unrenderedHeaders.push(_local6);
                            this._unrenderedHeaders.push(_local11);
                        };
                    };
                    _local11++;
                };
                _local13 = this._dataProvider.getLength(_local6);
                _local15 = 0;
                while (_local15 < _local13)
                {
                    if ((((_local11 < _local7)) || ((_local11 > _local8))))
                    {
                        this._layoutItems[_local11] = null;
                    }
                    else
                    {
                        _local19 = this._dataProvider.getItemAt(_local6, _local15);
                        _local20 = IGroupedListItemRenderer(this._itemRendererMap[_local19]);
                        if (_local20)
                        {
                            _local20.groupIndex = _local6;
                            _local20.itemIndex = _local15;
                            this._activeItemRenderers.push(_local20);
                            this._inactiveItemRenderers.splice(this._inactiveItemRenderers.indexOf(_local20), 1);
                            _local18 = DisplayObject(_local20);
                            _local18.visible = true;
                            this._layoutItems[_local11] = _local18;
                        }
                        else
                        {
                            this._unrenderedItems.push(_local6);
                            this._unrenderedItems.push(_local15);
                            this._unrenderedItems.push(_local11);
                        };
                    };
                    _local11++;
                    _local15++;
                };
                _local16 = this._owner.groupToFooterData(_local12);
                if (_local16 !== null)
                {
                    if ((((_local11 < _local7)) || ((_local11 > _local8))))
                    {
                        this._layoutItems[_local11] = null;
                    }
                    else
                    {
                        _local17 = IGroupedListHeaderOrFooterRenderer(this._footerRendererMap[_local16]);
                        if (_local17)
                        {
                            _local17.groupIndex = _local6;
                            this._activeFooterRenderers.push(_local17);
                            this._inactiveFooterRenderers.splice(this._inactiveFooterRenderers.indexOf(_local17), 1);
                            _local18 = DisplayObject(_local17);
                            _local18.visible = true;
                            this._layoutItems[_local11] = _local18;
                        }
                        else
                        {
                            this._unrenderedFooters.push(_local6);
                            this._unrenderedFooters.push(_local11);
                        };
                    };
                    _local11++;
                };
                _local6++;
            };
        }

        private function renderUnrenderedData():void
        {
            var _local3:int;
            var _local4:int;
            var _local5:int;
            var _local6:Object;
            var _local7:IGroupedListItemRenderer;
            var _local8:IGroupedListHeaderOrFooterRenderer;
            var _local1:int = this._unrenderedItems.length;
            var _local2:int;
            while (_local2 < _local1)
            {
                _local3 = this._unrenderedItems.shift();
                _local4 = this._unrenderedItems.shift();
                _local5 = this._unrenderedItems.shift();
                _local6 = this._dataProvider.getItemAt(_local3, _local4);
                _local7 = this.createItemRenderer(_local6, _local3, _local4, false);
                this._layoutItems[_local5] = DisplayObject(_local7);
                _local2 = (_local2 + 3);
            };
            _local1 = this._unrenderedHeaders.length;
            _local2 = 0;
            while (_local2 < _local1)
            {
                _local3 = this._unrenderedHeaders.shift();
                _local5 = this._unrenderedHeaders.shift();
                _local6 = this._dataProvider.getItemAt(_local3);
                _local6 = this._owner.groupToHeaderData(_local6);
                _local8 = this.createHeaderRenderer(_local6, _local3, false);
                this._layoutItems[_local5] = DisplayObject(_local8);
                _local2 = (_local2 + 2);
            };
            _local1 = this._unrenderedFooters.length;
            _local2 = 0;
            while (_local2 < _local1)
            {
                _local3 = this._unrenderedFooters.shift();
                _local5 = this._unrenderedFooters.shift();
                _local6 = this._dataProvider.getItemAt(_local3);
                _local6 = this._owner.groupToFooterData(_local6);
                _local8 = this.createFooterRenderer(_local6, _local3, false);
                this._layoutItems[_local5] = DisplayObject(_local8);
                _local2 = (_local2 + 2);
            };
        }

        private function recoverInactiveRenderers():void
        {
            var _local3:IGroupedListItemRenderer;
            var _local4:IGroupedListHeaderOrFooterRenderer;
            var _local1:int = this._inactiveItemRenderers.length;
            var _local2:int;
            while (_local2 < _local1)
            {
                _local3 = this._inactiveItemRenderers[_local2];
                delete this._itemRendererMap[_local3.data];
                _local2++;
            };
            _local1 = this._inactiveHeaderRenderers.length;
            _local2 = 0;
            while (_local2 < _local1)
            {
                _local4 = this._inactiveHeaderRenderers[_local2];
                delete this._headerRendererMap[_local4.data];
                _local2++;
            };
            _local1 = this._inactiveFooterRenderers.length;
            _local2 = 0;
            while (_local2 < _local1)
            {
                _local4 = this._inactiveFooterRenderers[_local2];
                delete this._footerRendererMap[_local4.data];
                _local2++;
            };
        }

        private function freeInactiveRenderers():void
        {
            var _local4:IGroupedListItemRenderer;
            var _local5:IGroupedListHeaderOrFooterRenderer;
            var _local1:int = Math.min((this._minimumItemCount - this._activeItemRenderers.length), this._inactiveItemRenderers.length);
            var _local2:int;
            while (_local2 < _local1)
            {
                _local4 = this._inactiveItemRenderers.shift();
                DisplayObject(_local4).visible = false;
                this._activeItemRenderers.push(_local4);
                _local2++;
            };
            var _local3:int = this._inactiveItemRenderers.length;
            _local2 = 0;
            while (_local2 < _local3)
            {
                _local4 = this._inactiveItemRenderers.shift();
                this.destroyItemRenderer(_local4);
                _local2++;
            };
            _local1 = Math.min((this._minimumHeaderCount - this._activeHeaderRenderers.length), this._inactiveHeaderRenderers.length);
            _local2 = 0;
            while (_local2 < _local1)
            {
                _local5 = this._inactiveHeaderRenderers.shift();
                DisplayObject(_local5).visible = false;
                this._activeHeaderRenderers.push(_local5);
                _local2++;
            };
            _local3 = this._inactiveHeaderRenderers.length;
            _local2 = 0;
            while (_local2 < _local3)
            {
                _local5 = this._inactiveHeaderRenderers.shift();
                this.destroyHeaderRenderer(_local5);
                _local2++;
            };
            _local1 = Math.min((this._minimumFooterCount - this._activeFooterRenderers.length), this._inactiveFooterRenderers.length);
            _local2 = 0;
            while (_local2 < _local1)
            {
                _local5 = this._inactiveFooterRenderers.shift();
                DisplayObject(_local5).visible = false;
                this._activeFooterRenderers.push(_local5);
                _local2++;
            };
            _local3 = this._inactiveFooterRenderers.length;
            _local2 = 0;
            while (_local2 < _local3)
            {
                _local5 = this._inactiveFooterRenderers.shift();
                this.destroyFooterRenderer(_local5);
                _local2++;
            };
        }

        private function createItemRenderer(_arg1:Object, _arg2:int, _arg3:int, _arg4:Boolean=false):IGroupedListItemRenderer
        {
            var _local5:IGroupedListItemRenderer;
            var _local6:DisplayObject;
            if (((_arg4) || ((this._inactiveItemRenderers.length == 0))))
            {
                if (this._itemRendererFactory != null)
                {
                    _local5 = IGroupedListItemRenderer(this._itemRendererFactory());
                }
                else
                {
                    _local5 = new this._itemRendererType();
                };
                _local5.onChange.add(this.renderer_onChange);
                _local6 = DisplayObject(_local5);
                _local6.addEventListener(TouchEvent.TOUCH, this.renderer_touchHandler);
                this.addChild(_local6);
            }
            else
            {
                _local5 = this._inactiveItemRenderers.shift();
            };
            _local5.data = _arg1;
            _local5.groupIndex = _arg2;
            _local5.itemIndex = _arg3;
            _local5.owner = this._owner;
            DisplayObject(_local5).visible = true;
            if (!_arg4)
            {
                this._itemRendererMap[_arg1] = _local5;
                this._activeItemRenderers.push(_local5);
            };
            return (_local5);
        }

        private function createHeaderRenderer(_arg1:Object, _arg2:int, _arg3:Boolean=false):IGroupedListHeaderOrFooterRenderer
        {
            var _local4:IGroupedListHeaderOrFooterRenderer;
            var _local5:DisplayObject;
            if (((_arg3) || ((this._inactiveHeaderRenderers.length == 0))))
            {
                if (this._headerRendererFactory != null)
                {
                    _local4 = IGroupedListHeaderOrFooterRenderer(this._headerRendererFactory());
                }
                else
                {
                    _local4 = new this._headerRendererType();
                };
                _local5 = DisplayObject(_local4);
                this.addChild(_local5);
            }
            else
            {
                _local4 = this._inactiveHeaderRenderers.shift();
            };
            _local4.data = _arg1;
            _local4.groupIndex = _arg2;
            _local4.owner = this._owner;
            DisplayObject(_local4).visible = true;
            if (!_arg3)
            {
                this._headerRendererMap[_arg1] = _local4;
                this._activeHeaderRenderers.push(_local4);
            };
            return (_local4);
        }

        private function createFooterRenderer(_arg1:Object, _arg2:int, _arg3:Boolean=false):IGroupedListHeaderOrFooterRenderer
        {
            var _local4:IGroupedListHeaderOrFooterRenderer;
            var _local5:DisplayObject;
            if (((_arg3) || ((this._inactiveFooterRenderers.length == 0))))
            {
                if (this._footerRendererFactory != null)
                {
                    _local4 = IGroupedListHeaderOrFooterRenderer(this._footerRendererFactory());
                }
                else
                {
                    _local4 = new this._footerRendererType();
                };
                _local5 = DisplayObject(_local4);
                this.addChild(_local5);
            }
            else
            {
                _local4 = this._inactiveFooterRenderers.shift();
            };
            _local4.data = _arg1;
            _local4.groupIndex = _arg2;
            _local4.owner = this._owner;
            DisplayObject(_local4).visible = true;
            if (!_arg3)
            {
                this._footerRendererMap[_arg1] = _local4;
                this._activeFooterRenderers.push(_local4);
            };
            return (_local4);
        }

        private function destroyItemRenderer(_arg1:IGroupedListItemRenderer):void
        {
            _arg1.onChange.remove(this.renderer_onChange);
            var _local2:DisplayObject = DisplayObject(_arg1);
            _local2.removeEventListener(TouchEvent.TOUCH, this.renderer_touchHandler);
            this.removeChild(_local2, true);
        }

        private function destroyHeaderRenderer(_arg1:IGroupedListHeaderOrFooterRenderer):void
        {
            var _local2:DisplayObject = DisplayObject(_arg1);
            this.removeChild(_local2, true);
        }

        private function destroyFooterRenderer(_arg1:IGroupedListHeaderOrFooterRenderer):void
        {
            var _local2:DisplayObject = DisplayObject(_arg1);
            this.removeChild(_local2, true);
        }

        private function indexToItemBoundsFunction(_arg1:int, _arg2:Point=null):Point
        {
            if (!_arg2)
            {
                _arg2 = new Point();
            };
            if (this._headerIndices.indexOf(_arg1) >= 0)
            {
                _arg2.x = this._typicalHeaderWidth;
                _arg2.y = this._typicalHeaderHeight;
            }
            else
            {
                if (this._footerIndices.indexOf(_arg1) >= 0)
                {
                    _arg2.x = this._typicalFooterWidth;
                    _arg2.y = this._typicalFooterHeight;
                }
                else
                {
                    _arg2.x = this._typicalItemWidth;
                    _arg2.y = this._typicalItemHeight;
                };
            };
            return (_arg2);
        }

        private function itemRendererProperties_onChange(_arg1:PropertyProxy, _arg2:Object):void
        {
            this.invalidate(INVALIDATION_FLAG_SCROLL, INVALIDATION_FLAG_STYLES);
        }

        private function headerRendererProperties_onChange(_arg1:PropertyProxy, _arg2:Object):void
        {
            this.invalidate(INVALIDATION_FLAG_SCROLL, INVALIDATION_FLAG_STYLES);
        }

        private function footerRendererProperties_onChange(_arg1:PropertyProxy, _arg2:Object):void
        {
            this.invalidate(INVALIDATION_FLAG_SCROLL, INVALIDATION_FLAG_STYLES);
        }

        private function owner_onScroll(_arg1:GroupedList):void
        {
            this._isScrolling = true;
        }

        private function dataProvider_onChange(_arg1:HierarchicalCollection):void
        {
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        private function dataProvider_onItemUpdate(_arg1:HierarchicalCollection, _arg2:int):void
        {
            var _local3:Object;
            _local3 = this._dataProvider.getItemAt(_arg2);
            var _local4:IGroupedListItemRenderer = IGroupedListItemRenderer(this._itemRendererMap[_local3]);
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

        private function renderer_onChange(_arg1:IGroupedListItemRenderer):void
        {
            if (this._ignoreSelectionChanges)
            {
                return;
            };
            var _local2:Boolean = (((this._selectedGroupIndex == _arg1.groupIndex)) && ((this._selectedItemIndex == _arg1.itemIndex)));
            if (((((!(this._isSelectable)) || (this._isScrolling))) || (_local2)))
            {
                _arg1.isSelected = _local2;
                return;
            };
            this.setSelectedLocation(_arg1.groupIndex, _arg1.itemIndex);
        }

        private function renderer_touchHandler(_arg1:TouchEvent):void
        {
            var _local2:IGroupedListItemRenderer;
            var _local3:DisplayObject;
            if (!this._isEnabled)
            {
                return;
            };
            _local2 = IGroupedListItemRenderer(_arg1.currentTarget);
            _local3 = DisplayObject(_local2);
            var _local4:Touch = _arg1.getTouch(_local3, TouchPhase.BEGAN);
            if (_local4)
            {
                this._isScrolling = false;
            };
            this._onItemTouch.dispatch(this, _local2.data, _local2.groupIndex, _local2.itemIndex, _arg1);
        }


    }
}//package org.josht.starling.foxhole.controls.supportClasses
