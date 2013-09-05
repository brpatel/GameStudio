//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls.supportClasses
{
    import org.josht.starling.foxhole.core.FoxholeControl;
    import flash.geom.Point;
    import org.josht.starling.foxhole.layout.ViewPortBounds;
    import org.josht.starling.foxhole.layout.LayoutBoundsResult;
    import __AS3__.vec.Vector;
    import starling.display.DisplayObject;
    import org.josht.starling.foxhole.layout.ILayout;
    import starling.events.Event;
    import org.josht.starling.foxhole.layout.IVirtualLayout;
    import __AS3__.vec.*;

    public class LayoutViewPort extends FoxholeControl implements IViewPort 
    {

        private static const helperPoint:Point = new Point();
        private static const helperBounds:ViewPortBounds = new ViewPortBounds();
        private static const helperResult:LayoutBoundsResult = new LayoutBoundsResult();

        private var _minVisibleWidth:Number = 0;
        private var _maxVisibleWidth:Number = Infinity;
        protected var _visibleWidth:Number = NaN;
        private var _minVisibleHeight:Number = 0;
        private var _maxVisibleHeight:Number = Infinity;
        protected var _visibleHeight:Number = NaN;
        protected var items:Vector.<DisplayObject>;
        private var _layout:ILayout;

        public function LayoutViewPort()
        {
            this.items = new <DisplayObject>[];
            super();
            this.addEventListener(Event.ADDED, this.addedHandler);
            this.addEventListener(Event.REMOVED, this.removedHandler);
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
            return (this._visibleWidth);
        }

        public function set visibleWidth(_arg1:Number):void
        {
            if ((((this._visibleWidth == _arg1)) || (((isNaN(_arg1)) && (isNaN(this._visibleWidth))))))
            {
                return;
            };
            this._visibleWidth = _arg1;
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
            return (this._visibleHeight);
        }

        public function set visibleHeight(_arg1:Number):void
        {
            if ((((this._visibleHeight == _arg1)) || (((isNaN(_arg1)) && (isNaN(this._visibleHeight))))))
            {
                return;
            };
            this._visibleHeight = _arg1;
            this.invalidate(INVALIDATION_FLAG_SIZE);
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
                if ((this._layout is IVirtualLayout))
                {
                    IVirtualLayout(this._layout).useVirtualLayout = false;
                };
                this._layout.onLayoutChange.add(this.layout_onLayoutChange);
                this.invalidate(INVALIDATION_FLAG_DATA);
            };
        }

        override public function dispose():void
        {
            if (this._layout)
            {
                this._layout.onLayoutChange.remove(this.layout_onLayoutChange);
            };
            super.dispose();
        }

        override protected function draw():void
        {
            var _local3:int;
            var _local4:int;
            var _local5:FoxholeControl;
            var _local6:Number;
            var _local7:Number;
            var _local8:DisplayObject;
            var _local1:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
            var _local2:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
            if (((_local2) || (_local1)))
            {
                _local3 = this.items.length;
                _local4 = 0;
                while (_local4 < _local3)
                {
                    _local5 = (this.items[_local4] as FoxholeControl);
                    if (_local5)
                    {
                        _local5.validate();
                    };
                    _local4++;
                };
                helperBounds.x = (helperBounds.y = 0);
                helperBounds.explicitWidth = this._visibleWidth;
                helperBounds.explicitHeight = this._visibleHeight;
                helperBounds.minWidth = this._minVisibleWidth;
                helperBounds.minHeight = this._minVisibleHeight;
                helperBounds.maxWidth = this._maxVisibleWidth;
                helperBounds.maxHeight = this._maxVisibleHeight;
                if (this._layout)
                {
                    this._layout.layout(this.items, helperBounds, helperResult);
                    this.setSizeInternal(helperResult.contentWidth, helperResult.contentHeight, false);
                }
                else
                {
                    _local6 = ((isNaN(helperBounds.explicitWidth)) ? 0 : helperBounds.explicitWidth);
                    _local7 = ((isNaN(helperBounds.explicitHeight)) ? 0 : helperBounds.explicitHeight);
                    for each (_local8 in this.items)
                    {
                        _local6 = Math.max(_local6, (_local8.x + _local8.width));
                        _local7 = Math.max(_local7, (_local8.y + _local8.height));
                    };
                    helperPoint.x = Math.max(Math.min(_local6, this._maxVisibleWidth), this._minVisibleWidth);
                    helperPoint.y = Math.max(Math.min(_local7, this._maxVisibleHeight), this._minVisibleHeight);
                    this.setSizeInternal(helperPoint.x, helperPoint.y, false);
                };
            };
        }

        protected function layout_onLayoutChange(_arg1:ILayout):void
        {
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        protected function child_resizeHandler(_arg1:FoxholeControl):void
        {
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        protected function addedHandler(_arg1:Event):void
        {
            var _local2:DisplayObject = DisplayObject(_arg1.target);
            if (_local2.parent != this)
            {
                return;
            };
            var _local3:int = this.getChildIndex(_local2);
            this.items.splice(_local3, 0, _local2);
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        protected function removedHandler(_arg1:Event):void
        {
            var _local2:DisplayObject = DisplayObject(_arg1.target);
            if (_local2.parent != this)
            {
                return;
            };
            var _local3:int = this.items.indexOf(_local2);
            this.items.splice(_local3, 1);
            this.invalidate(INVALIDATION_FLAG_DATA);
        }


    }
}//package org.josht.starling.foxhole.controls.supportClasses
