//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.layout
{
    import flash.geom.Point;
    import org.osflash.signals.Signal;
    import org.osflash.signals.ISignal;
    import starling.display.DisplayObject;
    import __AS3__.vec.Vector;

    public class VerticalLayout implements IVariableVirtualLayout 
    {

        public static const VERTICAL_ALIGN_TOP:String = "top";
        public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
        public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
        public static const HORIZONTAL_ALIGN_LEFT:String = "left";
        public static const HORIZONTAL_ALIGN_CENTER:String = "center";
        public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
        public static const HORIZONTAL_ALIGN_JUSTIFY:String = "justify";

        private static var helperPoint:Point;

        private var _gap:Number = 0;
        protected var _paddingTop:Number = 0;
        protected var _paddingRight:Number = 0;
        protected var _paddingBottom:Number = 0;
        protected var _paddingLeft:Number = 0;
        private var _verticalAlign:String = "top";
        private var _horizontalAlign:String = "left";
        private var _useVirtualLayout:Boolean = true;
        private var _indexToItemBoundsFunction:Function;
        private var _typicalItemWidth:Number = 0;
        private var _typicalItemHeight:Number = 0;
        protected var _onLayoutChange:Signal;

        public function VerticalLayout()
        {
            this._onLayoutChange = new Signal(ILayout);
            super();
        }

        public function get gap():Number
        {
            return (this._gap);
        }

        public function set gap(_arg1:Number):void
        {
            if (this._gap == _arg1)
            {
                return;
            };
            this._gap = _arg1;
            this._onLayoutChange.dispatch(this);
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
            this._onLayoutChange.dispatch(this);
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
            this._onLayoutChange.dispatch(this);
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
            this._onLayoutChange.dispatch(this);
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
            this._onLayoutChange.dispatch(this);
        }

        public function get verticalAlign():String
        {
            return (this._verticalAlign);
        }

        public function set verticalAlign(_arg1:String):void
        {
            if (this._verticalAlign == _arg1)
            {
                return;
            };
            this._verticalAlign = _arg1;
            this._onLayoutChange.dispatch(this);
        }

        public function get horizontalAlign():String
        {
            return (this._horizontalAlign);
        }

        public function set horizontalAlign(_arg1:String):void
        {
            if (this._horizontalAlign == _arg1)
            {
                return;
            };
            this._horizontalAlign = _arg1;
            this._onLayoutChange.dispatch(this);
        }

        public function get useVirtualLayout():Boolean
        {
            return (this._useVirtualLayout);
        }

        public function set useVirtualLayout(_arg1:Boolean):void
        {
            if (this._useVirtualLayout == _arg1)
            {
                return;
            };
            this._useVirtualLayout = _arg1;
            this._onLayoutChange.dispatch(this);
        }

        public function get indexToItemBoundsFunction():Function
        {
            return (this._indexToItemBoundsFunction);
        }

        public function set indexToItemBoundsFunction(_arg1:Function):void
        {
            if (this._indexToItemBoundsFunction == _arg1)
            {
                return;
            };
            this._indexToItemBoundsFunction = _arg1;
        }

        public function get typicalItemWidth():Number
        {
            return (this._typicalItemWidth);
        }

        public function set typicalItemWidth(_arg1:Number):void
        {
            if (this._typicalItemWidth == _arg1)
            {
                return;
            };
            this._typicalItemWidth = _arg1;
        }

        public function get typicalItemHeight():Number
        {
            return (this._typicalItemHeight);
        }

        public function set typicalItemHeight(_arg1:Number):void
        {
            if (this._typicalItemHeight == _arg1)
            {
                return;
            };
            this._typicalItemHeight = _arg1;
        }

        public function get onLayoutChange():ISignal
        {
            return (this._onLayoutChange);
        }

        public function layout(_arg1:Vector.<DisplayObject>, _arg2:ViewPortBounds=null, _arg3:LayoutBoundsResult=null):LayoutBoundsResult
        {
            var _local20:DisplayObject;
            var _local21:Number;
            var _local4:Number = ((_arg2) ? _arg2.x : 0);
            var _local5:Number = ((_arg2) ? _arg2.y : 0);
            var _local6:Number = ((_arg2) ? _arg2.minWidth : 0);
            var _local7:Number = ((_arg2) ? _arg2.minHeight : 0);
            var _local8:Number = ((_arg2) ? _arg2.maxWidth : Number.POSITIVE_INFINITY);
            var _local9:Number = ((_arg2) ? _arg2.maxHeight : Number.POSITIVE_INFINITY);
            var _local10:Number = ((_arg2) ? _arg2.explicitWidth : NaN);
            var _local11:Number = ((_arg2) ? _arg2.explicitHeight : NaN);
            var _local12:Number = 0;
            var _local13:Number = (_local5 + this._paddingTop);
            var _local14:int = _arg1.length;
            var _local15:int;
            while (_local15 < _local14)
            {
                _local20 = _arg1[_local15];
                if (((this._useVirtualLayout) && (!(_local20))))
                {
                    if (this._indexToItemBoundsFunction != null)
                    {
                        helperPoint = this._indexToItemBoundsFunction(_local15, helperPoint);
                        _local13 = (_local13 + (helperPoint.y + this._gap));
                        _local12 = Math.max(_local12, helperPoint.x);
                    }
                    else
                    {
                        _local13 = (_local13 + (this._typicalItemHeight + this._gap));
                        _local12 = Math.max(_local12, this._typicalItemWidth);
                    };
                }
                else
                {
                    _local20.y = _local13;
                    if (this._useVirtualLayout)
                    {
                        if (this._indexToItemBoundsFunction != null)
                        {
                            helperPoint = this._indexToItemBoundsFunction(_local15, helperPoint);
                            _local20.width = helperPoint.x;
                            _local20.height = helperPoint.y;
                        }
                        else
                        {
                            _local20.width = this._typicalItemWidth;
                            _local20.height = this._typicalItemHeight;
                        };
                    };
                    _local13 = (_local13 + (_local20.height + this._gap));
                    _local12 = Math.max(_local12, _local20.width);
                };
                _local15++;
            };
            var _local16:Number = ((_local12 + this._paddingLeft) + this._paddingRight);
            var _local17:Number = ((isNaN(_local10)) ? Math.min(_local8, Math.max(_local6, _local16)) : _local10);
            _local15 = 0;
            while (_local15 < _local14)
            {
                _local20 = _arg1[_local15];
                if (_local20)
                {
                    switch (this._horizontalAlign)
                    {
                        case HORIZONTAL_ALIGN_RIGHT:
                            _local20.x = (((_local4 + _local17) - this._paddingRight) - _local20.width);
                            break;
                        case HORIZONTAL_ALIGN_CENTER:
                            _local20.x = ((_local4 + this._paddingLeft) + ((((_local17 - this._paddingLeft) - this._paddingRight) - _local20.width) / 2));
                            break;
                        case HORIZONTAL_ALIGN_JUSTIFY:
                            _local20.x = this._paddingLeft;
                            _local20.width = ((_local17 - this._paddingLeft) - this._paddingRight);
                            break;
                        default:
                            _local20.x = this._paddingLeft;
                    };
                };
                _local15++;
            };
            var _local18:Number = (((_local13 - this._gap) + this._paddingBottom) - _local5);
            var _local19:Number = ((isNaN(_local11)) ? Math.min(_local9, Math.max(_local7, _local18)) : _local11);
            if (_local18 < _local19)
            {
                _local21 = 0;
                if (this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
                {
                    _local21 = (_local19 - _local18);
                }
                else
                {
                    if (this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
                    {
                        _local21 = ((_local19 - _local18) / 2);
                    };
                };
                if (_local21 != 0)
                {
                    _local15 = 0;
                    while (_local15 < _local14)
                    {
                        _local20 = _arg1[_local15];
                        if (_local20)
                        {
                            _local20.y = (_local20.y + _local21);
                        };
                        _local15++;
                    };
                };
            };
            if (!_arg3)
            {
                _arg3 = new LayoutBoundsResult();
            };
            _arg3.contentWidth = _local16;
            _arg3.contentHeight = _local18;
            _arg3.viewPortWidth = _local17;
            _arg3.viewPortHeight = _local19;
            return (_arg3);
        }

        public function measureViewPort(_arg1:int, _arg2:ViewPortBounds=null, _arg3:Point=null):Point
        {
            var _local14:int;
            if (!_arg3)
            {
                _arg3 = new Point();
            };
            var _local4:Number = ((_arg2) ? _arg2.explicitWidth : NaN);
            var _local5:Number = ((_arg2) ? _arg2.explicitHeight : NaN);
            var _local6:Boolean = isNaN(_local4);
            var _local7:Boolean = isNaN(_local5);
            if (((!(_local6)) && (!(_local7))))
            {
                _arg3.x = _local4;
                _arg3.y = _local5;
                return (_arg3);
            };
            var _local8:Number = ((_arg2) ? _arg2.minWidth : 0);
            var _local9:Number = ((_arg2) ? _arg2.minHeight : 0);
            var _local10:Number = ((_arg2) ? _arg2.maxWidth : Number.POSITIVE_INFINITY);
            var _local11:Number = ((_arg2) ? _arg2.maxHeight : Number.POSITIVE_INFINITY);
            var _local12:Number = 0;
            var _local13:Number = 0;
            if (this._indexToItemBoundsFunction != null)
            {
                _local14 = 0;
                while (_local14 < _arg1)
                {
                    helperPoint = this._indexToItemBoundsFunction(_local14, helperPoint);
                    _local12 = (_local12 + (helperPoint.y + this._gap));
                    _local13 = Math.max(_local13, helperPoint.x);
                    _local14++;
                };
            }
            else
            {
                _local12 = (_local12 + (_arg1 * (this._typicalItemHeight + this._gap)));
                _local13 = this._typicalItemWidth;
            };
            if (_local6)
            {
                _arg3.x = Math.min(_local10, Math.max(_local8, ((_local13 + this._paddingLeft) + this._paddingRight)));
            }
            else
            {
                _arg3.x = _local4;
            };
            if (_local7)
            {
                _arg3.y = Math.min(_local11, Math.max(_local9, (((_local12 - this._gap) + this._paddingTop) + this._paddingBottom)));
            }
            else
            {
                _arg3.y = _local5;
            };
            return (_arg3);
        }

        public function getMinimumItemIndexAtScrollPosition(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:int):int
        {
            var _local7:int;
            var _local8:Number;
            if (this._indexToItemBoundsFunction == null)
            {
                _local7 = 0;
                _local8 = ((_arg5 * (this._typicalItemHeight + this._gap)) - this._gap);
                if (_local8 < _arg4)
                {
                    if (this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
                    {
                        _local7 = Math.ceil(((_arg4 - _local8) / (this._typicalItemHeight + this._gap)));
                    }
                    else
                    {
                        if (this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
                        {
                            _local7 = Math.ceil((((_arg4 - _local8) / (this._typicalItemHeight + this._gap)) / 2));
                        };
                    };
                };
                return ((-(_local7) + Math.max(0, ((_arg2 - this._paddingTop) / (this._typicalItemHeight + this._gap)))));
            };
            _local8 = this._paddingTop;
            var _local6:int;
            while (_local6 < _arg5)
            {
                helperPoint = this._indexToItemBoundsFunction(_local6, helperPoint);
                _local8 = (_local8 + helperPoint.y);
                if (_local8 > _arg2)
                {
                    return (_local6);
                };
                _local8 = (_local8 + this._gap);
                _local6++;
            };
            return ((_arg5 - 1));
        }

        public function getMaximumItemIndexAtScrollPosition(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:int):int
        {
            var _local6:int = this.getMinimumItemIndexAtScrollPosition(_arg1, _arg2, _arg3, _arg4, _arg5);
            if (this._indexToItemBoundsFunction == null)
            {
                return ((_local6 + Math.ceil((_arg4 / (this._typicalItemHeight + this._gap)))));
            };
            var _local7:Number = (_arg2 + _arg4);
            var _local8:Number = _arg2;
            var _local9:int = (_local6 + 1);
            while (_local9 < _arg5)
            {
                helperPoint = this._indexToItemBoundsFunction(_local9, helperPoint);
                _local8 = (_local8 + helperPoint.y);
                if (_local8 > _local7)
                {
                    return (_local9);
                };
                _local8 = (_local8 + this._gap);
                _local9++;
            };
            return ((_arg5 - 1));
        }

        public function getScrollPositionForItemIndexAndBounds(_arg1:int, _arg2:Number, _arg3:Number, _arg4:Point=null):Point
        {
            var _local5:Number;
            var _local6:Number;
            var _local7:int;
            if (!_arg4)
            {
                _arg4 = new Point();
            };
            _arg4.x = 0;
            if (this._indexToItemBoundsFunction == null)
            {
                _local5 = this._typicalItemHeight;
                _arg4.y = ((this._paddingTop + ((_local5 + this._gap) * _arg1)) - ((_arg3 - _local5) / 2));
            }
            else
            {
                _local6 = this._paddingTop;
                _local7 = 0;
                while (_local7 < _arg1)
                {
                    helperPoint = this._indexToItemBoundsFunction(_local7, helperPoint);
                    _local6 = (_local6 + (helperPoint.y + this._gap));
                    _local7++;
                };
                _local6 = (_local6 - ((_arg3 - helperPoint.y) / 2));
                _arg4.y = _local6;
            };
            return (_arg4);
        }


    }
}//package org.josht.starling.foxhole.layout
