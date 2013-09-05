//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls
{
    import org.josht.starling.foxhole.core.FoxholeControl;
    import flash.geom.Point;
    import org.josht.starling.foxhole.controls.supportClasses.ListDataViewPort;
    import org.josht.starling.foxhole.layout.ILayout;
    import org.josht.starling.foxhole.data.ListCollection;
    import org.osflash.signals.Signal;
    import org.josht.starling.foxhole.core.PropertyProxy;
    import starling.display.DisplayObject;
    import starling.events.TouchEvent;
    import org.josht.starling.foxhole.controls.renderers.DefaultListItemRenderer;
    import org.osflash.signals.ISignal;
    import org.josht.starling.foxhole.layout.VerticalLayout;
    import org.josht.starling.foxhole.layout.IVirtualLayout;

    public class List extends FoxholeControl 
    {

        private static const helperPoint:Point = new Point();

        protected var defaultScrollerName:String = "foxhole-list-scroller";
        protected var scroller:Scroller;
        protected var dataViewPort:ListDataViewPort;
        protected var _scrollToIndex:int = -1;
        protected var _scrollToIndexDuration:Number;
        private var _layout:ILayout;
        protected var _horizontalScrollPosition:Number = 0;
        protected var _maxHorizontalScrollPosition:Number = 0;
        protected var _horizontalPageIndex:int = 0;
        protected var _verticalScrollPosition:Number = 0;
        protected var _verticalPageIndex:int = 0;
        protected var _maxVerticalScrollPosition:Number = 0;
        protected var _dataProvider:ListCollection;
        private var _isSelectable:Boolean = true;
        private var _selectedIndex:int = -1;
        protected var _onChange:Signal;
        protected var _onScroll:Signal;
        protected var _onItemTouch:Signal;
        private var _scrollerProperties:PropertyProxy;
        private var _itemRendererProperties:PropertyProxy;
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

        public function List()
        {
            this._onChange = new Signal(List);
            this._onScroll = new Signal(List);
            this._onItemTouch = new Signal(List, Object, int, TouchEvent);
            this._itemRendererType = DefaultListItemRenderer;
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

        public function get horizontalPageIndex():int
        {
            return (this._horizontalPageIndex);
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

        public function get verticalPageIndex():int
        {
            return (this._verticalPageIndex);
        }

        public function get maxVerticalScrollPosition():Number
        {
            return (this._maxVerticalScrollPosition);
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
                this.selectedIndex = -1;
            };
            this.invalidate(INVALIDATION_FLAG_SELECTED);
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

        public function get selectedItem():Object
        {
            if (((((!(this._dataProvider)) || ((this._selectedIndex < 0)))) || ((this._selectedIndex >= this._dataProvider.length))))
            {
                return (null);
            };
            return (this._dataProvider.getItemAt(this._selectedIndex));
        }

        public function set selectedItem(_arg1:Object):void
        {
            this.selectedIndex = this._dataProvider.getItemIndex(_arg1);
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
            if (this._scrollerProperties == _arg1)
            {
                return;
            };
            if (((_arg1) && (!((_arg1 is PropertyProxy)))))
            {
                _arg1 = PropertyProxy.fromObject(_arg1);
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

        public function scrollToDisplayIndex(_arg1:int, _arg2:Number=0):void
        {
            if (this._scrollToIndex == _arg1)
            {
                return;
            };
            this._scrollToIndex = _arg1;
            this._scrollToIndexDuration = _arg2;
            this.invalidate(INVALIDATION_FLAG_SCROLL);
        }

        override public function dispose():void
        {
            this._onChange.removeAll();
            this._onScroll.removeAll();
            this._onItemTouch.removeAll();
            super.dispose();
        }

        public function stopScrolling():void
        {
            if (!this.scroller)
            {
                return;
            };
            this.scroller.stopScrolling();
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
                this.dataViewPort = new ListDataViewPort();
                this.dataViewPort.owner = this;
                this.dataViewPort.onChange.add(this.dataViewPort_onChange);
                this.dataViewPort.onItemTouch.add(this.dataViewPort_onItemTouch);
                this.scroller.viewPort = this.dataViewPort;
            };
        }

        override protected function draw():void
        {
            var _local1:Boolean;
            var _local5:Object;
            var _local6:DisplayObject;
            _local1 = this.isInvalid(INVALIDATION_FLAG_SIZE);
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
            this.dataViewPort.selectedIndex = this._selectedIndex;
            this.dataViewPort.dataProvider = this._dataProvider;
            this.dataViewPort.itemRendererType = this._itemRendererType;
            this.dataViewPort.itemRendererFactory = this._itemRendererFactory;
            this.dataViewPort.itemRendererProperties = this._itemRendererProperties;
            this.dataViewPort.itemRendererName = this._itemRendererName;
            this.dataViewPort.typicalItem = this._typicalItem;
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
            this._horizontalPageIndex = this.scroller.horizontalPageIndex;
            this._verticalPageIndex = this.scroller.verticalPageIndex;
            if (this._scrollToIndex >= 0)
            {
                _local5 = this._dataProvider.getItemAt(this._scrollToIndex);
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
                            IVirtualLayout(this._layout).getScrollPositionForItemIndexAndBounds(this._scrollToIndex, this.dataViewPort.visibleWidth, this.dataViewPort.visibleHeight, helperPoint);
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
                this._scrollToIndex = -1;
            };
            this.scroller.horizontalScrollStep = (this.scroller.verticalScrollStep = this.dataViewPort.typicalItemHeight);
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

        protected function dataProvider_onReset(_arg1:ListCollection):void
        {
            this.horizontalScrollPosition = 0;
            this.verticalScrollPosition = 0;
        }

        protected function scroller_onScroll(_arg1:Scroller):void
        {
            this._maxHorizontalScrollPosition = this.scroller.maxHorizontalScrollPosition;
            this._maxVerticalScrollPosition = this.scroller.maxVerticalScrollPosition;
            this._horizontalPageIndex = this.scroller.horizontalPageIndex;
            this._verticalPageIndex = this.scroller.verticalPageIndex;
            this._horizontalScrollPosition = this.scroller.horizontalScrollPosition;
            this._verticalScrollPosition = this.scroller.verticalScrollPosition;
            this.invalidate(INVALIDATION_FLAG_SCROLL);
            this._onScroll.dispatch(this);
        }

        protected function dataViewPort_onChange(_arg1:ListDataViewPort):void
        {
            this.selectedIndex = this.dataViewPort.selectedIndex;
        }

        protected function dataViewPort_onItemTouch(_arg1:ListDataViewPort, _arg2:Object, _arg3:int, _arg4:TouchEvent):void
        {
            this._onItemTouch.dispatch(this, _arg2, _arg3, _arg4);
        }


    }
}//package org.josht.starling.foxhole.controls
