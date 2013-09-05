//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls
{
    import org.josht.starling.foxhole.core.FoxholeControl;
    import __AS3__.vec.Vector;
    import flash.geom.Rectangle;
    import starling.display.DisplayObject;
    import org.osflash.signals.Signal;
    import org.josht.starling.display.ScrollRectManager;
    import starling.core.Starling;
    import starling.events.EnterFrameEvent;
    import org.josht.starling.foxhole.core.PopUpManager;
    import starling.display.Quad;
    import org.osflash.signals.ISignal;
    import starling.events.TouchEvent;
    import flash.events.KeyboardEvent;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchPhase;
    import flash.ui.Keyboard;
    import __AS3__.vec.*;

    public class Callout extends FoxholeControl 
    {

        public static const DIRECTION_ANY:String = "any";
        public static const DIRECTION_UP:String = "up";
        public static const DIRECTION_DOWN:String = "down";
        public static const DIRECTION_LEFT:String = "left";
        public static const DIRECTION_RIGHT:String = "right";
        public static const ARROW_POSITION_TOP:String = "top";
        public static const ARROW_POSITION_RIGHT:String = "right";
        public static const ARROW_POSITION_BOTTOM:String = "bottom";
        public static const ARROW_POSITION_LEFT:String = "left";
        protected static const DIRECTION_TO_FUNCTION:Object = {};
        protected static const callouts:Vector.<Callout> = new <Callout>[];

        private static var helperRect:Rectangle = new Rectangle();
        public static var calloutFactory:Function = defaultCalloutFactory;

        protected var _isPopUp:Boolean = false;
        protected var _touchPointID:int = -1;
        protected var _originalContentWidth:Number = NaN;
        protected var _originalContentHeight:Number = NaN;
        protected var _content:DisplayObject;
        protected var _paddingTop:Number = 0;
        protected var _paddingRight:Number = 0;
        protected var _paddingBottom:Number = 0;
        protected var _paddingLeft:Number = 0;
        private var _arrowPosition:String = "top";
        protected var _originalBackgroundWidth:Number = NaN;
        protected var _originalBackgroundHeight:Number = NaN;
        private var _backgroundSkin:DisplayObject;
        protected var currentArrowSkin:DisplayObject;
        private var _bottomArrowSkin:DisplayObject;
        private var _topArrowSkin:DisplayObject;
        private var _leftArrowSkin:DisplayObject;
        private var _rightArrowSkin:DisplayObject;
        private var _topArrowGap:Number = 0;
        private var _bottomArrowGap:Number = 0;
        private var _rightArrowGap:Number = 0;
        private var _leftArrowGap:Number = 0;
        protected var _arrowOffset:Number = 0;
        protected var _onClose:Signal;

        {
            DIRECTION_TO_FUNCTION[DIRECTION_ANY] = positionCalloutAny;
            DIRECTION_TO_FUNCTION[DIRECTION_UP] = positionCalloutAbove;
            DIRECTION_TO_FUNCTION[DIRECTION_DOWN] = positionCalloutBelow;
            DIRECTION_TO_FUNCTION[DIRECTION_LEFT] = positionCalloutLeftSide;
            DIRECTION_TO_FUNCTION[DIRECTION_RIGHT] = positionCalloutRightSide;
        }

        public function Callout()
        {
            this._onClose = new Signal(Callout);
            super();
        }

        public static function show(_arg1:DisplayObject, _arg2:DisplayObject, _arg3:String="any", _arg4:Number=NaN, _arg5:Number=NaN):Callout
        {
            var callout:Callout;
            var globalBounds:Rectangle;
            var enterFrameHandler:Function;
            var callout_onClose:Function;
            var content:DisplayObject = _arg1;
            var origin:DisplayObject = _arg2;
            var direction:String = _arg3;
            var width:Number = _arg4;
            var height:Number = _arg5;
            enterFrameHandler = function (_arg1:EnterFrameEvent):void
            {
                ScrollRectManager.getBounds(origin, Starling.current.stage, helperRect);
                if (globalBounds.equals(helperRect))
                {
                    return;
                };
                var _local2:Rectangle = globalBounds;
                globalBounds = helperRect;
                helperRect = _local2;
                positionCalloutByDirection(callout, globalBounds, direction);
            };
            callout_onClose = function (_arg1:Callout):void
            {
                Starling.current.stage.removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameHandler);
                _arg1.onClose.remove(callout_onClose);
            };
            var factory:Function = (((calloutFactory)!=null) ? calloutFactory : defaultCalloutFactory);
            callout = factory();
            callout.content = content;
            if (!isNaN(width))
            {
                callout.width = width;
            };
            if (!isNaN(height))
            {
                callout.height = height;
            };
            callout._isPopUp = true;
            PopUpManager.addPopUp(callout, true, false, calloutOverlayFactory);
            globalBounds = ScrollRectManager.getBounds(origin, Starling.current.stage);
            positionCalloutByDirection(callout, globalBounds, direction);
            callouts.push(callout);
            callout.addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameHandler);
            callout.onClose.add(callout_onClose);
            return (callout);
        }

        protected static function defaultCalloutFactory():Callout
        {
            return (new (Callout)());
        }

        protected static function positionCalloutByDirection(_arg1:Callout, _arg2:Rectangle, _arg3:String):void
        {
            var _local4:Function;
            if (DIRECTION_TO_FUNCTION.hasOwnProperty(_arg3))
            {
                _local4 = DIRECTION_TO_FUNCTION[_arg3];
                (_local4(_arg1, _arg2));
            }
            else
            {
                positionCalloutAny(_arg1, _arg2);
            };
        }

        protected static function positionCalloutAny(_arg1:Callout, _arg2:Rectangle):void
        {
            _arg1.arrowPosition = ARROW_POSITION_TOP;
            _arg1.validate();
            var _local3:Number = ((Starling.current.stage.stageHeight - _arg1.height) - (_arg2.y + _arg2.height));
            if (_local3 >= 0)
            {
                positionCalloutBelow(_arg1, _arg2);
                return;
            };
            _arg1.arrowPosition = ARROW_POSITION_BOTTOM;
            _arg1.validate();
            var _local4:Number = (_arg2.y - _arg1.height);
            if (_local4 >= 0)
            {
                positionCalloutAbove(_arg1, _arg2);
                return;
            };
            _arg1.arrowPosition = ARROW_POSITION_LEFT;
            _arg1.validate();
            var _local5:Number = ((Starling.current.stage.stageWidth - _arg1.width) - (_arg2.x + _arg2.width));
            if (_local5 >= 0)
            {
                positionCalloutRightSide(_arg1, _arg2);
                return;
            };
            _arg1.arrowPosition = ARROW_POSITION_RIGHT;
            _arg1.validate();
            var _local6:Number = (_arg2.x - _arg1.width);
            if (_local6)
            {
                positionCalloutLeftSide(_arg1, _arg2);
                return;
            };
            if ((((((_local3 >= _local4)) && ((_local3 >= _local5)))) && ((_local3 >= _local6))))
            {
                positionCalloutBelow(_arg1, _arg2);
            }
            else
            {
                if ((((_local4 >= _local5)) && ((_local4 >= _local6))))
                {
                    positionCalloutAbove(_arg1, _arg2);
                }
                else
                {
                    if (_local5 >= _local6)
                    {
                        positionCalloutRightSide(_arg1, _arg2);
                    }
                    else
                    {
                        positionCalloutLeftSide(_arg1, _arg2);
                    };
                };
            };
        }

        protected static function positionCalloutBelow(_arg1:Callout, _arg2:Rectangle):void
        {
            var _local3:Number;
            _arg1.arrowPosition = ARROW_POSITION_TOP;
            _arg1.validate();
            _local3 = (_arg2.x + ((_arg2.width - _arg1.width) / 2));
            var _local4:Number = Math.max(0, Math.min((Starling.current.stage.stageWidth - _arg1.width), _local3));
            _arg1.x = _local4;
            _arg1.y = (_arg2.y + _arg2.height);
            _arg1.arrowOffset = (_local3 - _local4);
        }

        protected static function positionCalloutAbove(_arg1:Callout, _arg2:Rectangle):void
        {
            var _local3:Number;
            _arg1.arrowPosition = ARROW_POSITION_BOTTOM;
            _arg1.validate();
            _local3 = (_arg2.x + ((_arg2.width - _arg1.width) / 2));
            var _local4:Number = Math.max(0, Math.min((Starling.current.stage.stageWidth - _arg1.width), _local3));
            _arg1.x = _local4;
            _arg1.y = (_arg2.y - _arg1.height);
            _arg1.arrowOffset = (_local3 - _local4);
        }

        protected static function positionCalloutRightSide(_arg1:Callout, _arg2:Rectangle):void
        {
            var _local3:Number;
            _arg1.arrowPosition = ARROW_POSITION_LEFT;
            _arg1.validate();
            _arg1.x = (_arg2.x + _arg2.width);
            _local3 = (_arg2.y + ((_arg2.height - _arg1.height) / 2));
            var _local4:Number = Math.max(0, Math.min((Starling.current.stage.stageHeight - _arg1.height), _local3));
            _arg1.y = _local4;
            _arg1.arrowOffset = (_local3 - _local4);
        }

        protected static function positionCalloutLeftSide(_arg1:Callout, _arg2:Rectangle):void
        {
            var _local3:Number;
            _arg1.arrowPosition = ARROW_POSITION_RIGHT;
            _arg1.validate();
            _arg1.x = (_arg2.x - _arg1.width);
            _local3 = (_arg2.y + ((_arg2.height - _arg1.height) / 2));
            var _local4:Number = Math.max(0, Math.min((Starling.current.stage.stageHeight - _arg1.height), _local3));
            _arg1.y = _local4;
            _arg1.arrowOffset = (_local3 - _local4);
        }

        protected static function calloutOverlayFactory():DisplayObject
        {
            var _local1:Quad = new Quad(100, 100, 0xFF00FF);
            _local1.alpha = 0;
            return (_local1);
        }


        public function get content():DisplayObject
        {
            return (this._content);
        }

        public function set content(_arg1:DisplayObject):void
        {
            if (this._content == _arg1)
            {
                return;
            };
            if (this._content)
            {
                this._content.removeFromParent(false);
            };
            this._content = _arg1;
            if (this._content)
            {
                this.addChild(this._content);
            };
            this._originalContentWidth = NaN;
            this._originalContentHeight = NaN;
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

        public function get arrowPosition():String
        {
            return (this._arrowPosition);
        }

        public function set arrowPosition(_arg1:String):void
        {
            if (this._arrowPosition == _arg1)
            {
                return;
            };
            this._arrowPosition = _arg1;
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
            if (this._backgroundSkin)
            {
                this.removeChild(this._backgroundSkin);
            };
            this._backgroundSkin = _arg1;
            if (this._backgroundSkin)
            {
                this._originalBackgroundWidth = this._backgroundSkin.width;
                this._originalBackgroundHeight = this._backgroundSkin.height;
                this.addChildAt(this._backgroundSkin, 0);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get bottomArrowSkin():DisplayObject
        {
            return (this._bottomArrowSkin);
        }

        public function set bottomArrowSkin(_arg1:DisplayObject):void
        {
            var _local2:int;
            if (this._bottomArrowSkin == _arg1)
            {
                return;
            };
            if (this._bottomArrowSkin)
            {
                this.removeChild(this._bottomArrowSkin);
            };
            this._bottomArrowSkin = _arg1;
            if (this._bottomArrowSkin)
            {
                this._bottomArrowSkin.visible = false;
                _local2 = this.getChildIndex(this._content);
                if (_local2 < 0)
                {
                    this.addChild(this._bottomArrowSkin);
                }
                else
                {
                    this.addChildAt(this._bottomArrowSkin, _local2);
                };
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get topArrowSkin():DisplayObject
        {
            return (this._topArrowSkin);
        }

        public function set topArrowSkin(_arg1:DisplayObject):void
        {
            var _local2:int;
            if (this._topArrowSkin == _arg1)
            {
                return;
            };
            if (this._topArrowSkin)
            {
                this.removeChild(this._topArrowSkin);
            };
            this._topArrowSkin = _arg1;
            if (this._topArrowSkin)
            {
                this._topArrowSkin.visible = false;
                _local2 = this.getChildIndex(this._content);
                if (_local2 < 0)
                {
                    this.addChild(this._topArrowSkin);
                }
                else
                {
                    this.addChildAt(this._topArrowSkin, _local2);
                };
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get leftArrowSkin():DisplayObject
        {
            return (this._leftArrowSkin);
        }

        public function set leftArrowSkin(_arg1:DisplayObject):void
        {
            var _local2:int;
            if (this._leftArrowSkin == _arg1)
            {
                return;
            };
            if (this._leftArrowSkin)
            {
                this.removeChild(this._leftArrowSkin);
            };
            this._leftArrowSkin = _arg1;
            if (this._leftArrowSkin)
            {
                this._leftArrowSkin.visible = false;
                _local2 = this.getChildIndex(this._content);
                if (_local2 < 0)
                {
                    this.addChild(this._leftArrowSkin);
                }
                else
                {
                    this.addChildAt(this._leftArrowSkin, _local2);
                };
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get rightArrowSkin():DisplayObject
        {
            return (this._rightArrowSkin);
        }

        public function set rightArrowSkin(_arg1:DisplayObject):void
        {
            var _local2:int;
            if (this._rightArrowSkin == _arg1)
            {
                return;
            };
            if (this._rightArrowSkin)
            {
                this.removeChild(this._rightArrowSkin);
            };
            this._rightArrowSkin = _arg1;
            if (this._rightArrowSkin)
            {
                this._rightArrowSkin.visible = false;
                _local2 = this.getChildIndex(this._content);
                if (_local2 < 0)
                {
                    this.addChild(this._rightArrowSkin);
                }
                else
                {
                    this.addChildAt(this._rightArrowSkin, _local2);
                };
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get topArrowGap():Number
        {
            return (this._topArrowGap);
        }

        public function set topArrowGap(_arg1:Number):void
        {
            if (this._topArrowGap == _arg1)
            {
                return;
            };
            this._topArrowGap = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get bottomArrowGap():Number
        {
            return (this._bottomArrowGap);
        }

        public function set bottomArrowGap(_arg1:Number):void
        {
            if (this._bottomArrowGap == _arg1)
            {
                return;
            };
            this._bottomArrowGap = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get rightArrowGap():Number
        {
            return (this._rightArrowGap);
        }

        public function set rightArrowGap(_arg1:Number):void
        {
            if (this._rightArrowGap == _arg1)
            {
                return;
            };
            this._rightArrowGap = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get leftArrowGap():Number
        {
            return (this._leftArrowGap);
        }

        public function set leftArrowGap(_arg1:Number):void
        {
            if (this._leftArrowGap == _arg1)
            {
                return;
            };
            this._leftArrowGap = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get arrowOffset():Number
        {
            return (this._arrowOffset);
        }

        public function set arrowOffset(_arg1:Number):void
        {
            if (this._arrowOffset == _arg1)
            {
                return;
            };
            this._arrowOffset = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get onClose():ISignal
        {
            return (this._onClose);
        }

        public function close():void
        {
            if (!this.parent)
            {
                return;
            };
            if (this._isPopUp)
            {
                PopUpManager.removePopUp(this);
            }
            else
            {
                this.removeFromParent();
            };
            this._onClose.dispatch(this);
        }

        override public function dispose():void
        {
            this._onClose.removeAll();
            super.dispose();
        }

        override protected function initialize():void
        {
            this.stage.addEventListener(TouchEvent.TOUCH, this.stage_touchHandler);
            Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, this.stage_keyDownHandler, false, int.MAX_VALUE, true);
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
        }

        override protected function draw():void
        {
            var _local1:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
            var _local2:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
            var _local3:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
            var _local4:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
            if (((_local4) || (_local3)))
            {
                this.refreshArrowSkin();
            };
            if (_local3)
            {
                if ((this._content is FoxholeControl))
                {
                    FoxholeControl(this._content).isEnabled = this._isEnabled;
                };
            };
            _local2 = ((this.autoSizeIfNeeded()) || (_local2));
            if (((((((_local2) || (_local4))) || (_local1))) || (_local3)))
            {
                this.layout();
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
            var _local3:Boolean = isNaN(this._originalContentWidth);
            var _local4:Boolean = isNaN(this._originalContentHeight);
            if (((this._content) && (((_local3) || (_local4)))))
            {
                if ((this._content is FoxholeControl))
                {
                    FoxholeControl(this._content).validate();
                };
                if (_local3)
                {
                    this._originalContentWidth = this._content.width;
                };
                if (_local4)
                {
                    this._originalContentHeight = this._content.height;
                };
            };
            var _local5:Number = this.explicitWidth;
            var _local6:Number = this.explicitHeight;
            if (_local1)
            {
                _local5 = ((this._originalContentWidth + this._paddingLeft) + this._paddingRight);
                if (!isNaN(this._originalBackgroundWidth))
                {
                    _local5 = Math.max(this._originalBackgroundWidth, _local5);
                };
                if ((((this._arrowPosition == ARROW_POSITION_LEFT)) && (this._leftArrowSkin)))
                {
                    _local5 = (_local5 + (this._leftArrowSkin.width + this._leftArrowGap));
                };
                if ((((this._arrowPosition == ARROW_POSITION_RIGHT)) && (this._rightArrowSkin)))
                {
                    _local5 = (_local5 + (this._rightArrowSkin.width + this._rightArrowGap));
                };
            };
            if (_local2)
            {
                _local6 = ((this._originalContentHeight + this._paddingTop) + this._paddingBottom);
                if (!isNaN(this._originalBackgroundHeight))
                {
                    _local6 = Math.max(this._originalBackgroundHeight, _local6);
                };
                if ((((this._arrowPosition == ARROW_POSITION_TOP)) && (this._topArrowSkin)))
                {
                    _local6 = (_local6 + (this._topArrowSkin.height + this._topArrowGap));
                };
                if ((((this._arrowPosition == ARROW_POSITION_BOTTOM)) && (this._bottomArrowSkin)))
                {
                    _local6 = (_local6 + (this._bottomArrowSkin.height + this._bottomArrowGap));
                };
            };
            _local5 = Math.min(_local5, this.stage.stageWidth);
            _local6 = Math.min(_local6, this.stage.stageHeight);
            return (this.setSizeInternal(_local5, _local6, false));
        }

        protected function refreshArrowSkin():void
        {
            this.currentArrowSkin = null;
            if (this._arrowPosition == ARROW_POSITION_BOTTOM)
            {
                this.currentArrowSkin = this._bottomArrowSkin;
            }
            else
            {
                if (this._bottomArrowSkin)
                {
                    this._bottomArrowSkin.visible = false;
                };
            };
            if (this._arrowPosition == ARROW_POSITION_TOP)
            {
                this.currentArrowSkin = this._topArrowSkin;
            }
            else
            {
                if (this._topArrowSkin)
                {
                    this._topArrowSkin.visible = false;
                };
            };
            if (this._arrowPosition == ARROW_POSITION_LEFT)
            {
                this.currentArrowSkin = this._leftArrowSkin;
            }
            else
            {
                if (this._leftArrowSkin)
                {
                    this._leftArrowSkin.visible = false;
                };
            };
            if (this._arrowPosition == ARROW_POSITION_RIGHT)
            {
                this.currentArrowSkin = this._rightArrowSkin;
            }
            else
            {
                if (this._rightArrowSkin)
                {
                    this._rightArrowSkin.visible = false;
                };
            };
            if (this.currentArrowSkin)
            {
                this.currentArrowSkin.visible = true;
            };
        }

        protected function layout():void
        {
            var _local1:Number = ((((this._leftArrowSkin) && ((this._arrowPosition == ARROW_POSITION_LEFT)))) ? (this._leftArrowSkin.width + this._leftArrowGap) : 0);
            var _local2:Number = ((((this._topArrowSkin) && ((this._arrowPosition == ARROW_POSITION_TOP)))) ? (this._topArrowSkin.height + this._topArrowGap) : 0);
            var _local3:Number = ((((this._rightArrowSkin) && ((this._arrowPosition == ARROW_POSITION_RIGHT)))) ? (this._rightArrowSkin.width + this._rightArrowGap) : 0);
            var _local4:Number = ((((this._bottomArrowSkin) && ((this._arrowPosition == ARROW_POSITION_BOTTOM)))) ? (this._bottomArrowSkin.height + this._bottomArrowGap) : 0);
            this._backgroundSkin.x = _local1;
            this._backgroundSkin.y = _local2;
            this._backgroundSkin.width = ((this.actualWidth - _local1) - _local3);
            this._backgroundSkin.height = ((this.actualHeight - _local2) - _local4);
            if (this.currentArrowSkin)
            {
                if (this._arrowPosition == ARROW_POSITION_LEFT)
                {
                    this._leftArrowSkin.x = ((this._backgroundSkin.x - this._rightArrowSkin.width) - this._leftArrowGap);
                    this._leftArrowSkin.y = ((this._arrowOffset + this._backgroundSkin.y) + ((this._backgroundSkin.height - this._leftArrowSkin.height) / 2));
                    this._leftArrowSkin.y = Math.min((((this._backgroundSkin.y + this._backgroundSkin.height) - this._paddingBottom) - this._leftArrowSkin.height), Math.max((this._backgroundSkin.y + this._paddingTop), this._leftArrowSkin.y));
                }
                else
                {
                    if (this._arrowPosition == ARROW_POSITION_RIGHT)
                    {
                        this._rightArrowSkin.x = ((this._backgroundSkin.x + this._backgroundSkin.width) + this._rightArrowGap);
                        this._rightArrowSkin.y = ((this._arrowOffset + this._backgroundSkin.y) + ((this._backgroundSkin.height - this._rightArrowSkin.height) / 2));
                        this._rightArrowSkin.y = Math.min((((this._backgroundSkin.y + this._backgroundSkin.height) - this._paddingBottom) - this._rightArrowSkin.height), Math.max((this._backgroundSkin.y + this._paddingTop), this._rightArrowSkin.y));
                    }
                    else
                    {
                        if (this._arrowPosition == ARROW_POSITION_BOTTOM)
                        {
                            this._bottomArrowSkin.x = ((this._arrowOffset + this._backgroundSkin.x) + ((this._backgroundSkin.width - this._bottomArrowSkin.width) / 2));
                            this._bottomArrowSkin.x = Math.min((((this._backgroundSkin.x + this._backgroundSkin.width) - this._paddingRight) - this._bottomArrowSkin.width), Math.max((this._backgroundSkin.x + this._paddingLeft), this._bottomArrowSkin.x));
                            this._bottomArrowSkin.y = ((this._backgroundSkin.y + this._backgroundSkin.height) + this._bottomArrowGap);
                        }
                        else
                        {
                            this._topArrowSkin.x = ((this._arrowOffset + this._backgroundSkin.x) + ((this._backgroundSkin.width - this._topArrowSkin.width) / 2));
                            this._topArrowSkin.x = Math.min((((this._backgroundSkin.x + this._backgroundSkin.width) - this._paddingRight) - this._topArrowSkin.width), Math.max((this._backgroundSkin.x + this._paddingLeft), this._topArrowSkin.x));
                            this._topArrowSkin.y = ((this._backgroundSkin.y - this._topArrowSkin.height) - this._topArrowGap);
                        };
                    };
                };
            };
            if (this._content)
            {
                this._content.x = (this._backgroundSkin.x + this._paddingLeft);
                this._content.y = (this._backgroundSkin.y + this._paddingTop);
                this._content.width = ((this._backgroundSkin.width - this._paddingLeft) - this._paddingRight);
                this._content.height = ((this._backgroundSkin.height - this._paddingTop) - this._paddingBottom);
            };
        }

        protected function removedFromStageHandler(_arg1:Event):void
        {
            this._touchPointID = -1;
            this.stage.removeEventListener(TouchEvent.TOUCH, this.stage_touchHandler);
            Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, this.stage_keyDownHandler);
        }

        protected function stage_touchHandler(_arg1:TouchEvent):void
        {
            var _local3:Touch;
            var _local4:Touch;
            if (_arg1.interactsWith(this))
            {
                return;
            };
            var _local2:Vector.<Touch> = _arg1.getTouches(this.stage);
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
                    this.close();
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
                        return;
                    };
                };
            };
        }

        protected function stage_keyDownHandler(_arg1:KeyboardEvent):void
        {
            if (((!((_arg1.keyCode == Keyboard.BACK))) && (!((_arg1.keyCode == Keyboard.ESCAPE)))))
            {
                return;
            };
            _arg1.preventDefault();
            _arg1.stopImmediatePropagation();
            this.close();
        }


    }
}//package org.josht.starling.foxhole.controls
