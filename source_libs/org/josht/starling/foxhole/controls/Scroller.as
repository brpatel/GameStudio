//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls
{
    import org.josht.starling.foxhole.core.FoxholeControl;
    import __AS3__.vec.Vector;
    import flash.geom.Point;
    import org.josht.starling.motion.GTween;
    import org.josht.starling.display.Sprite;
    import starling.display.DisplayObject;
    import org.josht.starling.foxhole.core.PropertyProxy;
    import org.osflash.signals.Signal;
    import com.gskinner.motion.easing.Cubic;
    import starling.events.Event;
    import org.osflash.signals.ISignal;
    import starling.events.TouchEvent;
    import org.josht.utils.math.roundToNearest;
    import org.josht.starling.foxhole.controls.supportClasses.IViewPort;
    import org.josht.utils.math.clamp;
    import flash.geom.Rectangle;
    import flash.system.Capabilities;
    import org.josht.utils.math.roundDownToNearest;
    import org.josht.utils.math.roundUpToNearest;
    import com.gskinner.motion.easing.Sine;
    import starling.events.TouchPhase;
    import starling.events.Touch;
    import flash.utils.getTimer;
    import flash.events.MouseEvent;
    import org.josht.starling.display.ScrollRectManager;
    import starling.core.Starling;
    import __AS3__.vec.*;

    public class Scroller extends FoxholeControl 
    {

        protected static const INVALIDATION_FLAG_SCROLL_BAR_RENDERER:String = "scrollBarRenderer";
        public static const SCROLL_POLICY_AUTO:String = "auto";
        public static const SCROLL_POLICY_ON:String = "on";
        public static const SCROLL_POLICY_OFF:String = "off";
        public static const HORIZONTAL_ALIGN_LEFT:String = "left";
        public static const HORIZONTAL_ALIGN_CENTER:String = "center";
        public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
        public static const VERTICAL_ALIGN_TOP:String = "top";
        public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
        public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
        public static const SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";
        public static const SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";
        public static const SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";
        public static const INTERACTION_MODE_TOUCH:String = "touch";
        public static const INTERACTION_MODE_MOUSE:String = "mouse";
        protected static const INVALIDATION_FLAG_CLIPPING:String = "clipping";
        private static const MINIMUM_DRAG_DISTANCE:Number = 0.04;
        private static const MINIMUM_PAGE_VELOCITY:Number = 5;
        private static const MINIMUM_VELOCITY:Number = 0.02;
        private static const FRICTION:Number = 0.998;
        private static const EXTRA_FRICTION:Number = 0.95;
        private static const VELOCITY_WEIGHTS:Vector.<Number> = new <Number>[2, 1.66, 1.33, 1];
        private static const MAXIMUM_SAVED_VELOCITY_COUNT:int = 4;

        private static var helperPoint:Point = new Point();

        protected var horizontalScrollBar:IScrollBar;
        protected var verticalScrollBar:IScrollBar;
        protected var _horizontalScrollBarHeightOffset:Number;
        protected var _verticalScrollBarWidthOffset:Number;
        private var _horizontalScrollBarTouchPointID:int = -1;
        private var _verticalScrollBarTouchPointID:int = -1;
        private var _touchPointID:int = -1;
        private var _startTouchX:Number;
        private var _startTouchY:Number;
        private var _startHorizontalScrollPosition:Number;
        private var _startVerticalScrollPosition:Number;
        private var _currentTouchX:Number;
        private var _currentTouchY:Number;
        private var _previousTouchTime:int;
        private var _previousTouchX:Number;
        private var _previousTouchY:Number;
        private var _velocityX:Number;
        private var _velocityY:Number;
        private var _previousVelocityX:Vector.<Number>;
        private var _previousVelocityY:Vector.<Number>;
        private var _horizontalAutoScrollTween:GTween;
        private var _verticalAutoScrollTween:GTween;
        private var _isDraggingHorizontally:Boolean = false;
        private var _isDraggingVertically:Boolean = false;
        protected var ignoreViewPortResizing:Boolean = false;
        private var _viewPortWrapper:Sprite;
        private var _viewPort:DisplayObject;
        protected var _snapToPages:Boolean = false;
        private var _horizontalScrollBarFactory:Function;
        private var _horizontalScrollBarProperties:PropertyProxy;
        private var _verticalScrollBarFactory:Function;
        private var _verticalScrollBarProperties:PropertyProxy;
        private var _horizontalScrollStep:Number = 1;
        private var _horizontalScrollPosition:Number = 0;
        private var _maxHorizontalScrollPosition:Number = 0;
        protected var _horizontalPageIndex:int = 0;
        private var _horizontalScrollPolicy:String = "auto";
        protected var _horizontalAlign:String = "left";
        private var _verticalScrollStep:Number = 1;
        private var _verticalScrollPosition:Number = 0;
        private var _maxVerticalScrollPosition:Number = 0;
        protected var _verticalPageIndex:int = 0;
        private var _verticalScrollPolicy:String = "auto";
        protected var _verticalAlign:String = "top";
        private var _clipContent:Boolean = true;
        private var _hasElasticEdges:Boolean = true;
        private var _elasticity:Number = 0.33;
        protected var _scrollBarDisplayMode:String = "float";
        protected var _interactionMode:String = "touch";
        protected var _horizontalScrollBarHideTween:GTween;
        protected var _verticalScrollBarHideTween:GTween;
        protected var _hideScrollBarAnimationDuration:Number = 0.2;
        protected var _elasticSnapDuration:Number = 0.24;
        protected var _pageThrowDuration:Number = 0.5;
        protected var _throwEase:Function;
        protected var _onScroll:Signal;
        protected var _onDragStart:Signal;
        protected var _onDragEnd:Signal;
        private var _isScrollingStopped:Boolean = false;

        public function Scroller()
        {
            this._previousVelocityX = new <Number>[];
            this._previousVelocityY = new <Number>[];
            this._horizontalScrollBarFactory = defaultHorizontalScrollBarFactory;
            this._verticalScrollBarFactory = defaultVerticalScrollBarFactory;
            this._throwEase = Cubic.easeOut;
            this._onScroll = new Signal(Scroller);
            this._onDragStart = new Signal(Scroller);
            this._onDragEnd = new Signal(Scroller);
            super();
            this._viewPortWrapper = new Sprite();
            this.addChild(this._viewPortWrapper);
            this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
        }

        protected static function defaultHorizontalScrollBarFactory():IScrollBar
        {
            var _local1:SimpleScrollBar = new SimpleScrollBar();
            _local1.direction = SimpleScrollBar.DIRECTION_HORIZONTAL;
            return (_local1);
        }

        protected static function defaultVerticalScrollBarFactory():IScrollBar
        {
            var _local1:SimpleScrollBar = new SimpleScrollBar();
            _local1.direction = SimpleScrollBar.DIRECTION_VERTICAL;
            return (_local1);
        }


        public function get viewPort():DisplayObject
        {
            return (this._viewPort);
        }

        public function set viewPort(_arg1:DisplayObject):void
        {
            if (this._viewPort == _arg1)
            {
                return;
            };
            if (this._viewPort)
            {
                if ((this._viewPort is FoxholeControl))
                {
                    FoxholeControl(this._viewPort).onResize.remove(this.viewPort_onResize);
                };
                this._viewPortWrapper.removeChild(this._viewPort);
            };
            this._viewPort = _arg1;
            if (this._viewPort)
            {
                if ((this._viewPort is FoxholeControl))
                {
                    FoxholeControl(this._viewPort).onResize.add(this.viewPort_onResize);
                };
                this._viewPortWrapper.addChild(this._viewPort);
            };
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get snapToPages():Boolean
        {
            return (this._snapToPages);
        }

        public function set snapToPages(_arg1:Boolean):void
        {
            if (this._snapToPages == _arg1)
            {
                return;
            };
            this._snapToPages = _arg1;
            if (!this._snapToPages)
            {
                this._horizontalPageIndex = 0;
                this._verticalPageIndex = 0;
            };
            this.invalidate(INVALIDATION_FLAG_SCROLL);
        }

        public function get horizontalScrollBarFactory():Function
        {
            return (this._horizontalScrollBarFactory);
        }

        public function set horizontalScrollBarFactory(_arg1:Function):void
        {
            if (this._horizontalScrollBarFactory == _arg1)
            {
                return;
            };
            this._horizontalScrollBarFactory = _arg1;
            this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
        }

        public function get horizontalScrollBarProperties():Object
        {
            if (!this._horizontalScrollBarProperties)
            {
                this._horizontalScrollBarProperties = new PropertyProxy(this.horizontalScrollBarProperties_onChange);
            };
            return (this._horizontalScrollBarProperties);
        }

        public function set horizontalScrollBarProperties(_arg1:Object):void
        {
            var _local2:PropertyProxy;
            var _local3:String;
            if (this._horizontalScrollBarProperties == _arg1)
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
            if (this._horizontalScrollBarProperties)
            {
                this._horizontalScrollBarProperties.onChange.remove(this.horizontalScrollBarProperties_onChange);
            };
            this._horizontalScrollBarProperties = PropertyProxy(_arg1);
            if (this._horizontalScrollBarProperties)
            {
                this._horizontalScrollBarProperties.onChange.add(this.horizontalScrollBarProperties_onChange);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get verticalScrollBarFactory():Function
        {
            return (this._verticalScrollBarFactory);
        }

        public function set verticalScrollBarFactory(_arg1:Function):void
        {
            if (this._verticalScrollBarFactory == _arg1)
            {
                return;
            };
            this._verticalScrollBarFactory = _arg1;
            this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
        }

        public function get verticalScrollBarProperties():Object
        {
            if (!this._verticalScrollBarProperties)
            {
                this._verticalScrollBarProperties = new PropertyProxy(this.verticalScrollBarProperties_onChange);
            };
            return (this._verticalScrollBarProperties);
        }

        public function set verticalScrollBarProperties(_arg1:Object):void
        {
            var _local2:PropertyProxy;
            var _local3:String;
            if (this._horizontalScrollBarProperties == _arg1)
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
            if (this._verticalScrollBarProperties)
            {
                this._verticalScrollBarProperties.onChange.remove(this.verticalScrollBarProperties_onChange);
            };
            this._verticalScrollBarProperties = PropertyProxy(_arg1);
            if (this._verticalScrollBarProperties)
            {
                this._verticalScrollBarProperties.onChange.add(this.verticalScrollBarProperties_onChange);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get horizontalScrollStep():Number
        {
            return (this._horizontalScrollStep);
        }

        public function set horizontalScrollStep(_arg1:Number):void
        {
            if (this._horizontalScrollStep == _arg1)
            {
                return;
            };
            if (isNaN(_arg1))
            {
                throw (new ArgumentError("horizontalScrollStep cannot be NaN."));
            };
            this._horizontalScrollStep = _arg1;
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
            this.invalidate(INVALIDATION_FLAG_SCROLL, INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
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
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get verticalScrollStep():Number
        {
            return (this._verticalScrollStep);
        }

        public function set verticalScrollStep(_arg1:Number):void
        {
            if (this._verticalScrollStep == _arg1)
            {
                return;
            };
            if (isNaN(_arg1))
            {
                throw (new ArgumentError("verticalScrollStep cannot be NaN."));
            };
            this._verticalScrollStep = _arg1;
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

        public function get verticalPageIndex():int
        {
            return (this._verticalPageIndex);
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
            this.invalidate(INVALIDATION_FLAG_SCROLL, INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
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
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get clipContent():Boolean
        {
            return (this._clipContent);
        }

        public function set clipContent(_arg1:Boolean):void
        {
            if (this._clipContent == _arg1)
            {
                return;
            };
            this._clipContent = _arg1;
            this.invalidate(INVALIDATION_FLAG_CLIPPING);
        }

        public function get hasElasticEdges():Boolean
        {
            return (this._hasElasticEdges);
        }

        public function set hasElasticEdges(_arg1:Boolean):void
        {
            this._hasElasticEdges = _arg1;
        }

        public function get elasticity():Number
        {
            return (this._elasticity);
        }

        public function set elasticity(_arg1:Number):void
        {
            this._elasticity = _arg1;
        }

        public function get scrollBarDisplayMode():String
        {
            return (this._scrollBarDisplayMode);
        }

        public function set scrollBarDisplayMode(_arg1:String):void
        {
            if (this._scrollBarDisplayMode == _arg1)
            {
                return;
            };
            this._scrollBarDisplayMode = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get interactionMode():String
        {
            return (this._interactionMode);
        }

        public function set interactionMode(_arg1:String):void
        {
            if (this._interactionMode == _arg1)
            {
                return;
            };
            this._interactionMode = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get hideScrollBarAnimationDuration():Number
        {
            return (this._hideScrollBarAnimationDuration);
        }

        public function set hideScrollBarAnimationDuration(_arg1:Number):void
        {
            this._hideScrollBarAnimationDuration = _arg1;
        }

        public function get elasticSnapDuration():Number
        {
            return (this._elasticSnapDuration);
        }

        public function set elasticSnapDuration(_arg1:Number):void
        {
            this._elasticSnapDuration = _arg1;
        }

        public function get pageThrowDuration():Number
        {
            return (this._pageThrowDuration);
        }

        public function set pageThrowDuration(_arg1:Number):void
        {
            this._pageThrowDuration = _arg1;
        }

        public function get throwEase():Function
        {
            return (this._throwEase);
        }

        public function set throwEase(_arg1:Function):void
        {
            this._throwEase = _arg1;
        }

        public function get onScroll():ISignal
        {
            return (this._onScroll);
        }

        public function get onDragStart():ISignal
        {
            return (this._onDragStart);
        }

        public function get onDragEnd():ISignal
        {
            return (this._onDragEnd);
        }

        public function stopScrolling():void
        {
            this._isScrollingStopped = true;
            this._velocityX = 0;
            this._velocityY = 0;
            this._previousVelocityX.length = 0;
            this._previousVelocityY.length = 0;
        }

        public function throwTo(_arg1:Number=NaN, _arg2:Number=NaN, _arg3:Number=0.5):void
        {
            if (!isNaN(_arg1))
            {
                if (this._horizontalAutoScrollTween)
                {
                    this._horizontalAutoScrollTween.paused = true;
                    this._horizontalAutoScrollTween = null;
                };
                if (this._horizontalScrollPosition != _arg1)
                {
                    this._horizontalAutoScrollTween = new GTween(this, _arg3, {horizontalScrollPosition:_arg1}, {
                        ease:this._throwEase,
                        onComplete:this.horizontalAutoScrollTween_onComplete
                    });
                }
                else
                {
                    this.finishScrollingHorizontally();
                };
            }
            else
            {
                this.hideHorizontalScrollBar();
            };
            if (!isNaN(_arg2))
            {
                if (this._verticalAutoScrollTween)
                {
                    this._verticalAutoScrollTween.paused = true;
                    this._verticalAutoScrollTween = null;
                };
                if (this._verticalScrollPosition != _arg2)
                {
                    this._verticalAutoScrollTween = new GTween(this, _arg3, {verticalScrollPosition:_arg2}, {
                        ease:this._throwEase,
                        onComplete:this.verticalAutoScrollTween_onComplete
                    });
                }
                else
                {
                    this.finishScrollingVertically();
                };
            }
            else
            {
                this.hideVerticalScrollBar();
            };
        }

        override public function hitTest(_arg1:Point, _arg2:Boolean=false):DisplayObject
        {
            var _local3:Number = _arg1.x;
            var _local4:Number = _arg1.y;
            var _local5:DisplayObject = super.hitTest(_arg1, _arg2);
            if (!_local5)
            {
                if (((_arg2) && (((!(this.visible)) || (!(this.touchable))))))
                {
                    return (null);
                };
                return (((this._hitArea.contains(_local3, _local4)) ? this : null));
            };
            return (_local5);
        }

        override public function dispose():void
        {
            this._onScroll.removeAll();
            this._onDragStart.removeAll();
            this._onDragEnd.removeAll();
            super.dispose();
        }

        override protected function initialize():void
        {
            this._onScroll.add(this.internal_onScroll);
        }

        override protected function draw():void
        {
            var _local2:Boolean;
            var _local1:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
            _local2 = this.isInvalid(INVALIDATION_FLAG_DATA);
            var _local3:Boolean = ((_local2) || (this.isInvalid(INVALIDATION_FLAG_SCROLL)));
            var _local4:Boolean = this.isInvalid(INVALIDATION_FLAG_CLIPPING);
            var _local5:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
            var _local6:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
            if (_local6)
            {
                this.createScrollBars();
            };
            if (((_local6) || (_local5)))
            {
                this.refreshScrollBarStyles();
                this.refreshInteractionModeEvents();
            };
            if ((this.horizontalScrollBar is FoxholeControl))
            {
                FoxholeControl(this.horizontalScrollBar).validate();
            };
            if ((this.verticalScrollBar is FoxholeControl))
            {
                FoxholeControl(this.verticalScrollBar).validate();
            };
            this.ignoreViewPortResizing = true;
            if (((((((_local1) || (_local5))) || (_local6))) || (_local2)))
            {
                this.refreshViewPortBoundsWithoutFixedScrollBars();
            };
            _local1 = ((this.autoSizeIfNeeded()) || (_local1));
            if (((((((_local1) || (_local5))) || (_local6))) || (_local2)))
            {
                this.refreshViewPortBoundsWithFixedScrollBars();
            };
            this.ignoreViewPortResizing = false;
            if (((((((_local1) || (_local5))) || (_local2))) || (_local6)))
            {
                if (this._horizontalAutoScrollTween)
                {
                    this._horizontalAutoScrollTween.paused = true;
                    this._horizontalAutoScrollTween = null;
                };
                if (this._verticalAutoScrollTween)
                {
                    this._verticalAutoScrollTween.paused = true;
                    this._verticalAutoScrollTween = null;
                };
                this._touchPointID = -1;
                this._velocityX = 0;
                this._velocityY = 0;
                this._previousVelocityX.length = 0;
                this._previousVelocityY.length = 0;
                this.removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
                this.stage.removeEventListener(TouchEvent.TOUCH, this.stage_touchHandler);
                if (this._snapToPages)
                {
                    this._horizontalScrollPosition = Math.max(0, roundToNearest(this._horizontalScrollPosition, this.actualWidth));
                    this._verticalScrollPosition = Math.max(0, roundToNearest(this._verticalScrollPosition, this.actualHeight));
                    this._horizontalPageIndex = Math.round((this._horizontalScrollPosition / this.actualWidth));
                    this._verticalPageIndex = Math.round((this._verticalScrollPosition / this.actualHeight));
                };
                this.refreshMaxScrollPositions();
            };
            if (((((((_local1) || (_local3))) || (_local6))) || (_local2)))
            {
                this.refreshScrollBarValues();
            };
            if (((((((_local1) || (_local5))) || (_local6))) || (_local2)))
            {
                this.layout();
            };
            if (((((((((((_local1) || (_local3))) || (_local5))) || (_local6))) || (_local2))) || (_local4)))
            {
                this.scrollContent();
            };
        }

        protected function autoSizeIfNeeded():Boolean
        {
            var _local1:Boolean = isNaN(this.explicitWidth);
            var _local2:Boolean = isNaN(this.explicitHeight);
            if (((!(_local1)) && (!(_local2))))
            {
                return (false);
            };
            var _local3:Number = this.explicitWidth;
            var _local4:Number = this.explicitHeight;
            if (_local1)
            {
                _local3 = (this._viewPort.width + this._verticalScrollBarWidthOffset);
            };
            if (_local2)
            {
                _local4 = (this._viewPort.height + this._horizontalScrollBarHeightOffset);
            };
            return (this.setSizeInternal(_local3, _local4, false));
        }

        protected function createScrollBars():void
        {
            var _local1:DisplayObject;
            var _local2:DisplayObject;
            if (this.horizontalScrollBar)
            {
                this.horizontalScrollBar.onChange.remove(this.horizontalScrollBar_onChange);
                DisplayObject(this.horizontalScrollBar).removeFromParent(true);
                this.horizontalScrollBar = null;
            };
            if (this.verticalScrollBar)
            {
                this.verticalScrollBar.onChange.remove(this.verticalScrollBar_onChange);
                DisplayObject(this.verticalScrollBar).removeFromParent(true);
                this.verticalScrollBar = null;
            };
            if (((((!((this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_NONE))) && (!((this._horizontalScrollPolicy == SCROLL_POLICY_OFF))))) && (!((this._horizontalScrollBarFactory == null)))))
            {
                this.horizontalScrollBar = this._horizontalScrollBarFactory();
                this.horizontalScrollBar.onChange.add(this.horizontalScrollBar_onChange);
                _local1 = DisplayObject(this.horizontalScrollBar);
                this.addChild(_local1);
            };
            if (((((!((this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_NONE))) && (!((this._verticalScrollPolicy == SCROLL_POLICY_OFF))))) && (!((this._verticalScrollBarFactory == null)))))
            {
                this.verticalScrollBar = this._verticalScrollBarFactory();
                this.verticalScrollBar.onChange.add(this.verticalScrollBar_onChange);
                _local2 = DisplayObject(this.verticalScrollBar);
                this.addChild(_local2);
            };
        }

        protected function refreshScrollBarStyles():void
        {
            var _local1:Object;
            var _local2:String;
            var _local3:DisplayObject;
            var _local4:Object;
            var _local5:DisplayObject;
            if (this.horizontalScrollBar)
            {
                _local1 = this.horizontalScrollBar;
                for (_local2 in this._horizontalScrollBarProperties)
                {
                    if (_local1.hasOwnProperty(_local2))
                    {
                        _local4 = this._horizontalScrollBarProperties[_local2];
                        this.horizontalScrollBar[_local2] = _local4;
                    };
                };
                if (this._horizontalScrollBarHideTween)
                {
                    this._horizontalScrollBarHideTween.paused = true;
                    this._horizontalScrollBarHideTween = null;
                };
                _local3 = DisplayObject(this.horizontalScrollBar);
                _local3.alpha = (((this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FLOAT)) ? 0 : 1);
                _local3.touchable = (this._interactionMode == INTERACTION_MODE_MOUSE);
            };
            if (this.verticalScrollBar)
            {
                _local1 = this.verticalScrollBar;
                for (_local2 in this._verticalScrollBarProperties)
                {
                    if (_local1.hasOwnProperty(_local2))
                    {
                        _local4 = this._verticalScrollBarProperties[_local2];
                        this.verticalScrollBar[_local2] = _local4;
                    };
                };
                if (this._verticalScrollBarHideTween)
                {
                    this._verticalScrollBarHideTween.paused = true;
                    this._verticalScrollBarHideTween = null;
                };
                _local5 = DisplayObject(this.verticalScrollBar);
                _local5.alpha = (((this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FLOAT)) ? 0 : 1);
                _local5.touchable = (this._interactionMode == INTERACTION_MODE_MOUSE);
            };
        }

        protected function refreshViewPortBoundsWithoutFixedScrollBars():void
        {
            var _local3:IViewPort;
            var _local1:Number = 0;
            var _local2:Number = 0;
            if (this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FIXED)
            {
                _local1 = ((this.horizontalScrollBar) ? DisplayObject(this.horizontalScrollBar).height : 0);
                _local2 = ((this.verticalScrollBar) ? DisplayObject(this.verticalScrollBar).width : 0);
            };
            if ((this._viewPort is IViewPort))
            {
                _local3 = IViewPort(this._viewPort);
                if (isNaN(this.explicitWidth))
                {
                    _local3.visibleWidth = NaN;
                }
                else
                {
                    _local3.visibleWidth = (this.explicitWidth - _local2);
                };
                if (isNaN(this.explicitHeight))
                {
                    _local3.visibleHeight = NaN;
                }
                else
                {
                    _local3.visibleHeight = (this.explicitHeight - _local1);
                };
                _local3.minVisibleWidth = (this._minWidth - _local2);
                _local3.maxVisibleWidth = (this._maxWidth - _local2);
                _local3.minVisibleHeight = (this._minHeight - _local1);
                _local3.maxVisibleHeight = (this._maxHeight - _local1);
            };
            if ((this._viewPort is FoxholeControl))
            {
                FoxholeControl(this._viewPort).validate();
            };
            this._horizontalScrollBarHeightOffset = 0;
            this._verticalScrollBarWidthOffset = 0;
            if (this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FIXED)
            {
                if (this.horizontalScrollBar)
                {
                    if ((((this._horizontalScrollPolicy == SCROLL_POLICY_ON)) || ((((((this._viewPort.width > this.explicitWidth)) || ((this._viewPort.width > this._maxWidth)))) && (!((this._verticalScrollPolicy == SCROLL_POLICY_OFF)))))))
                    {
                        this._horizontalScrollBarHeightOffset = _local1;
                    };
                };
                if (this.verticalScrollBar)
                {
                    if ((((this._verticalScrollPolicy == SCROLL_POLICY_ON)) || ((((((this._viewPort.height > this.explicitHeight)) || ((this._viewPort.height > this._maxHeight)))) && (!((this._verticalScrollPolicy == SCROLL_POLICY_OFF)))))))
                    {
                        this._verticalScrollBarWidthOffset = _local2;
                    };
                };
            };
        }

        protected function refreshViewPortBoundsWithFixedScrollBars():void
        {
            var _local1 = (this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FIXED);
            var _local2:DisplayObject = (this.horizontalScrollBar as DisplayObject);
            var _local3:DisplayObject = (this.verticalScrollBar as DisplayObject);
            if (_local2)
            {
                _local2.visible = ((!(_local1)) || ((this._horizontalScrollBarHeightOffset > 0)));
            };
            if (_local3)
            {
                _local3.visible = ((!(_local1)) || ((this._verticalScrollBarWidthOffset > 0)));
            };
            if (!_local1)
            {
                return;
            };
            var _local4:IViewPort = (this._viewPort as IViewPort);
            if (_local4)
            {
                _local4.visibleWidth = (this.actualWidth - this._verticalScrollBarWidthOffset);
                _local4.visibleHeight = (this.actualHeight - this._horizontalScrollBarHeightOffset);
                if ((_local4 is FoxholeControl))
                {
                    FoxholeControl(_local4).validate();
                };
            };
        }

        protected function refreshMaxScrollPositions():void
        {
            if (this._viewPort)
            {
                this._maxHorizontalScrollPosition = Math.max(0, ((this._viewPort.width + this._verticalScrollBarWidthOffset) - this.actualWidth));
                this._maxVerticalScrollPosition = Math.max(0, ((this._viewPort.height + this._horizontalScrollBarHeightOffset) - this.actualHeight));
            }
            else
            {
                this._maxHorizontalScrollPosition = 0;
                this._maxVerticalScrollPosition = 0;
            };
            var _local1:Number = this._horizontalScrollPosition;
            var _local2:Number = this._verticalScrollPosition;
            this._horizontalScrollPosition = clamp(this._horizontalScrollPosition, 0, this._maxHorizontalScrollPosition);
            this._verticalScrollPosition = clamp(this._verticalScrollPosition, 0, this._maxVerticalScrollPosition);
            if (((!((_local1 == this._horizontalScrollPosition))) || (!((_local2 == this._verticalScrollPosition)))))
            {
                this._onScroll.dispatch(this);
            };
        }

        protected function refreshScrollBarValues():void
        {
            if (this.horizontalScrollBar)
            {
                this.horizontalScrollBar.minimum = 0;
                this.horizontalScrollBar.maximum = this._maxHorizontalScrollPosition;
                this.horizontalScrollBar.value = this._horizontalScrollPosition;
                this.horizontalScrollBar.page = this.actualWidth;
                this.horizontalScrollBar.step = this._horizontalScrollStep;
            };
            if (this.verticalScrollBar)
            {
                this.verticalScrollBar.minimum = 0;
                this.verticalScrollBar.maximum = this._maxVerticalScrollPosition;
                this.verticalScrollBar.value = this._verticalScrollPosition;
                this.verticalScrollBar.page = this.actualHeight;
                this.verticalScrollBar.step = this._verticalScrollStep;
            };
        }

        protected function refreshInteractionModeEvents():void
        {
            var _local1:DisplayObject = (this.horizontalScrollBar as DisplayObject);
            var _local2:DisplayObject = (this.verticalScrollBar as DisplayObject);
            if (this._interactionMode == INTERACTION_MODE_TOUCH)
            {
                this.addEventListener(TouchEvent.TOUCH, this.touchHandler);
            }
            else
            {
                this.removeEventListener(TouchEvent.TOUCH, this.touchHandler);
            };
            if ((((this._interactionMode == INTERACTION_MODE_MOUSE)) && ((this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FLOAT))))
            {
                if (_local1)
                {
                    _local1.addEventListener(TouchEvent.TOUCH, this.horizontalScrollBar_touchHandler);
                };
                if (_local2)
                {
                    _local2.addEventListener(TouchEvent.TOUCH, this.verticalScrollBar_touchHandler);
                };
            }
            else
            {
                if (_local1)
                {
                    _local1.removeEventListener(TouchEvent.TOUCH, this.horizontalScrollBar_touchHandler);
                };
                if (_local2)
                {
                    _local2.removeEventListener(TouchEvent.TOUCH, this.verticalScrollBar_touchHandler);
                };
            };
        }

        protected function layout():void
        {
            if ((this.horizontalScrollBar is FoxholeControl))
            {
                FoxholeControl(this.horizontalScrollBar).validate();
            };
            if ((this.verticalScrollBar is FoxholeControl))
            {
                FoxholeControl(this.verticalScrollBar).validate();
            };
            var _local1:DisplayObject = (this.horizontalScrollBar as DisplayObject);
            if (_local1)
            {
                _local1.x = 0;
                _local1.y = (this.actualHeight - _local1.height);
                _local1.width = this.actualWidth;
                if (this._verticalScrollBarWidthOffset > 0)
                {
                    _local1.width = (_local1.width - this._verticalScrollBarWidthOffset);
                };
            };
            var _local2:DisplayObject = (this.verticalScrollBar as DisplayObject);
            if (_local2)
            {
                _local2.x = (this.actualWidth - _local2.width);
                _local2.y = 0;
                _local2.height = this.actualHeight;
                if (this._horizontalScrollBarHeightOffset >= 0)
                {
                    _local2.height = (_local2.height - this._horizontalScrollBarHeightOffset);
                };
            };
        }

        protected function scrollContent():void
        {
            var _local3:Rectangle;
            var _local1:Number = 0;
            var _local2:Number = 0;
            if (this._maxHorizontalScrollPosition == 0)
            {
                if (this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
                {
                    _local1 = ((this.actualWidth - this._viewPort.width) / 2);
                }
                else
                {
                    if (this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
                    {
                        _local1 = (this.actualWidth - this._viewPort.width);
                    };
                };
            };
            if (this._maxVerticalScrollPosition == 0)
            {
                if (this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
                {
                    _local2 = ((this.actualHeight - this._viewPort.height) / 2);
                }
                else
                {
                    if (this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
                    {
                        _local2 = (this.actualHeight - this._viewPort.height);
                    };
                };
            };
            if (this._clipContent)
            {
                this._viewPortWrapper.x = 0;
                this._viewPortWrapper.y = 0;
                if (!this._viewPortWrapper.scrollRect)
                {
                    this._viewPortWrapper.scrollRect = new Rectangle();
                };
                _local3 = this._viewPortWrapper.scrollRect;
                _local3.width = this.actualWidth;
                _local3.height = this.actualHeight;
                _local3.x = (this._horizontalScrollPosition - _local1);
                _local3.y = (this._verticalScrollPosition - _local2);
                this._viewPortWrapper.scrollRect = _local3;
            }
            else
            {
                if (this._viewPortWrapper.scrollRect)
                {
                    this._viewPortWrapper.scrollRect = null;
                };
                this._viewPortWrapper.x = (-(this._horizontalScrollPosition) + _local1);
                this._viewPortWrapper.y = (-(this._verticalScrollPosition) + _local2);
            };
        }

        protected function updateHorizontalScrollFromTouchPosition(_arg1:Number):void
        {
            var _local2:Number = (this._startTouchX - _arg1);
            var _local3:Number = (this._startHorizontalScrollPosition + _local2);
            if (_local3 < 0)
            {
                if (this._hasElasticEdges)
                {
                    _local3 = (_local3 * this._elasticity);
                }
                else
                {
                    _local3 = 0;
                };
            }
            else
            {
                if (_local3 > this._maxHorizontalScrollPosition)
                {
                    if (this._hasElasticEdges)
                    {
                        _local3 = (_local3 - ((_local3 - this._maxHorizontalScrollPosition) * (1 - this._elasticity)));
                    }
                    else
                    {
                        _local3 = this._maxHorizontalScrollPosition;
                    };
                };
            };
            this.horizontalScrollPosition = _local3;
        }

        protected function updateVerticalScrollFromTouchPosition(_arg1:Number):void
        {
            var _local2:Number = (this._startTouchY - _arg1);
            var _local3:Number = (this._startVerticalScrollPosition + _local2);
            if (_local3 < 0)
            {
                if (this._hasElasticEdges)
                {
                    _local3 = (_local3 * this._elasticity);
                }
                else
                {
                    _local3 = 0;
                };
            }
            else
            {
                if (_local3 > this._maxVerticalScrollPosition)
                {
                    if (this._hasElasticEdges)
                    {
                        _local3 = (_local3 - ((_local3 - this._maxVerticalScrollPosition) * (1 - this._elasticity)));
                    }
                    else
                    {
                        _local3 = this._maxVerticalScrollPosition;
                    };
                };
            };
            this.verticalScrollPosition = _local3;
        }

        private function finishScrollingHorizontally():void
        {
            var _local1:Number = NaN;
            if (this._horizontalScrollPosition < 0)
            {
                _local1 = 0;
            }
            else
            {
                if (this._horizontalScrollPosition > this._maxHorizontalScrollPosition)
                {
                    _local1 = this._maxHorizontalScrollPosition;
                };
            };
            this._isDraggingHorizontally = false;
            this.throwTo(_local1, NaN, this._elasticSnapDuration);
        }

        private function finishScrollingVertically():void
        {
            var _local1:Number = NaN;
            if (this._verticalScrollPosition < 0)
            {
                _local1 = 0;
            }
            else
            {
                if (this._verticalScrollPosition > this._maxVerticalScrollPosition)
                {
                    _local1 = this._maxVerticalScrollPosition;
                };
            };
            this._isDraggingVertically = false;
            this.throwTo(NaN, _local1, this._elasticSnapDuration);
        }

        protected function throwHorizontally(_arg1:Number):void
        {
            var _local4:Number;
            var _local5:Number;
            var _local6:Number;
            if (this._snapToPages)
            {
                _local4 = ((1000 * _arg1) / Capabilities.screenDPI);
                if (_local4 > MINIMUM_PAGE_VELOCITY)
                {
                    _local5 = roundDownToNearest(this._horizontalScrollPosition, this.actualWidth);
                }
                else
                {
                    if (_local4 < -(MINIMUM_PAGE_VELOCITY))
                    {
                        _local5 = roundUpToNearest(this._horizontalScrollPosition, this.actualWidth);
                    }
                    else
                    {
                        _local5 = roundToNearest(this._horizontalScrollPosition, this.actualWidth);
                    };
                };
                _local5 = Math.max(0, Math.min(this._maxHorizontalScrollPosition, _local5));
                this.throwTo(_local5, NaN, this._pageThrowDuration);
                this._horizontalPageIndex = Math.round((_local5 / this.actualWidth));
                return;
            };
            var _local2:Number = Math.abs(_arg1);
            if (_local2 <= MINIMUM_VELOCITY)
            {
                this.finishScrollingHorizontally();
                return;
            };
            var _local3:Number = (this._horizontalScrollPosition + ((_arg1 - MINIMUM_VELOCITY) / Math.log(FRICTION)));
            if ((((_local3 < 0)) || ((_local3 > this._maxHorizontalScrollPosition))))
            {
                _local6 = 0;
                _local3 = this._horizontalScrollPosition;
                while (Math.abs(_arg1) > MINIMUM_VELOCITY)
                {
                    _local3 = (_local3 - _arg1);
                    if ((((_local3 < 0)) || ((_local3 > this._maxHorizontalScrollPosition))))
                    {
                        if (this._hasElasticEdges)
                        {
                            _arg1 = (_arg1 * (FRICTION * EXTRA_FRICTION));
                        }
                        else
                        {
                            _local3 = clamp(_local3, 0, this._maxHorizontalScrollPosition);
                            _local6++;
                            break;
                        };
                    }
                    else
                    {
                        _arg1 = (_arg1 * FRICTION);
                    };
                    _local6++;
                };
            }
            else
            {
                _local6 = (Math.log((MINIMUM_VELOCITY / _local2)) / Math.log(FRICTION));
            };
            this.throwTo(_local3, NaN, (_local6 / 1000));
        }

        protected function throwVertically(_arg1:Number):void
        {
            var _local4:Number;
            var _local5:Number;
            var _local6:Number;
            if (this._snapToPages)
            {
                _local4 = ((1000 * _arg1) / Capabilities.screenDPI);
                if (_local4 > MINIMUM_PAGE_VELOCITY)
                {
                    _local5 = roundDownToNearest(this._verticalScrollPosition, this.actualHeight);
                }
                else
                {
                    if (_local4 < -(MINIMUM_PAGE_VELOCITY))
                    {
                        _local5 = roundUpToNearest(this._verticalScrollPosition, this.actualHeight);
                    }
                    else
                    {
                        _local5 = roundToNearest(this._verticalScrollPosition, this.actualHeight);
                    };
                };
                _local5 = Math.max(0, Math.min(this._maxVerticalScrollPosition, _local5));
                this.throwTo(NaN, _local5, this._pageThrowDuration);
                this._verticalPageIndex = Math.round((_local5 / this.actualHeight));
                return;
            };
            var _local2:Number = Math.abs(_arg1);
            if (_local2 <= MINIMUM_VELOCITY)
            {
                this.finishScrollingVertically();
                return;
            };
            var _local3:Number = (this._verticalScrollPosition + ((_arg1 - MINIMUM_VELOCITY) / Math.log(FRICTION)));
            if ((((_local3 < 0)) || ((_local3 > this._maxVerticalScrollPosition))))
            {
                _local6 = 0;
                _local3 = this._verticalScrollPosition;
                while (Math.abs(_arg1) > MINIMUM_VELOCITY)
                {
                    _local3 = (_local3 - _arg1);
                    if ((((_local3 < 0)) || ((_local3 > this._maxVerticalScrollPosition))))
                    {
                        if (this._hasElasticEdges)
                        {
                            _arg1 = (_arg1 * (FRICTION * EXTRA_FRICTION));
                        }
                        else
                        {
                            _local3 = clamp(_local3, 0, this._maxVerticalScrollPosition);
                            _local6++;
                            break;
                        };
                    }
                    else
                    {
                        _arg1 = (_arg1 * FRICTION);
                    };
                    _local6++;
                };
            }
            else
            {
                _local6 = (Math.log((MINIMUM_VELOCITY / _local2)) / Math.log(FRICTION));
            };
            this.throwTo(NaN, _local3, (_local6 / 1000));
        }

        protected function hideHorizontalScrollBar(_arg1:Number=0):void
        {
            if (((((!(this.horizontalScrollBar)) || (!((this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FLOAT))))) || (this._horizontalScrollBarHideTween)))
            {
                return;
            };
            var _local2:DisplayObject = DisplayObject(this.horizontalScrollBar);
            if (_local2.alpha == 0)
            {
                return;
            };
            this._horizontalScrollBarHideTween = new GTween(this.horizontalScrollBar, this._hideScrollBarAnimationDuration, {alpha:0}, {
                delay:_arg1,
                ease:Sine.easeOut,
                onComplete:this.horizontalScrollBarHideTween_onComplete
            });
        }

        protected function hideVerticalScrollBar(_arg1:Number=0):void
        {
            if (((((!(this.verticalScrollBar)) || (!((this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FLOAT))))) || (this._verticalScrollBarHideTween)))
            {
                return;
            };
            var _local2:DisplayObject = DisplayObject(this.verticalScrollBar);
            if (_local2.alpha == 0)
            {
                return;
            };
            this._verticalScrollBarHideTween = new GTween(this.verticalScrollBar, this._hideScrollBarAnimationDuration, {alpha:0}, {
                delay:_arg1,
                ease:Sine.easeOut,
                onComplete:this.verticalScrollBarHideTween_onComplete
            });
        }

        protected function internal_onScroll(_arg1:Scroller):void
        {
            this.refreshScrollBarValues();
        }

        protected function horizontalScrollBarProperties_onChange(_arg1:PropertyProxy, _arg2:Object):void
        {
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        protected function verticalScrollBarProperties_onChange(_arg1:PropertyProxy, _arg2:Object):void
        {
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        protected function verticalScrollBar_onChange(_arg1:IScrollBar):void
        {
            this.verticalScrollPosition = _arg1.value;
        }

        protected function horizontalScrollBar_onChange(_arg1:IScrollBar):void
        {
            this.horizontalScrollPosition = _arg1.value;
        }

        protected function viewPort_onResize(_arg1:FoxholeControl):void
        {
            if (this.ignoreViewPortResizing)
            {
                return;
            };
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        protected function horizontalAutoScrollTween_onComplete(_arg1:GTween):void
        {
            this._horizontalAutoScrollTween = null;
            this.finishScrollingHorizontally();
        }

        protected function verticalAutoScrollTween_onComplete(_arg1:GTween):void
        {
            this._verticalAutoScrollTween = null;
            this.finishScrollingVertically();
        }

        protected function horizontalScrollBarHideTween_onComplete(_arg1:GTween):void
        {
            this._horizontalScrollBarHideTween = null;
        }

        protected function verticalScrollBarHideTween_onComplete(_arg1:GTween):void
        {
            this._verticalScrollBarHideTween = null;
        }

        protected function touchHandler(_arg1:TouchEvent):void
        {
            if (((!(this._isEnabled)) || ((this._touchPointID >= 0))))
            {
                return;
            };
            var _local2:Touch = _arg1.getTouch(this, TouchPhase.BEGAN);
            if (!_local2)
            {
                return;
            };
            _local2.getLocation(this, helperPoint);
            if (this._horizontalAutoScrollTween)
            {
                this._horizontalAutoScrollTween.paused = true;
                this._horizontalAutoScrollTween = null;
            };
            if (this._verticalAutoScrollTween)
            {
                this._verticalAutoScrollTween.paused = true;
                this._verticalAutoScrollTween = null;
            };
            this._touchPointID = _local2.id;
            this._velocityX = 0;
            this._velocityY = 0;
            this._previousVelocityX.length = 0;
            this._previousVelocityY.length = 0;
            this._previousTouchTime = getTimer();
            this._previousTouchX = (this._startTouchX = (this._currentTouchX = helperPoint.x));
            this._previousTouchY = (this._startTouchY = (this._currentTouchY = helperPoint.y));
            this._startHorizontalScrollPosition = this._horizontalScrollPosition;
            this._startVerticalScrollPosition = this._verticalScrollPosition;
            this._isDraggingHorizontally = false;
            this._isDraggingVertically = false;
            this._isScrollingStopped = false;
            this.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
            this.stage.addEventListener(TouchEvent.TOUCH, this.stage_touchHandler);
        }

        protected function enterFrameHandler(_arg1:Event):void
        {
            var _local2:int;
            if (this._isScrollingStopped)
            {
                return;
            };
            _local2 = getTimer();
            var _local3:int = (_local2 - this._previousTouchTime);
            if (_local3 > 0)
            {
                this._previousVelocityX.unshift(this._velocityX);
                if (this._previousVelocityX.length > MAXIMUM_SAVED_VELOCITY_COUNT)
                {
                    this._previousVelocityX.pop();
                };
                this._previousVelocityY.unshift(this._velocityY);
                if (this._previousVelocityY.length > MAXIMUM_SAVED_VELOCITY_COUNT)
                {
                    this._previousVelocityY.pop();
                };
                this._velocityX = ((this._currentTouchX - this._previousTouchX) / _local3);
                this._velocityY = ((this._currentTouchY - this._previousTouchY) / _local3);
                this._previousTouchTime = _local2;
                this._previousTouchX = this._currentTouchX;
                this._previousTouchY = this._currentTouchY;
            };
            var _local4:Number = (Math.abs((this._currentTouchX - this._startTouchX)) / Capabilities.screenDPI);
            var _local5:Number = (Math.abs((this._currentTouchY - this._startTouchY)) / Capabilities.screenDPI);
            if ((((((((this._horizontalScrollPolicy == SCROLL_POLICY_ON)) || ((((this._horizontalScrollPolicy == SCROLL_POLICY_AUTO)) && ((this._maxHorizontalScrollPosition > 0)))))) && (!(this._isDraggingHorizontally)))) && ((_local4 >= MINIMUM_DRAG_DISTANCE))))
            {
                if (this.horizontalScrollBar)
                {
                    if (this._horizontalScrollBarHideTween)
                    {
                        this._horizontalScrollBarHideTween.paused = true;
                        this._horizontalScrollBarHideTween = null;
                    };
                    if (this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FLOAT)
                    {
                        DisplayObject(this.horizontalScrollBar).alpha = 1;
                    };
                };
                if (!this._isDraggingVertically)
                {
                    this._onDragStart.dispatch(this);
                };
                this._isDraggingHorizontally = true;
            };
            if ((((((((((this._verticalScrollPolicy == SCROLL_POLICY_ON)) || ((((this._verticalScrollPolicy == SCROLL_POLICY_AUTO)) && ((this._maxVerticalScrollPosition > 0)))))) || ((((((this._verticalScrollPolicy == SCROLL_POLICY_AUTO)) && ((this._maxHorizontalScrollPosition == 0)))) && (!((this._horizontalScrollPolicy == SCROLL_POLICY_ON))))))) && (!(this._isDraggingVertically)))) && ((_local5 >= MINIMUM_DRAG_DISTANCE))))
            {
                if (!this._isDraggingHorizontally)
                {
                    if (this.verticalScrollBar)
                    {
                        if (this._verticalScrollBarHideTween)
                        {
                            this._verticalScrollBarHideTween.paused = true;
                            this._verticalScrollBarHideTween = null;
                        };
                        if (this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FLOAT)
                        {
                            DisplayObject(this.verticalScrollBar).alpha = 1;
                        };
                    };
                    this._onDragStart.dispatch(this);
                };
                this._isDraggingVertically = true;
            };
            if (((this._isDraggingHorizontally) && (!(this._horizontalAutoScrollTween))))
            {
                this.updateHorizontalScrollFromTouchPosition(this._currentTouchX);
            };
            if (((this._isDraggingVertically) && (!(this._verticalAutoScrollTween))))
            {
                this.updateVerticalScrollFromTouchPosition(this._currentTouchY);
            };
        }

        protected function stage_touchHandler(_arg1:TouchEvent):void
        {
            var _local3:Touch;
            var _local4:Touch;
            var _local5:Boolean;
            var _local6:Boolean;
            var _local7:Number;
            var _local8:int;
            var _local9:Number;
            var _local10:int;
            var _local11:Number;
            var _local2:Vector.<Touch> = _arg1.getTouches(this.stage);
            if ((((_local2.length == 0)) || ((this._touchPointID < 0))))
            {
                return;
            };
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
                _local3.getLocation(this, helperPoint);
                this._currentTouchX = helperPoint.x;
                this._currentTouchY = helperPoint.y;
            }
            else
            {
                if (_local3.phase == TouchPhase.ENDED)
                {
                    this.removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
                    this.stage.removeEventListener(TouchEvent.TOUCH, this.stage_touchHandler);
                    this._touchPointID = -1;
                    this._onDragEnd.dispatch(this);
                    _local5 = false;
                    _local6 = false;
                    if ((((this._horizontalScrollPosition < 0)) || ((this._horizontalScrollPosition > this._maxHorizontalScrollPosition))))
                    {
                        _local5 = true;
                        this.finishScrollingHorizontally();
                    };
                    if ((((this._verticalScrollPosition < 0)) || ((this._verticalScrollPosition > this._maxVerticalScrollPosition))))
                    {
                        _local6 = true;
                        this.finishScrollingVertically();
                    };
                    if (((_local5) && (_local6)))
                    {
                        return;
                    };
                    if (((!(_local5)) && (this._isDraggingHorizontally)))
                    {
                        _local7 = (this._velocityX * 2.33);
                        _local8 = this._previousVelocityX.length;
                        _local9 = 0;
                        _local10 = 0;
                        while (_local10 < _local8)
                        {
                            _local11 = VELOCITY_WEIGHTS[_local10];
                            _local7 = (_local7 + (this._previousVelocityX.shift() * _local11));
                            _local9 = (_local9 + _local11);
                            _local10++;
                        };
                        this.throwHorizontally((_local7 / _local9));
                    }
                    else
                    {
                        this.hideHorizontalScrollBar();
                    };
                    if (((!(_local6)) && (this._isDraggingVertically)))
                    {
                        _local7 = (this._velocityY * 2.33);
                        _local8 = this._previousVelocityY.length;
                        _local9 = 0;
                        _local10 = 0;
                        while (_local10 < _local8)
                        {
                            _local11 = VELOCITY_WEIGHTS[_local10];
                            _local7 = (_local7 + (this._previousVelocityY.shift() * _local11));
                            _local9 = (_local9 + _local11);
                            _local10++;
                        };
                        this.throwVertically((_local7 / _local9));
                    }
                    else
                    {
                        this.hideVerticalScrollBar();
                    };
                };
            };
        }

        protected function nativeStage_mouseWheelHandler(_arg1:MouseEvent):void
        {
            if (this._verticalScrollBarHideTween)
            {
                this._verticalScrollBarHideTween.paused = true;
                this._verticalScrollBarHideTween = null;
            };
            if (((this.verticalScrollBar) && ((this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FLOAT))))
            {
                DisplayObject(this.verticalScrollBar).alpha = 1;
            };
            helperPoint.x = _arg1.stageX;
            helperPoint.y = _arg1.stageY;
            this.globalToLocal(helperPoint, helperPoint);
            if (this.hitTest(helperPoint, true))
            {
                this.verticalScrollPosition = Math.min(this._maxVerticalScrollPosition, Math.max(0, (this._verticalScrollPosition - (_arg1.delta * this._verticalScrollStep))));
            };
            this.hideVerticalScrollBar(0.25);
        }

        protected function horizontalScrollBar_touchHandler(_arg1:TouchEvent):void
        {
            var _local2:DisplayObject;
            var _local4:Touch;
            var _local5:Touch;
            var _local6:Boolean;
            _local2 = DisplayObject(_arg1.currentTarget);
            var _local3:Vector.<Touch> = _arg1.getTouches(_local2);
            if (_local3.length == 0)
            {
                this.hideHorizontalScrollBar();
                return;
            };
            if (this._horizontalScrollBarTouchPointID >= 0)
            {
                for each (_local5 in _local3)
                {
                    if (_local5.id == this._horizontalScrollBarTouchPointID)
                    {
                        _local4 = _local5;
                        break;
                    };
                };
                if (!_local4)
                {
                    this.hideHorizontalScrollBar();
                    return;
                };
                if (_local4.phase == TouchPhase.ENDED)
                {
                    this._horizontalScrollBarTouchPointID = -1;
                    _local4.getLocation(_local2, helperPoint);
                    ScrollRectManager.adjustTouchLocation(helperPoint, _local2);
                    _local6 = !((_local2.hitTest(helperPoint, true) == null));
                    if (!_local6)
                    {
                        this.hideHorizontalScrollBar();
                    };
                    return;
                };
            }
            else
            {
                for each (_local4 in _local3)
                {
                    if (_local4.phase == TouchPhase.HOVER)
                    {
                        if (this._horizontalScrollBarHideTween)
                        {
                            this._horizontalScrollBarHideTween.paused = true;
                            this._horizontalScrollBarHideTween = null;
                        };
                        _local2.alpha = 1;
                        return;
                    };
                    if (_local4.phase == TouchPhase.BEGAN)
                    {
                        this._horizontalScrollBarTouchPointID = _local4.id;
                        return;
                    };
                };
            };
        }

        protected function verticalScrollBar_touchHandler(_arg1:TouchEvent):void
        {
            var _local2:DisplayObject;
            var _local4:Touch;
            var _local5:Touch;
            var _local6:Boolean;
            _local2 = DisplayObject(_arg1.currentTarget);
            var _local3:Vector.<Touch> = _arg1.getTouches(_local2);
            if (_local3.length == 0)
            {
                this.hideVerticalScrollBar();
                return;
            };
            if (this._verticalScrollBarTouchPointID >= 0)
            {
                for each (_local5 in _local3)
                {
                    if (_local5.id == this._verticalScrollBarTouchPointID)
                    {
                        _local4 = _local5;
                        break;
                    };
                };
                if (!_local4)
                {
                    this.hideVerticalScrollBar();
                    return;
                };
                if (_local4.phase == TouchPhase.ENDED)
                {
                    this._verticalScrollBarTouchPointID = -1;
                    _local4.getLocation(_local2, helperPoint);
                    ScrollRectManager.adjustTouchLocation(helperPoint, _local2);
                    _local6 = !((_local2.hitTest(helperPoint, true) == null));
                    if (!_local6)
                    {
                        this.hideVerticalScrollBar();
                    };
                    return;
                };
            }
            else
            {
                for each (_local4 in _local3)
                {
                    if (_local4.phase == TouchPhase.HOVER)
                    {
                        if (this._verticalScrollBarHideTween)
                        {
                            this._verticalScrollBarHideTween.paused = true;
                            this._verticalScrollBarHideTween = null;
                        };
                        _local2.alpha = 1;
                        return;
                    };
                    if (_local4.phase == TouchPhase.BEGAN)
                    {
                        this._verticalScrollBarTouchPointID = _local4.id;
                        return;
                    };
                };
            };
        }

        protected function addedToStageHandler(_arg1:Event):void
        {
            Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_WHEEL, this.nativeStage_mouseWheelHandler);
        }

        protected function removedFromStageHandler(_arg1:Event):void
        {
            Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_WHEEL, this.nativeStage_mouseWheelHandler);
            this._touchPointID = -1;
            this._horizontalScrollBarTouchPointID = -1;
            this._verticalScrollBarTouchPointID = -1;
            this._velocityX = 0;
            this._velocityY = 0;
            this._previousVelocityX.length = 0;
            this._previousVelocityY.length = 0;
            this.removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
            this.stage.removeEventListener(TouchEvent.TOUCH, this.stage_touchHandler);
            if (this._verticalAutoScrollTween)
            {
                this._verticalAutoScrollTween.paused = true;
                this._verticalAutoScrollTween = null;
            };
            if (this._horizontalAutoScrollTween)
            {
                this._horizontalAutoScrollTween.paused = true;
                this._horizontalAutoScrollTween = null;
            };
            var _local2:Number = this._horizontalScrollPosition;
            var _local3:Number = this._verticalScrollPosition;
            this._horizontalScrollPosition = clamp(this._horizontalScrollPosition, 0, this._maxHorizontalScrollPosition);
            this._verticalScrollPosition = clamp(this._verticalScrollPosition, 0, this._maxVerticalScrollPosition);
            if (((!((_local2 == this._horizontalScrollPosition))) || (!((_local3 == this._verticalScrollPosition)))))
            {
                this._onScroll.dispatch(this);
            };
        }


    }
}//package org.josht.starling.foxhole.controls
