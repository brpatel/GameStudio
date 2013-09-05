//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls.renderers
{
    import org.josht.starling.foxhole.controls.Button;
    import flash.geom.Point;
    import starling.display.Image;
    import org.josht.starling.foxhole.controls.text.BitmapFontTextRenderer;
    import starling.display.DisplayObject;
    import org.josht.starling.foxhole.core.FoxholeControl;
    import flash.utils.Timer;
    import starling.textures.Texture;
    import flash.events.TimerEvent;
    import starling.events.TouchEvent;

    public class BaseDefaultItemRenderer extends Button 
    {

        private static const helperPoint:Point = new Point();

        protected static var DOWN_STATE_DELAY_MS:int = 250;

        protected var iconImage:Image;
        protected var accessoryImage:Image;
        protected var accessoryLabel:BitmapFontTextRenderer;
        protected var accessory:DisplayObject;
        private var _data:Object;
        protected var _owner:FoxholeControl;
        protected var _delayedCurrentState:String;
        protected var _stateDelayTimer:Timer;
        protected var _useStateDelayTimer:Boolean = true;
        private var _labelField:String = "label";
        private var _labelFunction:Function;
        private var _iconField:String = "icon";
        private var _iconFunction:Function;
        private var _iconTextureField:String = "iconTexture";
        private var _iconTextureFunction:Function;
        private var _accessoryField:String = "accessory";
        private var _accessoryFunction:Function;
        private var _accessoryTextureField:String = "accessoryTexture";
        private var _accessoryTextureFunction:Function;
        private var _accessoryLabelField:String = "accessoryLabel";
        private var _accessoryLabelFunction:Function;
        protected var _iconImageFactory:Function;
        protected var _accessoryImageFactory:Function;
        protected var _accessoryLabelFactory:Function;

        public function BaseDefaultItemRenderer()
        {
            this._iconImageFactory = defaultImageFactory;
            this._accessoryImageFactory = defaultImageFactory;
            this._accessoryLabelFactory = defaultLabelFactory;
            super();
            this.isToggle = true;
            this.isQuickHitAreaEnabled = false;
        }

        protected static function defaultImageFactory(_arg1:Texture):Image
        {
            return (new Image(_arg1));
        }

        protected static function defaultLabelFactory():BitmapFontTextRenderer
        {
            return (new BitmapFontTextRenderer());
        }


        public function get data():Object
        {
            return (this._data);
        }

        public function set data(_arg1:Object):void
        {
            if (this._data == _arg1)
            {
                return;
            };
            this._data = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get useStateDelayTimer():Boolean
        {
            return (this._useStateDelayTimer);
        }

        public function set useStateDelayTimer(_arg1:Boolean):void
        {
            this._useStateDelayTimer = _arg1;
        }

        override protected function set currentState(_arg1:String):void
        {
            if (((((this._useStateDelayTimer) && (this._stateDelayTimer))) && (this._stateDelayTimer.running)))
            {
                this._delayedCurrentState = _arg1;
                return;
            };
            if (((((this._useStateDelayTimer) && (((!(this._stateDelayTimer)) || (!(this._stateDelayTimer.running)))))) && ((_arg1 == Button.STATE_DOWN))))
            {
                this._delayedCurrentState = _arg1;
                if (this._stateDelayTimer)
                {
                    this._stateDelayTimer.reset();
                }
                else
                {
                    this._stateDelayTimer = new Timer(DOWN_STATE_DELAY_MS, 1);
                    this._stateDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.stateDelayTimer_timerCompleteHandler);
                };
                this._stateDelayTimer.start();
                return;
            };
            if (this._stateDelayTimer)
            {
                this._stateDelayTimer.stop();
            };
            super.currentState = _arg1;
        }

        public function get labelField():String
        {
            return (this._labelField);
        }

        public function set labelField(_arg1:String):void
        {
            if (this._labelField == _arg1)
            {
                return;
            };
            this._labelField = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get labelFunction():Function
        {
            return (this._labelFunction);
        }

        public function set labelFunction(_arg1:Function):void
        {
            this._labelFunction = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get iconField():String
        {
            return (this._iconField);
        }

        public function set iconField(_arg1:String):void
        {
            if (this._iconField == _arg1)
            {
                return;
            };
            this._iconField = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get iconFunction():Function
        {
            return (this._iconFunction);
        }

        public function set iconFunction(_arg1:Function):void
        {
            this._iconFunction = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get iconTextureField():String
        {
            return (this._iconTextureField);
        }

        public function set iconTextureField(_arg1:String):void
        {
            if (this._iconTextureField == _arg1)
            {
                return;
            };
            this._iconTextureField = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get iconTextureFunction():Function
        {
            return (this._iconTextureFunction);
        }

        public function set iconTextureFunction(_arg1:Function):void
        {
            this._iconTextureFunction = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get accessoryField():String
        {
            return (this._accessoryField);
        }

        public function set accessoryField(_arg1:String):void
        {
            if (this._accessoryField == _arg1)
            {
                return;
            };
            this._accessoryField = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get accessoryFunction():Function
        {
            return (this._accessoryFunction);
        }

        public function set accessoryFunction(_arg1:Function):void
        {
            if (this._accessoryFunction == _arg1)
            {
                return;
            };
            this._accessoryFunction = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get accessoryTextureField():String
        {
            return (this._accessoryTextureField);
        }

        public function set accessoryTextureField(_arg1:String):void
        {
            if (this._accessoryTextureField == _arg1)
            {
                return;
            };
            this._accessoryTextureField = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get accessoryTextureFunction():Function
        {
            return (this._accessoryTextureFunction);
        }

        public function set accessoryTextureFunction(_arg1:Function):void
        {
            if (this.accessoryTextureFunction == _arg1)
            {
                return;
            };
            this._accessoryTextureFunction = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get accessoryLabelField():String
        {
            return (this._accessoryLabelField);
        }

        public function set accessoryLabelField(_arg1:String):void
        {
            if (this._accessoryLabelField == _arg1)
            {
                return;
            };
            this._accessoryLabelField = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get accessoryLabelFunction():Function
        {
            return (this._accessoryLabelFunction);
        }

        public function set accessoryLabelFunction(_arg1:Function):void
        {
            if (this._accessoryLabelFunction == _arg1)
            {
                return;
            };
            this._accessoryLabelFunction = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get iconImageFactory():Function
        {
            return (this._iconImageFactory);
        }

        public function set iconImageFactory(_arg1:Function):void
        {
            if (this._iconImageFactory == _arg1)
            {
                return;
            };
            this._iconImageFactory = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get accessoryImageFactory():Function
        {
            return (this._accessoryImageFactory);
        }

        public function set accessoryImageFactory(_arg1:Function):void
        {
            if (this._accessoryImageFactory == _arg1)
            {
                return;
            };
            this._accessoryImageFactory = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get accessoryLabelFactory():Function
        {
            return (this._accessoryLabelFactory);
        }

        public function set accessoryLabelFactory(_arg1:Function):void
        {
            if (this._accessoryLabelFactory == _arg1)
            {
                return;
            };
            this._accessoryLabelFactory = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        override public function dispose():void
        {
            if (this.iconImage)
            {
                this.iconImage.removeFromParent(true);
            };
            if (this.accessory)
            {
                this.accessory.removeFromParent();
            };
            if (this.accessoryImage)
            {
                this.accessoryImage.dispose();
                this.accessoryImage = null;
            };
            if (this.accessoryLabel)
            {
                this.accessoryLabel.dispose();
                this.accessoryLabel = null;
            };
            super.dispose();
        }

        public function itemToLabel(_arg1:Object):String
        {
            if (this._labelFunction != null)
            {
                return ((this._labelFunction(_arg1) as String));
            };
            if (((((!((this._labelField == null))) && (_arg1))) && (_arg1.hasOwnProperty(this._labelField))))
            {
                return ((_arg1[this._labelField] as String));
            };
            if ((_arg1 is Object))
            {
                return (_arg1.toString());
            };
            return ("");
        }

        protected function itemToIcon(_arg1:Object):DisplayObject
        {
            var _local2:Texture;
            if (this._iconTextureFunction != null)
            {
                _local2 = (this._iconTextureFunction(_arg1) as Texture);
                this.refreshIconTexture(_local2);
                return (this.iconImage);
            };
            if (((((!((this._iconTextureField == null))) && (_arg1))) && (_arg1.hasOwnProperty(this._iconTextureField))))
            {
                _local2 = (_arg1[this._iconTextureField] as Texture);
                this.refreshIconTexture(_local2);
                return (this.iconImage);
            };
            if (this._iconFunction != null)
            {
                return ((this._iconFunction(_arg1) as DisplayObject));
            };
            if (((((!((this._iconField == null))) && (_arg1))) && (_arg1.hasOwnProperty(this._iconField))))
            {
                return ((_arg1[this._iconField] as DisplayObject));
            };
            return (null);
        }

        protected function itemToAccessory(_arg1:Object):DisplayObject
        {
            var _local2:Texture;
            var _local3:String;
            if (this._accessoryTextureFunction != null)
            {
                _local2 = (this._accessoryTextureFunction(_arg1) as Texture);
                this.refreshAccessoryTexture(_local2);
                return (this.accessoryImage);
            };
            if (((((!((this._accessoryTextureField == null))) && (_arg1))) && (_arg1.hasOwnProperty(this._accessoryTextureField))))
            {
                _local2 = (_arg1[this._accessoryTextureField] as Texture);
                this.refreshAccessoryTexture(_local2);
                return (this.accessoryImage);
            };
            if (this._accessoryLabelFunction != null)
            {
                _local3 = (this._accessoryLabelFunction(_arg1) as String);
                this.refreshAccessoryLabel(_local3);
                return (this.accessoryLabel);
            };
            if (((((!((this._accessoryLabelField == null))) && (_arg1))) && (_arg1.hasOwnProperty(this._accessoryLabelField))))
            {
                _local3 = (_arg1[this._accessoryLabelField] as String);
                this.refreshAccessoryLabel(_local3);
                return (this.accessoryLabel);
            };
            if (this._accessoryFunction != null)
            {
                return ((this._accessoryFunction(_arg1) as DisplayObject));
            };
            if (((((!((this._accessoryField == null))) && (_arg1))) && (_arg1.hasOwnProperty(this._accessoryField))))
            {
                return ((_arg1[this._accessoryField] as DisplayObject));
            };
            return (null);
        }

        override protected function draw():void
        {
            var _local1:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
            if (_local1)
            {
                this.commitData();
            };
            super.draw();
        }

        override protected function autoSizeIfNeeded():Boolean
        {
            var _local5:Number;
            var _local1:Boolean = isNaN(this.explicitWidth);
            var _local2:Boolean = isNaN(this.explicitHeight);
            if (((!(_local1)) && (!(_local2))))
            {
                return (false);
            };
            this.labelControl.measureText(helperPoint);
            if ((this.accessory is FoxholeControl))
            {
                FoxholeControl(this.accessory).validate();
            };
            var _local3:Number = this.explicitWidth;
            if (_local1)
            {
                if (((this.currentIcon) && (this.label)))
                {
                    if (((!((this._iconPosition == ICON_POSITION_TOP))) && (!((this._iconPosition == ICON_POSITION_BOTTOM)))))
                    {
                        _local5 = (((this._gap == Number.POSITIVE_INFINITY)) ? Math.min(this._paddingLeft, this._paddingRight) : this._gap);
                        _local3 = ((this.currentIcon.width + _local5) + helperPoint.x);
                    }
                    else
                    {
                        _local3 = Math.max(this.currentIcon.width, helperPoint.x);
                    };
                }
                else
                {
                    if (this.currentIcon)
                    {
                        _local3 = this.currentIcon.width;
                    }
                    else
                    {
                        if (this.label)
                        {
                            _local3 = helperPoint.x;
                        };
                    };
                };
                if (this.accessory)
                {
                    _local3 = (_local3 + this.accessory.width);
                };
                _local3 = (_local3 + (this._paddingLeft + this._paddingRight));
                if (isNaN(_local3))
                {
                    _local3 = this._originalSkinWidth;
                }
                else
                {
                    if (!isNaN(this._originalSkinWidth))
                    {
                        _local3 = Math.max(_local3, this._originalSkinWidth);
                    };
                };
            };
            var _local4:Number = this.explicitHeight;
            if (_local2)
            {
                if (((this.currentIcon) && (this.label)))
                {
                    if ((((this._iconPosition == ICON_POSITION_TOP)) || ((this._iconPosition == ICON_POSITION_BOTTOM))))
                    {
                        _local5 = (((this._gap == Number.POSITIVE_INFINITY)) ? Math.min(this._paddingTop, this._paddingBottom) : this._gap);
                        _local4 = ((this.currentIcon.height + _local5) + helperPoint.y);
                    }
                    else
                    {
                        _local4 = Math.max(this.currentIcon.height, helperPoint.y);
                    };
                }
                else
                {
                    if (this.currentIcon)
                    {
                        _local4 = this.currentIcon.height;
                    }
                    else
                    {
                        if (this.label)
                        {
                            _local4 = helperPoint.y;
                        };
                    };
                };
                if (this.accessory)
                {
                    _local4 = Math.max(_local4, this.accessory.height);
                };
                _local4 = (_local4 + (this._paddingTop + this._paddingBottom));
                if (isNaN(_local4))
                {
                    _local4 = this._originalSkinHeight;
                }
                else
                {
                    if (!isNaN(this._originalSkinHeight))
                    {
                        _local4 = Math.max(_local4, this._originalSkinHeight);
                    };
                };
            };
            return (this.setSizeInternal(_local3, _local4, false));
        }

        protected function commitData():void
        {
            var _local1:DisplayObject;
            if (this._owner)
            {
                this._label = this.itemToLabel(this._data);
                this.defaultIcon = this.itemToIcon(this._data);
                _local1 = this.itemToAccessory(this._data);
                if (_local1 != this.accessory)
                {
                    if (this.accessory)
                    {
                        this.accessory.removeEventListener(TouchEvent.TOUCH, this.accessory_touchHandler);
                        this.accessory.removeFromParent();
                    };
                    this.accessory = _local1;
                    if (this.accessory)
                    {
                        if ((((this.accessory is FoxholeControl)) && (!((this.accessory is BitmapFontTextRenderer)))))
                        {
                            this.accessory.addEventListener(TouchEvent.TOUCH, this.accessory_touchHandler);
                        };
                        this.addChild(this.accessory);
                    };
                };
            }
            else
            {
                this._label = "";
                this.defaultIcon = null;
                if (this.accessory)
                {
                    this.accessory.removeFromParent();
                    this.accessory = null;
                };
            };
        }

        protected function refreshIconTexture(_arg1:Texture):void
        {
            if (_arg1)
            {
                if (!this.iconImage)
                {
                    this.iconImage = this._iconImageFactory(_arg1);
                }
                else
                {
                    this.iconImage.texture = _arg1;
                    this.iconImage.readjustSize();
                };
            }
            else
            {
                if (this.iconImage)
                {
                    this.iconImage.removeFromParent(true);
                    this.iconImage = null;
                };
            };
        }

        protected function refreshAccessoryTexture(_arg1:Texture):void
        {
            if (_arg1)
            {
                if (!this.accessoryImage)
                {
                    this.accessoryImage = this._accessoryImageFactory(_arg1);
                }
                else
                {
                    this.accessoryImage.texture = _arg1;
                    this.accessoryImage.readjustSize();
                };
            }
            else
            {
                if (this.accessoryImage)
                {
                    this.accessoryImage.removeFromParent(true);
                    this.accessoryImage = null;
                };
            };
        }

        protected function refreshAccessoryLabel(_arg1:String):void
        {
            if (_arg1 !== null)
            {
                if (!this.accessoryLabel)
                {
                    this.accessoryLabel = this._accessoryLabelFactory();
                };
                this.accessoryLabel.text = _arg1;
            }
            else
            {
                if (this.accessoryLabel)
                {
                    this.accessoryLabel.removeFromParent(true);
                    this.accessoryLabel = null;
                };
            };
        }

        override protected function layoutContent():void
        {
            super.layoutContent();
            if (!this.accessory)
            {
                return;
            };
            if ((this.accessory is FoxholeControl))
            {
                FoxholeControl(this.accessory).validate();
            };
            this.accessory.x = ((this.actualWidth - this._paddingRight) - this.accessory.width);
            this.accessory.y = ((this.actualHeight - this.accessory.height) / 2);
        }

        protected function handleOwnerScroll():void
        {
            if (this._currentState != Button.STATE_UP)
            {
                super.currentState = Button.STATE_UP;
            };
            this._touchPointID = -1;
            if (((!(this._stateDelayTimer)) || (!(this._stateDelayTimer.running))))
            {
                return;
            };
            this._delayedCurrentState = null;
            this._stateDelayTimer.stop();
        }

        protected function stateDelayTimer_timerCompleteHandler(_arg1:TimerEvent):void
        {
            super.currentState = this._delayedCurrentState;
            this._delayedCurrentState = null;
        }

        protected function accessory_touchHandler(_arg1:TouchEvent):void
        {
            _arg1.stopPropagation();
        }


    }
}//package org.josht.starling.foxhole.controls.renderers
