//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.core
{
    import org.josht.starling.display.Sprite;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import org.josht.starling.foxhole.controls.text.BitmapFontTextRenderer;
    import flash.geom.Rectangle;
    import org.osflash.signals.Signal;
    import starling.events.Event;
    import org.osflash.signals.ISignal;
    import starling.utils.MatrixUtil;
    import starling.display.DisplayObject;

    public class FoxholeControl extends Sprite 
    {

        private static const helperMatrix:Matrix = new Matrix();
        private static const helperPoint:Point = new Point();
        public static const INVALIDATION_FLAG_ALL:String = "all";
        public static const INVALIDATION_FLAG_STATE:String = "state";
        public static const INVALIDATION_FLAG_SIZE:String = "size";
        public static const INVALIDATION_FLAG_STYLES:String = "styles";
        public static const INVALIDATION_FLAG_DATA:String = "data";
        public static const INVALIDATION_FLAG_SCROLL:String = "scroll";
        public static const INVALIDATION_FLAG_SELECTED:String = "selected";
        protected static const INVALIDATION_FLAG_TEXT_RENDERER:String = "textRenderer";

        protected static var validationQueue:ValidationQueue;
        public static var defaultTextRendererFactory:Function = function ():ITextRenderer
        {
            return (new BitmapFontTextRenderer());
        };

        protected var _nameList:TokenList;
        private var _isQuickHitAreaEnabled:Boolean = false;
        protected var _hitArea:Rectangle;
        private var _isInitialized:Boolean = false;
        private var _isAllInvalid:Boolean = false;
        private var _invalidationFlags:Object;
        private var _delayedInvalidationFlags:Object;
        protected var _isEnabled:Boolean = true;
        protected var explicitWidth:Number = NaN;
        protected var actualWidth:Number = 0;
        protected var explicitHeight:Number = NaN;
        protected var actualHeight:Number = 0;
        private var _minTouchWidth:Number = 0;
        private var _minTouchHeight:Number = 0;
        protected var _minWidth:Number = 0;
        protected var _minHeight:Number = 0;
        protected var _maxWidth:Number = Infinity;
        protected var _maxHeight:Number = Infinity;
        protected var _onResize:Signal;
        private var _isValidating:Boolean = false;
        private var _invalidateCount:int = 0;

        public function FoxholeControl()
        {
            this._nameList = new TokenList();
            this._hitArea = new Rectangle();
            this._invalidationFlags = {};
            this._delayedInvalidationFlags = {};
            this._onResize = new Signal(FoxholeControl);
            super();
            this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
        }

        public function get nameList():TokenList
        {
            return (this._nameList);
        }

        override public function get name():String
        {
            return (this._nameList.value);
        }

        override public function set name(_arg1:String):void
        {
            this._nameList.value = _arg1;
        }

        public function get isQuickHitAreaEnabled():Boolean
        {
            return (this._isQuickHitAreaEnabled);
        }

        public function set isQuickHitAreaEnabled(_arg1:Boolean):void
        {
            this._isQuickHitAreaEnabled = _arg1;
        }

        public function get isEnabled():Boolean
        {
            return (this._isEnabled);
        }

        public function set isEnabled(_arg1:Boolean):void
        {
            if (this._isEnabled == _arg1)
            {
                return;
            };
            this._isEnabled = _arg1;
            this.invalidate(INVALIDATION_FLAG_STATE);
        }

        override public function get width():Number
        {
            return (this.actualWidth);
        }

        override public function set width(_arg1:Number):void
        {
            if ((((this.explicitWidth == _arg1)) || (((isNaN(_arg1)) && (isNaN(this.explicitWidth))))))
            {
                return;
            };
            this.explicitWidth = _arg1;
            this.setSizeInternal(_arg1, this.actualHeight, true);
        }

        override public function get height():Number
        {
            return (this.actualHeight);
        }

        override public function set height(_arg1:Number):void
        {
            if ((((this.explicitHeight == _arg1)) || (((isNaN(_arg1)) && (isNaN(this.explicitHeight))))))
            {
                return;
            };
            this.explicitHeight = _arg1;
            this.setSizeInternal(this.actualWidth, _arg1, true);
        }

        public function get minTouchWidth():Number
        {
            return (this._minTouchWidth);
        }

        public function set minTouchWidth(_arg1:Number):void
        {
            if (this._minTouchWidth == _arg1)
            {
                return;
            };
            this._minTouchWidth = _arg1;
            this.invalidate(INVALIDATION_FLAG_SIZE);
        }

        public function get minTouchHeight():Number
        {
            return (this._minTouchHeight);
        }

        public function set minTouchHeight(_arg1:Number):void
        {
            if (this._minTouchHeight == _arg1)
            {
                return;
            };
            this._minTouchHeight = _arg1;
            this.invalidate(INVALIDATION_FLAG_SIZE);
        }

        public function get minWidth():Number
        {
            return (this._minWidth);
        }

        public function set minWidth(_arg1:Number):void
        {
            if (this._minWidth == _arg1)
            {
                return;
            };
            if (isNaN(_arg1))
            {
                throw (new ArgumentError("minWidth cannot be NaN"));
            };
            this._minWidth = _arg1;
            this.invalidate(INVALIDATION_FLAG_SIZE);
        }

        public function get minHeight():Number
        {
            return (this._minHeight);
        }

        public function set minHeight(_arg1:Number):void
        {
            if (this._minHeight == _arg1)
            {
                return;
            };
            if (isNaN(_arg1))
            {
                throw (new ArgumentError("minHeight cannot be NaN"));
            };
            this._minHeight = _arg1;
            this.invalidate(INVALIDATION_FLAG_SIZE);
        }

        public function get maxWidth():Number
        {
            return (this._maxWidth);
        }

        public function set maxWidth(_arg1:Number):void
        {
            if (this._maxWidth == _arg1)
            {
                return;
            };
            if (isNaN(_arg1))
            {
                throw (new ArgumentError("maxWidth cannot be NaN"));
            };
            this._maxWidth = _arg1;
            this.invalidate(INVALIDATION_FLAG_SIZE);
        }

        public function get maxHeight():Number
        {
            return (this._maxHeight);
        }

        public function set maxHeight(_arg1:Number):void
        {
            if (this._maxHeight == _arg1)
            {
                return;
            };
            if (isNaN(_arg1))
            {
                throw (new ArgumentError("maxHeight cannot be NaN"));
            };
            this._maxHeight = _arg1;
            this.invalidate(INVALIDATION_FLAG_SIZE);
        }

        public function get onResize():ISignal
        {
            return (this._onResize);
        }

        override public function getBounds(_arg1:DisplayObject, _arg2:Rectangle=null):Rectangle
        {
            if (this.scrollRect)
            {
                return (super.getBounds(_arg1, _arg2));
            };
            if (!_arg2)
            {
                _arg2 = new Rectangle();
            };
            var _local3:Number = Number.MAX_VALUE;
            var _local4:Number = -(Number.MAX_VALUE);
            var _local5:Number = Number.MAX_VALUE;
            var _local6:Number = -(Number.MAX_VALUE);
            if (_arg1 == this)
            {
                _local3 = 0;
                _local5 = 0;
                _local4 = this.actualWidth;
                _local6 = this.actualHeight;
            }
            else
            {
                this.getTransformationMatrix(_arg1, helperMatrix);
                MatrixUtil.transformCoords(helperMatrix, 0, 0, helperPoint);
                _local3 = (((_local3 < helperPoint.x)) ? _local3 : helperPoint.x);
                _local4 = (((_local4 > helperPoint.x)) ? _local4 : helperPoint.x);
                _local5 = (((_local5 < helperPoint.y)) ? _local5 : helperPoint.y);
                _local6 = (((_local6 > helperPoint.y)) ? _local6 : helperPoint.y);
                MatrixUtil.transformCoords(helperMatrix, 0, this.actualHeight, helperPoint);
                _local3 = (((_local3 < helperPoint.x)) ? _local3 : helperPoint.x);
                _local4 = (((_local4 > helperPoint.x)) ? _local4 : helperPoint.x);
                _local5 = (((_local5 < helperPoint.y)) ? _local5 : helperPoint.y);
                _local6 = (((_local6 > helperPoint.y)) ? _local6 : helperPoint.y);
                MatrixUtil.transformCoords(helperMatrix, this.actualWidth, 0, helperPoint);
                _local3 = (((_local3 < helperPoint.x)) ? _local3 : helperPoint.x);
                _local4 = (((_local4 > helperPoint.x)) ? _local4 : helperPoint.x);
                _local5 = (((_local5 < helperPoint.y)) ? _local5 : helperPoint.y);
                _local6 = (((_local6 > helperPoint.y)) ? _local6 : helperPoint.y);
                MatrixUtil.transformCoords(helperMatrix, this.actualWidth, this.actualHeight, helperPoint);
                _local3 = (((_local3 < helperPoint.x)) ? _local3 : helperPoint.x);
                _local4 = (((_local4 > helperPoint.x)) ? _local4 : helperPoint.x);
                _local5 = (((_local5 < helperPoint.y)) ? _local5 : helperPoint.y);
                _local6 = (((_local6 > helperPoint.y)) ? _local6 : helperPoint.y);
            };
            _arg2.x = _local3;
            _arg2.y = _local5;
            _arg2.width = (_local4 - _local3);
            _arg2.height = (_local6 - _local5);
            return (_arg2);
        }

        override public function hitTest(_arg1:Point, _arg2:Boolean=false):DisplayObject
        {
            if (this._isQuickHitAreaEnabled)
            {
                if (((_arg2) && (((!(this.visible)) || (!(this.touchable))))))
                {
                    return (null);
                };
                return (((this._hitArea.containsPoint(_arg1)) ? this : null));
            };
            return (super.hitTest(_arg1, _arg2));
        }

        public function invalidate(... _args):void
        {
            var _local4:String;
            if (!this.stage)
            {
                return;
            };
            var _local2:Boolean = this.isInvalid();
            var _local3:Boolean;
            if (this._isValidating)
            {
                for (_local4 in this._delayedInvalidationFlags)
                {
                    _local3 = true;
                    break;
                };
            };
            for each (_local4 in _args)
            {
                if (this._isValidating)
                {
                    this._delayedInvalidationFlags[_local4] = true;
                }
                else
                {
                    if (_local4 != INVALIDATION_FLAG_ALL)
                    {
                        this._invalidationFlags[_local4] = true;
                    };
                };
            };
            if ((((_args.length == 0)) || ((_args.indexOf(INVALIDATION_FLAG_ALL) >= 0))))
            {
                if (this._isValidating)
                {
                    this._delayedInvalidationFlags[INVALIDATION_FLAG_ALL] = true;
                }
                else
                {
                    this._isAllInvalid = true;
                };
            };
            if (!validationQueue)
            {
                validationQueue = new ValidationQueue();
            };
            if (this._isValidating)
            {
                if (_local3)
                {
                    return;
                };
                this._invalidateCount++;
                validationQueue.addControl(this, (this._invalidateCount >= 10));
                return;
            };
            if (_local2)
            {
                return;
            };
            this._invalidateCount = 0;
            validationQueue.addControl(this, false);
        }

        public function validate():void
        {
            var _local1:String;
            if (((!(this.stage)) || (!(this.isInvalid()))))
            {
                return;
            };
            this._isValidating = true;
            this.draw();
            for (_local1 in this._invalidationFlags)
            {
                delete this._invalidationFlags[_local1];
            };
            this._isAllInvalid = false;
            for (_local1 in this._delayedInvalidationFlags)
            {
                if (_local1 == INVALIDATION_FLAG_ALL)
                {
                    this._isAllInvalid = true;
                }
                else
                {
                    this._invalidationFlags[_local1] = true;
                };
                delete this._delayedInvalidationFlags[_local1];
            };
            this._isValidating = false;
        }

        public function isInvalid(_arg1:String=null):Boolean
        {
            if (this._isAllInvalid)
            {
                return (true);
            };
            if (!_arg1)
            {
                for (_arg1 in this._invalidationFlags)
                {
                    return (true);
                };
                return (false);
            };
            return (this._invalidationFlags[_arg1]);
        }

        public function setSize(_arg1:Number, _arg2:Number):void
        {
            this.explicitWidth = _arg1;
            this.explicitHeight = _arg2;
            this.setSizeInternal(_arg1, _arg2, true);
        }

        override public function dispose():void
        {
            this._onResize.removeAll();
            super.dispose();
        }

        protected function setSizeInternal(_arg1:Number, _arg2:Number, _arg3:Boolean):Boolean
        {
            var _local4:Boolean;
            if (!isNaN(this.explicitWidth))
            {
                _arg1 = this.explicitWidth;
            }
            else
            {
                _arg1 = Math.min(this._maxWidth, Math.max(this._minWidth, _arg1));
            };
            if (!isNaN(this.explicitHeight))
            {
                _arg2 = this.explicitHeight;
            }
            else
            {
                _arg2 = Math.min(this._maxHeight, Math.max(this._minHeight, _arg2));
            };
            if (this.actualWidth != _arg1)
            {
                this.actualWidth = _arg1;
                this._hitArea.width = Math.max(_arg1, this._minTouchWidth);
                this._hitArea.x = ((this.actualWidth - this._hitArea.width) / 2);
                if (this._hitArea.x != this._hitArea.x)
                {
                    this._hitArea.x = 0;
                };
                _local4 = true;
            };
            if (this.actualHeight != _arg2)
            {
                this.actualHeight = _arg2;
                this._hitArea.height = Math.max(_arg2, this._minTouchHeight);
                this._hitArea.y = ((this.actualHeight - this._hitArea.height) / 2);
                if (this._hitArea.y != this._hitArea.y)
                {
                    this._hitArea.y = 0;
                };
                _local4 = true;
            };
            if (_local4)
            {
                if (_arg3)
                {
                    this.invalidate(INVALIDATION_FLAG_SIZE);
                };
                this._onResize.dispatch(this);
            };
            return (_local4);
        }

        protected function initialize():void
        {
        }

        protected function draw():void
        {
        }

        private function addedToStageHandler(_arg1:Event):void
        {
            var _local2:String;
            if (_arg1.target != this)
            {
                return;
            };
            if (!this._isInitialized)
            {
                this.initialize();
                this._isInitialized = true;
            };
            for (_local2 in this._invalidationFlags)
            {
                delete this._invalidationFlags[_local2];
            };
            for (_local2 in this._delayedInvalidationFlags)
            {
                delete this._delayedInvalidationFlags[_local2];
            };
            this._isAllInvalid = false;
            this.invalidate();
        }


    }
}//package org.josht.starling.foxhole.core
