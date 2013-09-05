//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls
{
    import org.josht.starling.foxhole.core.FoxholeControl;
    import org.josht.starling.foxhole.controls.supportClasses.LayoutViewPort;
    import org.josht.starling.foxhole.layout.ILayout;
    import org.josht.starling.foxhole.core.PropertyProxy;
    import org.osflash.signals.Signal;
    import org.osflash.signals.ISignal;
    import starling.display.DisplayObject;
    import org.josht.starling.foxhole.layout.IVirtualLayout;

    public class ScrollContainer extends FoxholeControl 
    {

        public static const SCROLL_POLICY_AUTO:String = "auto";
        public static const SCROLL_POLICY_OFF:String = "off";
        public static const SCROLL_POLICY_ON:String = "on";

        protected var defaultScrollerName:String = "foxhole-scrollcontainer-scroller";
        protected var scroller:Scroller;
        protected var viewPort:LayoutViewPort;
        private var _layout:ILayout;
        private var _horizontalScrollPosition:Number = 0;
        private var _maxHorizontalScrollPosition:Number = 0;
        private var _horizontalScrollPolicy:String = "auto";
        private var _verticalScrollPosition:Number = 0;
        private var _maxVerticalScrollPosition:Number = 0;
        private var _verticalScrollPolicy:String = "auto";
        private var _scrollerProperties:PropertyProxy;
        protected var _onScroll:Signal;

        public function ScrollContainer()
        {
            this._onScroll = new Signal(ScrollContainer);
            super();
            this.viewPort = new LayoutViewPort();
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
            this.invalidate(INVALIDATION_FLAG_DATA);
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
            this._onScroll.dispatch(this);
        }

        public function get maxHorizontalScrollPosition():Number
        {
            return (this._maxHorizontalScrollPosition);
        }

        public function get horizontalScrollPolicy():String
        {
            return (this._horizontalScrollPolicy);
        }

        public function set horizontalScrollPolicy(_arg1:String):void
        {
            if (this._horizontalScrollPolicy == _arg1)
            {
                return;
            };
            this._horizontalScrollPolicy = _arg1;
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
            this._onScroll.dispatch(this);
        }

        public function get maxVerticalScrollPosition():Number
        {
            return (this._maxVerticalScrollPosition);
        }

        public function get verticalScrollPolicy():String
        {
            return (this._verticalScrollPolicy);
        }

        public function set verticalScrollPolicy(_arg1:String):void
        {
            if (this._verticalScrollPolicy == _arg1)
            {
                return;
            };
            this._verticalScrollPolicy = _arg1;
            this.invalidate(INVALIDATION_FLAG_SCROLL);
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

        public function get onScroll():ISignal
        {
            return (this._onScroll);
        }

        override public function get numChildren():int
        {
            return (this.viewPort.numChildren);
        }

        override public function getChildByName(_arg1:String):DisplayObject
        {
            return (this.viewPort.getChildByName(_arg1));
        }

        override public function getChildAt(_arg1:int):DisplayObject
        {
            return (this.viewPort.getChildAt(_arg1));
        }

        override public function addChildAt(_arg1:DisplayObject, _arg2:int):DisplayObject
        {
            return (this.viewPort.addChildAt(_arg1, _arg2));
        }

        override public function removeChildAt(_arg1:int, _arg2:Boolean=false):DisplayObject
        {
            return (this.viewPort.removeChildAt(_arg1, _arg2));
        }

        override public function getChildIndex(_arg1:DisplayObject):int
        {
            return (this.viewPort.getChildIndex(_arg1));
        }

        override public function setChildIndex(_arg1:DisplayObject, _arg2:int):void
        {
            this.viewPort.setChildIndex(_arg1, _arg2);
        }

        override public function swapChildrenAt(_arg1:int, _arg2:int):void
        {
            this.viewPort.swapChildrenAt(_arg1, _arg2);
        }

        override public function sortChildren(_arg1:Function):void
        {
            this.viewPort.sortChildren(_arg1);
        }

        override public function dispose():void
        {
            this._onScroll.removeAll();
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
            if (!this.scroller)
            {
                this.scroller = new Scroller();
                this.scroller.viewPort = this.viewPort;
                this.scroller.nameList.add(this.defaultScrollerName);
                this.scroller.onScroll.add(this.scroller_onScroll);
                super.addChildAt(this.scroller, 0);
            };
        }

        override protected function draw():void
        {
            var _local1:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
            var _local2:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
            var _local3:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
            var _local4:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
            if (_local2)
            {
                if ((this._layout is IVirtualLayout))
                {
                    IVirtualLayout(this._layout).useVirtualLayout = false;
                };
                this.viewPort.layout = this._layout;
            };
            if (_local4)
            {
                this.refreshScrollerStyles();
            };
            if (_local3)
            {
                this.scroller.verticalScrollPosition = this._verticalScrollPosition;
                this.scroller.horizontalScrollPosition = this._horizontalScrollPosition;
                this.scroller.verticalScrollPolicy = this._verticalScrollPolicy;
                this.scroller.horizontalScrollPolicy = this._horizontalScrollPolicy;
            };
            if (_local1)
            {
                if (isNaN(this.explicitWidth))
                {
                    this.scroller.width = NaN;
                }
                else
                {
                    this.scroller.width = Math.max(0, this.explicitWidth);
                };
                if (isNaN(this.explicitHeight))
                {
                    this.scroller.height = NaN;
                }
                else
                {
                    this.scroller.height = Math.max(0, this.explicitHeight);
                };
                this.scroller.minWidth = Math.max(0, this._minWidth);
                this.scroller.maxWidth = Math.max(0, this._maxWidth);
                this.scroller.minHeight = Math.max(0, this._minHeight);
                this.scroller.maxHeight = Math.max(0, this._maxHeight);
            };
            _local1 = ((this.autoSizeIfNeeded()) || (_local1));
            this.scroller.validate();
            this._maxHorizontalScrollPosition = this.scroller.maxHorizontalScrollPosition;
            this._maxVerticalScrollPosition = this.scroller.maxVerticalScrollPosition;
            this._horizontalScrollPosition = this.scroller.horizontalScrollPosition;
            this._verticalScrollPosition = this.scroller.verticalScrollPosition;
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
                _local3 = this.scroller.width;
            };
            if (_local2)
            {
                _local4 = this.scroller.height;
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

        protected function scrollerProperties_onChange(_arg1:PropertyProxy, _arg2:Object):void
        {
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        protected function scroller_onScroll(_arg1:Scroller):void
        {
            var _local2:Number = this._horizontalScrollPosition;
            var _local3:Number = this._verticalScrollPosition;
            this._horizontalScrollPosition = this.scroller.horizontalScrollPosition;
            this._verticalScrollPosition = this.scroller.verticalScrollPosition;
            if (((!((_local2 == this._horizontalScrollPosition))) || (!((_local3 == this._verticalScrollPosition)))))
            {
                this._onScroll.dispatch(this);
            };
        }


    }
}//package org.josht.starling.foxhole.controls
