//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls
{
    import org.josht.starling.foxhole.core.FoxholeControl;
    import flash.geom.Point;
    import starling.display.Quad;
    import flash.utils.Timer;
    import org.osflash.signals.Signal;
    import org.josht.starling.foxhole.core.PropertyProxy;
    import starling.events.Event;
    import org.josht.utils.math.clamp;
    import org.osflash.signals.ISignal;
    import starling.events.TouchEvent;
    import org.josht.utils.math.roundToNearest;
    import flash.events.TimerEvent;
    import starling.events.Touch;
    import __AS3__.vec.Vector;
    import starling.events.TouchPhase;

    public class SimpleScrollBar extends FoxholeControl implements IScrollBar 
    {

        private static const HELPER_POINT:Point = new Point();
        public static const DIRECTION_HORIZONTAL:String = "horizontal";
        public static const DIRECTION_VERTICAL:String = "vertical";

        protected var defaultThumbName:String = "foxhole-simple-scroll-bar-thumb";
        protected var thumbOriginalWidth:Number = NaN;
        protected var thumbOriginalHeight:Number = NaN;
        protected var thumb:Button;
        protected var track:Quad;
        protected var _direction:String = "horizontal";
        public var clampToRange:Boolean = false;
        protected var _value:Number = 0;
        protected var _minimum:Number = 0;
        protected var _maximum:Number = 0;
        protected var _step:Number = 0;
        private var _page:Number = 0;
        protected var _paddingTop:Number = 0;
        protected var _paddingRight:Number = 0;
        protected var _paddingBottom:Number = 0;
        protected var _paddingLeft:Number = 0;
        protected var currentRepeatAction:Function;
        protected var _repeatDelay:Number = 0.05;
        protected var _repeatTimer:Timer;
        protected var isDragging:Boolean = false;
        public var liveDragging:Boolean = true;
        protected var _onChange:Signal;
        protected var _onDragStart:Signal;
        protected var _onDragEnd:Signal;
        private var _thumbProperties:PropertyProxy;
        private var _touchPointID:int = -1;
        private var _touchStartX:Number = NaN;
        private var _touchStartY:Number = NaN;
        private var _thumbStartX:Number = NaN;
        private var _thumbStartY:Number = NaN;
        private var _touchValue:Number;

        public function SimpleScrollBar()
        {
            this._onChange = new Signal(SimpleScrollBar);
            this._onDragStart = new Signal(SimpleScrollBar);
            this._onDragEnd = new Signal(SimpleScrollBar);
            super();
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
        }

        public function get direction():String
        {
            return (this._direction);
        }

        public function set direction(_arg1:String):void
        {
            if (this._direction == _arg1)
            {
                return;
            };
            this._direction = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get value():Number
        {
            return (this._value);
        }

        public function set value(_arg1:Number):void
        {
            if (this.clampToRange)
            {
                _arg1 = clamp(_arg1, this._minimum, this._maximum);
            };
            if (this._value == _arg1)
            {
                return;
            };
            this._value = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
            if (((this.liveDragging) || (!(this.isDragging))))
            {
                this._onChange.dispatch(this);
            };
        }

        public function get minimum():Number
        {
            return (this._minimum);
        }

        public function set minimum(_arg1:Number):void
        {
            if (this._minimum == _arg1)
            {
                return;
            };
            this._minimum = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get maximum():Number
        {
            return (this._maximum);
        }

        public function set maximum(_arg1:Number):void
        {
            if (this._maximum == _arg1)
            {
                return;
            };
            this._maximum = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get step():Number
        {
            return (this._step);
        }

        public function set step(_arg1:Number):void
        {
            this._step = _arg1;
        }

        public function get page():Number
        {
            return (this._page);
        }

        public function set page(_arg1:Number):void
        {
            if (this._page == _arg1)
            {
                return;
            };
            this._page = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
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

        public function get repeatDelay():Number
        {
            return (this._repeatDelay);
        }

        public function set repeatDelay(_arg1:Number):void
        {
            if (this._repeatDelay == _arg1)
            {
                return;
            };
            this._repeatDelay = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get onChange():ISignal
        {
            return (this._onChange);
        }

        public function get onDragStart():ISignal
        {
            return (this._onDragStart);
        }

        public function get onDragEnd():ISignal
        {
            return (this._onDragEnd);
        }

        public function get thumbProperties():Object
        {
            if (!this._thumbProperties)
            {
                this._thumbProperties = new PropertyProxy(this.thumbProperties_onChange);
            };
            return (this._thumbProperties);
        }

        public function set thumbProperties(_arg1:Object):void
        {
            var _local2:PropertyProxy;
            var _local3:String;
            if (this._thumbProperties == _arg1)
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
            if (this._thumbProperties)
            {
                this._thumbProperties.onChange.remove(this.thumbProperties_onChange);
            };
            this._thumbProperties = PropertyProxy(_arg1);
            if (this._thumbProperties)
            {
                this._thumbProperties.onChange.add(this.thumbProperties_onChange);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        override public function dispose():void
        {
            this._onChange.removeAll();
            this._onDragEnd.removeAll();
            this._onDragStart.removeAll();
            super.dispose();
        }

        override protected function initialize():void
        {
            if (!this.track)
            {
                this.track = new Quad(10, 10, 0xFF00FF);
                this.track.alpha = 0;
                this.track.addEventListener(TouchEvent.TOUCH, this.track_touchHandler);
                this.addChild(this.track);
            };
            if (!this.thumb)
            {
                this.thumb = new Button();
                this.thumb.nameList.add(this.defaultThumbName);
                this.thumb.label = "";
                this.thumb.keepDownStateOnRollOut = true;
                this.thumb.addEventListener(TouchEvent.TOUCH, this.thumb_touchHandler);
                this.addChild(this.thumb);
            };
        }

        override protected function draw():void
        {
            var _local1:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
            var _local2:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
            var _local3:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
            var _local4:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
            if (_local2)
            {
                this.refreshThumbStyles();
            };
            if (_local4)
            {
                this.thumb.isEnabled = this._isEnabled;
            };
            _local3 = ((this.autoSizeIfNeeded()) || (_local3));
            if (((((_local1) || (_local2))) || (_local3)))
            {
                this.layout();
            };
        }

        protected function autoSizeIfNeeded():Boolean
        {
            if (((isNaN(this.thumbOriginalWidth)) || (isNaN(this.thumbOriginalHeight))))
            {
                this.thumb.validate();
                this.thumbOriginalWidth = this.thumb.width;
                this.thumbOriginalHeight = this.thumb.height;
            };
            var _local1:Boolean = isNaN(this.explicitWidth);
            var _local2:Boolean = isNaN(this.explicitHeight);
            if (((!(_local1)) && (!(_local2))))
            {
                return (false);
            };
            var _local3:Number = (this._maximum - this._minimum);
            var _local4:Number = (((this._page == 0)) ? (_local3 / 10) : this._page);
            var _local5:Number = this.explicitWidth;
            var _local6:Number = this.explicitHeight;
            if (_local1)
            {
                if (this._direction == DIRECTION_VERTICAL)
                {
                    _local5 = this.thumbOriginalWidth;
                }
                else
                {
                    if (_local3 > 0)
                    {
                        _local5 = 0;
                    }
                    else
                    {
                        _local5 = Math.max(this.thumbOriginalWidth, ((this.thumbOriginalWidth * _local3) / _local4));
                    };
                };
                _local5 = (_local5 + (this._paddingLeft + this._paddingRight));
            };
            if (_local2)
            {
                if (this._direction == DIRECTION_VERTICAL)
                {
                    if (_local3 > 0)
                    {
                        _local6 = 0;
                    }
                    else
                    {
                        _local6 = Math.max(this.thumbOriginalHeight, ((this.thumbOriginalHeight * _local3) / _local4));
                    };
                }
                else
                {
                    _local6 = this.thumbOriginalHeight;
                };
                _local6 = (_local6 + (this._paddingTop + this._paddingBottom));
            };
            return (this.setSizeInternal(_local5, _local6, false));
        }

        protected function refreshThumbStyles():void
        {
            var _local1:String;
            var _local2:Object;
            for (_local1 in this._thumbProperties)
            {
                if (this.thumb.hasOwnProperty(_local1))
                {
                    _local2 = this._thumbProperties[_local1];
                    this.thumb[_local1] = _local2;
                };
            };
        }

        protected function layout():void
        {
            var _local6:Number;
            var _local7:Number;
            var _local8:Number;
            var _local9:Number;
            this.track.width = this.actualWidth;
            this.track.height = this.actualHeight;
            var _local1:Number = (this._maximum - this._minimum);
            this.thumb.visible = (_local1 > 0);
            if (!this.thumb.visible)
            {
                return;
            };
            this.thumb.validate();
            var _local2:Number = ((this.actualWidth - this._paddingLeft) - this._paddingRight);
            var _local3:Number = ((this.actualHeight - this._paddingTop) - this._paddingBottom);
            var _local4:Number = Math.min(_local1, (((this._page == 0)) ? _local1 : this._page));
            var _local5:Number = _local1;
            if (this._value < this._minimum)
            {
                _local5 = (_local5 + (this._minimum - this._value));
            };
            if (this._value > this._maximum)
            {
                _local5 = (_local5 + (this._value - this._maximum));
            };
            if (this._direction == DIRECTION_VERTICAL)
            {
                _local6 = (((this.thumb.minHeight > 0)) ? this.thumb.minHeight : this.thumbOriginalHeight);
                this.thumb.width = this.thumbOriginalWidth;
                this.thumb.height = Math.max(_local6, ((_local3 * _local4) / (_local5 + _local4)));
                _local7 = (_local3 - this.thumb.height);
                this.thumb.x = ((this.actualWidth - this.thumb.width) / 2);
                this.thumb.y = (this._paddingTop + Math.max(0, Math.min(_local7, ((_local7 * (this._value - this._minimum)) / _local1))));
            }
            else
            {
                _local8 = (((this.thumb.minWidth > 0)) ? this.thumb.minWidth : this.thumbOriginalWidth);
                this.thumb.width = Math.max(_local8, ((_local2 * _local4) / (_local5 + _local4)));
                this.thumb.height = this.thumbOriginalHeight;
                _local9 = (_local2 - this.thumb.width);
                this.thumb.x = (this._paddingLeft + Math.max(0, Math.min(_local9, ((_local9 * (this._value - this._minimum)) / _local1))));
                this.thumb.y = ((this.actualHeight - this.thumb.height) / 2);
            };
        }

        protected function locationToValue(_arg1:Point):Number
        {
            var _local2:Number;
            var _local3:Number;
            var _local4:Number;
            var _local5:Number;
            var _local6:Number;
            var _local7:Number;
            var _local8:Number;
            if (this._direction == DIRECTION_VERTICAL)
            {
                _local3 = (this.actualHeight - this.thumb.height);
                _local4 = (_arg1.y - this._touchStartY);
                _local5 = Math.min(Math.max(0, (this._thumbStartY + _local4)), _local3);
                _local2 = (_local5 / _local3);
            }
            else
            {
                _local6 = (this.actualWidth - this.thumb.width);
                _local7 = (_arg1.x - this._touchStartX);
                _local8 = Math.min(Math.max(0, (this._thumbStartX + _local7)), _local6);
                _local2 = (_local8 / _local6);
            };
            return ((this._minimum + (_local2 * (this._maximum - this._minimum))));
        }

        protected function adjustPage():void
        {
            var _local1:Number;
            if (this._touchValue < this._value)
            {
                _local1 = Math.max(this._touchValue, (this._value - this._page));
                if (this._step != 0)
                {
                    _local1 = roundToNearest(_local1, this._step);
                };
                this.value = _local1;
            }
            else
            {
                if (this._touchValue > this._value)
                {
                    _local1 = Math.min(this._touchValue, (this._value + this._page));
                    if (this._step != 0)
                    {
                        _local1 = roundToNearest(_local1, this._step);
                    };
                    this.value = _local1;
                };
            };
        }

        protected function startRepeatTimer(_arg1:Function):void
        {
            this.currentRepeatAction = _arg1;
            if (this._repeatDelay > 0)
            {
                if (!this._repeatTimer)
                {
                    this._repeatTimer = new Timer((this._repeatDelay * 1000));
                    this._repeatTimer.addEventListener(TimerEvent.TIMER, this.repeatTimer_timerHandler);
                }
                else
                {
                    this._repeatTimer.reset();
                    this._repeatTimer.delay = (this._repeatDelay * 1000);
                };
                this._repeatTimer.start();
            };
        }

        protected function thumbProperties_onChange(_arg1:PropertyProxy, _arg2:Object):void
        {
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        protected function removedFromStageHandler(_arg1:Event):void
        {
            this._touchPointID = -1;
            if (this._repeatTimer)
            {
                this._repeatTimer.stop();
            };
        }

        protected function track_touchHandler(_arg1:TouchEvent):void
        {
            var _local3:Touch;
            var _local4:Touch;
            if (!this._isEnabled)
            {
                return;
            };
            var _local2:Vector.<Touch> = _arg1.getTouches(this.track);
            if (_local2.length == 0)
            {
                return;
            };
            if (this._touchPointID >= 0)
            {
                for each (_local4 in _local2)
                {
                    if (_local4.id == this._touchPointID)
                    {
                        _local3 = _local4;
                        break;
                    };
                };
                if (!_local3)
                {
                    return;
                };
                if (_local3.phase == TouchPhase.ENDED)
                {
                    this._touchPointID = -1;
                    this._repeatTimer.stop();
                    return;
                };
            }
            else
            {
                for each (_local3 in _local2)
                {
                    if (_local3.phase == TouchPhase.BEGAN)
                    {
                        this._touchPointID = _local3.id;
                        _local3.getLocation(this, HELPER_POINT);
                        this._touchStartX = HELPER_POINT.x;
                        this._touchStartY = HELPER_POINT.y;
                        this._thumbStartX = HELPER_POINT.x;
                        this._thumbStartY = HELPER_POINT.y;
                        this._touchValue = this.locationToValue(HELPER_POINT);
                        this.adjustPage();
                        this.startRepeatTimer(this.adjustPage);
                        return;
                    };
                };
            };
        }

        protected function thumb_touchHandler(_arg1:TouchEvent):void
        {
            var _local3:Touch;
            var _local4:Touch;
            var _local5:Number;
            if (!this._isEnabled)
            {
                return;
            };
            var _local2:Vector.<Touch> = _arg1.getTouches(this.thumb);
            if (_local2.length == 0)
            {
                return;
            };
            if (this._touchPointID >= 0)
            {
                for each (_local4 in _local2)
                {
                    if (_local4.id == this._touchPointID)
                    {
                        _local3 = _local4;
                        break;
                    };
                };
                if (!_local3)
                {
                    return;
                };
                if (_local3.phase == TouchPhase.MOVED)
                {
                    _local3.getLocation(this, HELPER_POINT);
                    _local5 = this.locationToValue(HELPER_POINT);
                    if (this._step != 0)
                    {
                        _local5 = roundToNearest(_local5, this._step);
                    };
                    this.value = _local5;
                }
                else
                {
                    if (_local3.phase == TouchPhase.ENDED)
                    {
                        this._touchPointID = -1;
                        this.isDragging = false;
                        if (!this.liveDragging)
                        {
                            this._onChange.dispatch(this);
                        };
                        this._onDragEnd.dispatch(this);
                        return;
                    };
                };
            }
            else
            {
                for each (_local3 in _local2)
                {
                    if (_local3.phase == TouchPhase.BEGAN)
                    {
                        _local3.getLocation(this, HELPER_POINT);
                        this._touchPointID = _local3.id;
                        this._thumbStartX = this.thumb.x;
                        this._thumbStartY = this.thumb.y;
                        this._touchStartX = HELPER_POINT.x;
                        this._touchStartY = HELPER_POINT.y;
                        this.isDragging = true;
                        this._onDragStart.dispatch(this);
                        return;
                    };
                };
            };
        }

        protected function repeatTimer_timerHandler(_arg1:TimerEvent):void
        {
            if (this._repeatTimer.currentCount < 5)
            {
                return;
            };
            this.currentRepeatAction();
        }


    }
}//package org.josht.starling.foxhole.controls
