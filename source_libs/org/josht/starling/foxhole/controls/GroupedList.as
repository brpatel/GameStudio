//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls
{
    import org.josht.starling.foxhole.core.FoxholeControl;
    import flash.geom.Point;
    import org.josht.starling.foxhole.controls.supportClasses.GroupedListDataViewPort;
    import org.josht.starling.foxhole.layout.ILayout;
    import org.josht.starling.foxhole.data.HierarchicalCollection;
    import org.osflash.signals.Signal;
    import org.josht.starling.foxhole.core.PropertyProxy;
    import starling.display.DisplayObject;
    import starling.events.TouchEvent;
    import org.josht.starling.foxhole.controls.renderers.DefaultGroupedListItemRenderer;
    import org.josht.starling.foxhole.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
    import __AS3__.vec.Vector;
    import org.osflash.signals.ISignal;
    import org.josht.starling.foxhole.layout.VerticalLayout;
    import org.josht.starling.foxhole.layout.IVirtualLayout;

    public class GroupedList extends FoxholeControl 
    {

        private static const helperPoint:Point = new Point();

        protected var defaultScrollerName:String = "foxhole-list-scroller";
        protected var scroller:Scroller;
        protected var dataViewPort:GroupedListDataViewPort;
        protected var _scrollToGroupIndex:int = -1;
        protected var _scrollToItemIndex:int = -1;
        protected var _scrollToIndexDuration:Number;
        private var _layout:ILayout;
        protected var _horizontalScrollPosition:Number = 0;
        protected var _maxHorizontalScrollPosition:Number = 0;
        protected var _verticalScrollPosition:Number = 0;
        protected var _maxVerticalScrollPosition:Number = 0;
        protected var _dataProvider:HierarchicalCollection;
        protected var _isSelectable:Boolean = true;
        protected var _selectedGroupIndex:int = -1;
        private var _selectedItemIndex:int = -1;
        protected var _onChange:Signal;
        protected var _onScroll:Signal;
        protected var _onItemTouch:Signal;
        private var _scrollerProperties:PropertyProxy;
        protected var currentBackgroundSkin:DisplayObject;
        private var _backgroundSkin:DisplayObject;
        private var _backgroundDisabledSkin:DisplayObject;
        protected var _paddingTop:Number = 0;
        protected var _paddingRight:Number = 0;
        protected var _paddingBottom:Number = 0;
        protected var _paddingLeft:Number = 0;
        private var _itemRendererType:Class;
        private var _itemRendererFactory:Function;
        private var _typicalItem:Object = null;
        protected var _itemRendererName:String;
        private var _itemRendererProperties:PropertyProxy;
        private var _headerRendererType:Class;
        private var _headerRendererFactory:Function;
        private var _typicalHeader:Object = null;
        protected var _headerRendererName:String;
        private var _headerRendererProperties:PropertyProxy;
        private var _footerRendererType:Class;
        private var _footerRendererFactory:Function;
        private var _typicalFooter:Object = null;
        protected var _footerRendererName:String;
        private var _footerRendererProperties:PropertyProxy;
        protected var _headerField:String = "header";
        private var _headerFunction:Function;
        protected var _footerField:String = "footer";
        private var _footerFunction:Function;

        public function GroupedList()
        {
            this._onChange = new Signal(GroupedList);
            this._onScroll = new Signal(GroupedList);
            this._onItemTouch = new Signal(GroupedList, Object, int, int, TouchEvent);
            this._itemRendererType = DefaultGroupedListItemRenderer;
            this._headerRendererType = DefaultGroupedListHeaderOrFooterRenderer;
            this._footerRendererType = DefaultGroupedListHeaderOrFooterRenderer;
            super();
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
            this._layout = _arg1;
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
            if (isNaN(_arg1))
            {
                throw (new ArgumentError("horizontalScrollPosition cannot be NaN."));
            };
            this._horizontalScrollPosition = _arg1;
            this.invalidate(INVALIDATION_FLAG_SCROLL);
            this._onScroll.dispatch(this);
        }

        public function get maxHorizontalScrollPosition():Number
        {
            return (this._maxHorizontalScrollPosition);
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
            if (isNaN(_arg1))
            {
                throw (new ArgumentError("verticalScrollPosition cannot be NaN."));
            };
            this._verticalScrollPosition = _arg1;
            this.invalidate(INVALIDATION_FLAG_SCROLL);
            this._onScroll.dispatch(this);
        }

        public function get maxVerticalScrollPosition():Number
        {
            return (this._maxVerticalScrollPosition);
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
                this._dataProvider.onReset.remove(this.dataProvider_onReset);
            };
            this._dataProvider = _arg1;
            if (this._dataProvider)
            {
                this._dataProvider.onReset.add(this.dataProvider_onReset);
            };
            this.horizontalScrollPosition = 0;
            this.verticalScrollPosition = 0;
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

        public function get selectedItem():Object
        {
            if (((((!(this._dataProvider)) || ((this._selectedGroupIndex < 0)))) || ((this._selectedItemIndex < 0))))
            {
                return (null);
            };
            return (this._dataProvider.getItemAt(this._selectedGroupIndex, this._selectedItemIndex));
        }

        public function set selectedItem(_arg1:Object):void
        {
            var _local2:Vector.<int> = this._dataProvider.getItemLocation(_arg1);
            if (_local2.length == 2)
            {
                this.setSelectedLocation(_local2[0], _local2[1]);
            }
            else
            {
                this.setSelectedLocation(-1, -1);
            };
        }

        public function get onChange():ISignal
        {
            return (this._onChange);
        }

        public function get onScroll():ISignal
        {
            return (this._onScroll);
        }

        public function get onItemTouch():ISignal
        {
            return (this._onItemTouch);
        }

        public function get scrollerProperties():Object
        {
            if (!this._scrollerProperties)
            {
                this._scrollerProperties = new PropertyProxy(this.scrollerProperties_onChange);
            };
            return (this._scrollerProperties);
        }

        public function set scrollerProperties(_arg1:Object):void
        {
            var _local2:PropertyProxy;
            var _local3:String;
            if (this._scrollerProperties == _arg1)
            {
                return;
            };
            if (!_arg1)
            {
                _arg1 = new PropertyProxy();
            };
            if (!(_arg1 is PropertyProxy))
            {
                _local2 = new PropertyProxy();
                for (_local3 in _arg1)
                {
                    _local2[_local3] = _arg1[_local3];
                };
                _arg1 = _local2;
            };
            if (this._scrollerProperties)
            {
                this._scrollerProperties.onChange.remove(this.scrollerProperties_onChange);
            };
            this._scrollerProperties = PropertyProxy(_arg1);
            if (this._scrollerProperties)
            {
                this._scrollerProperties.onChange.add(this.scrollerProperties_onChange);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get backgroundSkin():DisplayObject
        {
            return (this._backgroundSkin);
        }

        public function set backgroundSkin(_arg1:DisplayObject):void
        {
            if (this._backgroundSkin == _arg1)
            {
                return;
            };
            if (((this._backgroundSkin) && (!((this._backgroundSkin == this._backgroundDisabledSkin)))))
            {
                this.removeChild(this._backgroundSkin);
            };
            this._backgroundSkin = _arg1;
            if (((this._backgroundSkin) && (!((this._backgroundSkin.parent == this)))))
            {
                this._backgroundSkin.visible = false;
                this.addChildAt(this._backgroundSkin, 0);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get backgroundDisabledSkin():DisplayObject
        {
            return (this._backgroundDisabledSkin);
        }

        public function set backgroundDisabledSkin(_arg1:DisplayObject):void
        {
            if (this._backgroundDisabledSkin == _arg1)
            {
                return;
            };
            if (((this._backgroundDisabledSkin) && (!((this._backgroundDisabledSkin == this._backgroundSkin)))))
            {
                this.removeChild(this._backgroundDisabledSkin);
            };
            this._backgroundDisabledSkin = _arg1;
            if (((this._backgroundDisabledSkin) && (!((this._backgroundDisabledSkin.parent == this)))))
            {
                this._backgroundDisabledSkin.visible = false;
                this.addChildAt(this._backgroundDisabledSkin, 0);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get paddingTop():Number
        {
            return (this._paddingTop);
        }

        public function set paddingTop(_arg1:Number):void
        {
            if (this._paddingTop == _arg1)
            {
                return;
            };
            this._paddingTop = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get paddingRight():Number
        {
            return (this._paddingRight);
        }

        public function set paddingRight(_arg1:Number):void
        {
            if (this._paddingRight == _arg1)
            {
                return;
            };
            this._paddingRight = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get paddingBottom():Number
        {
            return (this._paddingBottom);
        }

        public function set paddingBottom(_arg1:Number):void
        {
            if (this._paddingBottom == _arg1)
            {
                return;
            };
            this._paddingBottom = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get paddingLeft():Number
        {
            return (this._paddingLeft);
        }

        public function set paddingLeft(_arg1:Number):void
        {
            if (this._paddingLeft == _arg1)
            {
                return;
            };
            this._paddingLeft = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
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
            this.invalidate(INVALIDATION_FLAG_STYLES);
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
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get itemRendererName():String
        {
            return (this._itemRendererName);
        }

        public function set itemRendererName(_arg1:String):void
        {
            if (this._itemRendererName == _arg1)
            {
                return;
            };
            this._itemRendererName = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get itemRendererProperties():Object
        {
            if (!this._itemRendererProperties)
            {
                this._itemRendererProperties = new PropertyProxy(this.itemRendererProperties_onChange);
            };
            return (this._itemRendererProperties);
        }

        public function set itemRendererProperties(_arg1:Object):void
        {
            var _local2:PropertyProxy;
            var _local3:String;
            if (this._itemRendererProperties == _arg1)
            {
                return;
            };
            if (!_arg1)
            {
                _arg1 = new PropertyProxy();
            };
            if (!(_arg1 is PropertyProxy))
            {
                _local2 = new PropertyProxy();
                for (_local3 in _arg1)
                {
                    _local2[_local3] = _arg1[_local3];
                };
                _arg1 = _local2;
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
            this.invalidate(INVALIDATION_FLAG_STYLES);
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
            this.invalidate(INVALIDATION_FLAG_STYLES);
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
            this.invalidate(INVALIDATION_FLAG_STYLES);
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
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get headerRendererName():String
        {
            return (this._headerRendererName);
        }

        public function set headerRendererName(_arg1:String):void
        {
            if (this._headerRendererName == _arg1)
            {
                return;
            };
            this._headerRendererName = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get headerRendererProperties():Object
        {
            if (!this._headerRendererProperties)
            {
                this._headerRendererProperties = new PropertyProxy(this.headerRendererProperties_onChange);
            };
            return (this._headerRendererProperties);
        }

        public function set headerRendererProperties(_arg1:Object):void
        {
            var _local2:PropertyProxy;
            var _local3:String;
            if (this._headerRendererProperties == _arg1)
            {
                return;
            };
            if (!_arg1)
            {
                _arg1 = new PropertyProxy();
            };
            if (!(_arg1 is PropertyProxy))
            {
                _local2 = new PropertyProxy();
                for (_local3 in _arg1)
                {
                    _local2[_local3] = _arg1[_local3];
                };
                _arg1 = _local2;
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
            this.invalidate(INVALIDATION_FLAG_STYLES);
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
            this.invalidate(INVALIDATION_FLAG_STYLES);
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
            this.invalidate(INVALIDATION_FLAG_STYLES);
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
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get footerRendererName():String
        {
            return (this._footerRendererName);
        }

        public function set footerRendererName(_arg1:String):void
        {
            if (this._footerRendererName == _arg1)
            {
                return;
            };
            this._footerRendererName = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get footerRendererProperties():Object
        {
            if (!this._footerRendererProperties)
            {
                this._footerRendererProperties = new PropertyProxy(this.footerRendererProperties_onChange);
            };
            return (this._footerRendererProperties);
        }

        public function set footerRendererProperties(_arg1:Object):void
        {
            var _local2:PropertyProxy;
            var _local3:String;
            if (this._footerRendererProperties == _arg1)
            {
                return;
            };
            if (!_arg1)
            {
                _arg1 = new PropertyProxy();
            };
            if (!(_arg1 is PropertyProxy))
            {
                _local2 = new PropertyProxy();
                for (_local3 in _arg1)
                {
                    _local2[_local3] = _arg1[_local3];
                };
                _arg1 = _local2;
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
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get headerField():String
        {
            return (this._headerField);
        }

        public function set headerField(_arg1:String):void
        {
            if (this._headerField == _arg1)
            {
                return;
            };
            this._headerField = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get headerFunction():Function
        {
            return (this._headerFunction);
        }

        public function set headerFunction(_arg1:Function):void
        {
            if (this._headerFunction == _arg1)
            {
                return;
            };
            this._headerFunction = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get footerField():String
        {
            return (this._footerField);
        }

        public function set footerField(_arg1:String):void
        {
            if (this._footerField == _arg1)
            {
                return;
            };
            this._footerField = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get footerFunction():Function
        {
            return (this._footerFunction);
        }

        public function set footerFunction(_arg1:Function):void
        {
            if (this._footerFunction == _arg1)
            {
                return;
            };
            this._footerFunction = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function scrollToDisplayIndex(_arg1:int, _arg2:int, _arg3:Number=0):void
        {
            if ((((this._scrollToGroupIndex == _arg1)) && ((this._scrollToItemIndex == _arg2))))
            {
                return;
            };
            this._scrollToGroupIndex = _arg1;
            this._scrollToItemIndex = _arg2;
            this._scrollToIndexDuration = _arg3;
            this.invalidate(INVALIDATION_FLAG_SCROLL);
        }

        override public function dispose():void
        {
            this._onChange.removeAll();
            this._onScroll.removeAll();
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

        public function stopScrolling():void
        {
            if (!this.scroller)
            {
                return;
            };
            this.scroller.stopScrolling();
        }

        public function groupToHeaderData(_arg1:Object):Object
        {
            if (this._headerFunction != null)
            {
                return (this._headerFunction(_arg1));
            };
            if (((((!((this._headerField == null))) && (_arg1))) && (_arg1.hasOwnProperty(this._headerField))))
            {
                return (_arg1[this._headerField]);
            };
            return (null);
        }

        public function groupToFooterData(_arg1:Object):Object
        {
            if (this._footerFunction != null)
            {
                return (this._footerFunction(_arg1));
            };
            if (((((!((this._footerField == null))) && (_arg1))) && (_arg1.hasOwnProperty(this._footerField))))
            {
                return (_arg1[this._footerField]);
            };
            return (null);
        }

        override protected function initialize():void
        {
            var _local1:VerticalLayout;
            if (!this._layout)
            {
                _local1 = new VerticalLayout();
                _local1.useVirtualLayout = true;
                _local1.paddingTop = (_local1.paddingRight = (_local1.paddingBottom = (_local1.paddingLeft = 0)));
                _local1.gap = 0;
                _local1.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
                _local1.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
                this._layout = _local1;
            };
            if (!this.scroller)
            {
                this.scroller = new Scroller();
                this.scroller.nameList.add(this.defaultScrollerName);
                this.scroller.verticalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
                this.scroller.horizontalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
                this.scroller.onScroll.add(this.scroller_onScroll);
                this.addChild(this.scroller);
            };
            if (!this.dataViewPort)
            {
                this.dataViewPort = new GroupedListDataViewPort();
                this.dataViewPort.owner = this;
                this.dataViewPort.onChange.add(this.dataViewPort_onChange);
                this.dataViewPort.onItemTouch.add(this.dataViewPort_onItemTouch);
                this.scroller.viewPort = this.dataViewPort;
            };
        }

        override protected function draw():void
        {
            var _local5:Object;
            var _local6:DisplayObject;
            var _local7:int;
            var _local1:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
            var _local2:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
            var _local3:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
            var _local4:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
            if (_local3)
            {
                this.refreshScrollerStyles();
            };
            if (((((_local1) || (_local3))) || (_local4)))
            {
                this.refreshBackgroundSkin();
            };
            this.dataViewPort.isEnabled = this._isEnabled;
            this.dataViewPort.isSelectable = this._isSelectable;
            this.dataViewPort.setSelectedLocation(this._selectedGroupIndex, this._selectedItemIndex);
            this.dataViewPort.dataProvider = this._dataProvider;
            this.dataViewPort.itemRendererType = this._itemRendererType;
            this.dataViewPort.itemRendererFactory = this._itemRendererFactory;
            this.dataViewPort.itemRendererProperties = this._itemRendererProperties;
            this.dataViewPort.itemRendererName = this._itemRendererName;
            this.dataViewPort.typicalItem = this._typicalItem;
            this.dataViewPort.headerRendererType = this._headerRendererType;
            this.dataViewPort.headerRendererFactory = this._headerRendererFactory;
            this.dataViewPort.headerRendererProperties = this._headerRendererProperties;
            this.dataViewPort.headerRendererName = this._headerRendererName;
            this.dataViewPort.typicalHeader = this._typicalHeader;
            this.dataViewPort.footerRendererType = this._footerRendererType;
            this.dataViewPort.footerRendererFactory = this._footerRendererFactory;
            this.dataViewPort.footerRendererProperties = this._footerRendererProperties;
            this.dataViewPort.footerRendererName = this._footerRendererName;
            this.dataViewPort.typicalFooter = this._typicalFooter;
            this.dataViewPort.layout = this._layout;
            this.dataViewPort.horizontalScrollPosition = this._horizontalScrollPosition;
            this.dataViewPort.verticalScrollPosition = this._verticalScrollPosition;
            this.scroller.isEnabled = this._isEnabled;
            this.scroller.x = this._paddingLeft;
            this.scroller.y = this._paddingTop;
            this.scroller.horizontalScrollPosition = this._horizontalScrollPosition;
            this.scroller.verticalScrollPosition = this._verticalScrollPosition;
            if (((_local1) || (_local3)))
            {
                if (isNaN(this.explicitWidth))
                {
                    this.scroller.width = NaN;
                }
                else
                {
                    this.scroller.width = Math.max(0, ((this.explicitWidth - this._paddingLeft) - this._paddingRight));
                };
                if (isNaN(this.explicitHeight))
                {
                    this.scroller.height = NaN;
                }
                else
                {
                    this.scroller.height = Math.max(0, ((this.explicitHeight - this._paddingTop) - this._paddingBottom));
                };
                this.scroller.minWidth = Math.max(0, ((this._minWidth - this._paddingLeft) - this._paddingRight));
                this.scroller.maxWidth = Math.max(0, ((this._maxWidth - this._paddingLeft) - this._paddingRight));
                this.scroller.minHeight = Math.max(0, ((this._minHeight - this._paddingTop) - this._paddingBottom));
                this.scroller.maxHeight = Math.max(0, ((this._maxHeight - this._paddingTop) - this._paddingBottom));
            };
            _local1 = ((this.autoSizeIfNeeded()) || (_local1));
            if (((((_local1) || (_local3))) && (this.currentBackgroundSkin)))
            {
                this.currentBackgroundSkin.width = this.actualWidth;
                this.currentBackgroundSkin.height = this.actualHeight;
            };
            this.scroller.validate();
            this._maxHorizontalScrollPosition = this.scroller.maxHorizontalScrollPosition;
            this._maxVerticalScrollPosition = this.scroller.maxVerticalScrollPosition;
            this._horizontalScrollPosition = this.scroller.horizontalScrollPosition;
            this._verticalScrollPosition = this.scroller.verticalScrollPosition;
            if ((((this._scrollToGroupIndex >= 0)) && ((this._scrollToItemIndex >= 0))))
            {
                _local5 = this._dataProvider.getItemAt(this._scrollToGroupIndex, this._scrollToItemIndex);
                if ((_local5 is Object))
                {
                    _local6 = (this.dataViewPort.itemToItemRenderer(_local5) as DisplayObject);
                    if (_local6)
                    {
                        helperPoint.x = (((this._maxHorizontalScrollPosition > 0)) ? (_local6.x - ((this.dataViewPort.visibleWidth - _local6.width) / 2)) : 0);
                        helperPoint.y = (((this._maxVerticalScrollPosition > 0)) ? (_local6.y - ((this.dataViewPort.visibleHeight - _local6.height) / 2)) : 0);
                    }
                    else
                    {
                        if ((this._layout is IVirtualLayout))
                        {
                            _local7 = this.locationToDisplayIndex(this._scrollToGroupIndex, this._scrollToItemIndex);
                            if (_local7 >= 0)
                            {
                                IVirtualLayout(this._layout).getScrollPositionForItemIndexAndBounds(_local7, this.dataViewPort.visibleWidth, this.dataViewPort.visibleHeight, helperPoint);
                            }
                            else
                            {
                                helperPoint.x = this._horizontalScrollPosition;
                                helperPoint.y = this._verticalScrollPosition;
                            };
                        }
                        else
                        {
                            helperPoint.x = this._horizontalScrollPosition;
                            helperPoint.y = this._verticalScrollPosition;
                        };
                    };
                    if (this._scrollToIndexDuration > 0)
                    {
                        this.scroller.throwTo(Math.max(0, Math.min(helperPoint.x, this._maxHorizontalScrollPosition)), Math.max(0, Math.min(helperPoint.y, this._maxVerticalScrollPosition)), this._scrollToIndexDuration);
                    }
                    else
                    {
                        this.horizontalScrollPosition = Math.max(0, Math.min(helperPoint.x, this._maxHorizontalScrollPosition));
                        this.verticalScrollPosition = Math.max(0, Math.min(helperPoint.y, this._maxVerticalScrollPosition));
                    };
                };
                this._scrollToGroupIndex = -1;
                this._scrollToItemIndex = -1;
            };
            this.scroller.horizontalScrollStep = (this.scroller.verticalScrollStep = this.dataViewPort.typicalItemHeight);
        }

        protected function locationToDisplayIndex(_arg1:int, _arg2:int):int
        {
            var _local6:Object;
            var _local7:Object;
            var _local8:int;
            var _local9:int;
            var _local10:Object;
            var _local3:int;
            var _local4:int = this._dataProvider.getLength();
            var _local5:int;
            while (_local5 < _local4)
            {
                _local6 = this._dataProvider.getItemAt(_local5);
                _local7 = this.groupToHeaderData(_local6);
                if (_local7)
                {
                    _local3++;
                };
                _local8 = this._dataProvider.getLength(_local5);
                _local9 = 0;
                while (_local9 < _local8)
                {
                    if ((((_arg1 == _local5)) && ((_arg2 == _local9))))
                    {
                        return (_local3);
                    };
                    _local3++;
                    _local9++;
                };
                _local10 = this.groupToFooterData(_local6);
                if (_local10)
                {
                    _local3++;
                };
                _local5++;
            };
            return (-1);
        }

        protected function autoSizeIfNeeded():Boolean
        {
            var _local1:Boolean = isNaN(this.explicitWidth);
            var _local2:Boolean = isNaN(this.explicitHeight);
            if (((!(_local1)) && (!(_local2))))
            {
                return (false);
            };
            this.scroller.validate();
            var _local3:Number = this.explicitWidth;
            var _local4:Number = this.explicitHeight;
            if (_local1)
            {
                _local3 = ((this.scroller.width + this._paddingLeft) + this._paddingRight);
            };
            if (_local2)
            {
                _local4 = ((this.scroller.height + this._paddingTop) + this._paddingBottom);
            };
            return (this.setSizeInternal(_local3, _local4, false));
        }

        protected function refreshScrollerStyles():void
        {
            var _local1:String;
            var _local2:Object;
            for (_local1 in this._scrollerProperties)
            {
                if (this.scroller.hasOwnProperty(_local1))
                {
                    _local2 = this._scrollerProperties[_local1];
                    this.scroller[_local1] = _local2;
                };
            };
        }

        protected function refreshBackgroundSkin():void
        {
            this.currentBackgroundSkin = this._backgroundSkin;
            if (((!(this._isEnabled)) && (this._backgroundDisabledSkin)))
            {
                if (this._backgroundSkin)
                {
                    this._backgroundSkin.visible = false;
                };
                this.currentBackgroundSkin = this._backgroundDisabledSkin;
            }
            else
            {
                if (this._backgroundDisabledSkin)
                {
                    this._backgroundDisabledSkin.visible = false;
                };
            };
            if (this.currentBackgroundSkin)
            {
                this.currentBackgroundSkin.visible = true;
            };
        }

        protected function scrollerProperties_onChange(_arg1:PropertyProxy, _arg2:Object):void
        {
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        protected function itemRendererProperties_onChange(_arg1:PropertyProxy, _arg2:Object):void
        {
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        protected function headerRendererProperties_onChange(_arg1:PropertyProxy, _arg2:Object):void
        {
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        protected function footerRendererProperties_onChange(_arg1:PropertyProxy, _arg2:Object):void
        {
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        protected function dataProvider_onReset(_arg1:HierarchicalCollection):void
        {
            this.horizontalScrollPosition = 0;
            this.verticalScrollPosition = 0;
        }

        protected function scroller_onScroll(_arg1:Scroller):void
        {
            this._maxHorizontalScrollPosition = this.scroller.maxHorizontalScrollPosition;
            this._maxVerticalScrollPosition = this.scroller.maxVerticalScrollPosition;
            this.horizontalScrollPosition = this.scroller.horizontalScrollPosition;
            this.verticalScrollPosition = this.scroller.verticalScrollPosition;
        }

        protected function dataViewPort_onChange(_arg1:GroupedListDataViewPort):void
        {
            this.setSelectedLocation(this.dataViewPort.selectedGroupIndex, this.dataViewPort.selectedItemIndex);
        }

        protected function dataViewPort_onItemTouch(_arg1:GroupedListDataViewPort, _arg2:Object, _arg3:int, _arg4:int, _arg5:TouchEvent):void
        {
            this._onItemTouch.dispatch(this, _arg2, _arg3, _arg4, _arg5);
        }


    }
}//package org.josht.starling.foxhole.controls
