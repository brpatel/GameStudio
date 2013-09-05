//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls
{
    import flash.display.BitmapData;
    import flash.display3D.textures.Texture;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.text.engine.FontPosture;
    import flash.text.engine.FontWeight;
    import flash.ui.Keyboard;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
    import flash.utils.getDefinitionByName;
    
    import __AS3__.vec.Vector;
    
    import org.josht.starling.display.ScrollRectManager;
    import org.josht.starling.foxhole.core.FoxholeControl;
    import org.josht.starling.foxhole.core.PropertyProxy;
    import org.josht.text.StageTextField;
    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;
    
    import starling.core.RenderSupport;
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;
    import starling.utils.MatrixUtil;

    public class TextInput extends FoxholeControl 
    {

        private static const helperMatrix:Matrix = new Matrix();
        private static const helperPoint:Point = new Point();
        protected static const INVALIDATION_FLAG_POSITION:String = "position";

        protected var stageText:Object;
        protected var isRealStageText:Boolean = true;
        protected var _touchPointID:int = -1;
        protected var _measureTextField:TextField;
        protected var _stageTextHasFocus:Boolean = false;
        protected var currentBackground:DisplayObject;
        private var _oldGlobalX:Number = 0;
        private var _oldGlobalY:Number = 0;
        private var _savedSelectionIndex:int = -1;
        protected var _text:String = "";
        protected var _textSnapshotBitmapData:BitmapData;
        protected var _textSnapshot:Image;
        protected var _originalSkinWidth:Number = NaN;
        protected var _originalSkinHeight:Number = NaN;
        private var _backgroundSkin:DisplayObject;
        private var _backgroundDisabledSkin:DisplayObject;
        protected var _paddingTop:Number = 0;
        protected var _paddingRight:Number = 0;
        protected var _paddingBottom:Number = 0;
        protected var _paddingLeft:Number = 0;
        protected var _isWaitingToSetFocus:Boolean = false;
        protected var _oldMouseCursor:String = null;
        protected var _onChange:Signal;
		protected var _onChangeComplete:Signal;
        protected var _onEnter:Signal;
        private var _stageTextProperties:PropertyProxy;

        public function TextInput()
        {
            this._onChange = new Signal(TextInput);
			this._onChangeComplete = new Signal(TextInput);
            this._onEnter = new Signal(TextInput);
            super();
            this.isQuickHitAreaEnabled = true;
            this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
            this.addEventListener(TouchEvent.TOUCH, this.touchHandler);
        }

        override public function set x(_arg1:Number):void
        {
            super.x = _arg1;
            this.invalidate(INVALIDATION_FLAG_POSITION);
        }

        override public function set y(_arg1:Number):void
        {
            super.y = _arg1;
            this.invalidate(INVALIDATION_FLAG_POSITION);
        }

        public function get text():String
        {
            return (this._text);
        }

        public function set text(_arg1:String):void
        {
            if (!_arg1)
            {
                _arg1 = "";
            };
            if (this._text == _arg1)
            {
                return;
            };
            this._text = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
            this._onChange.dispatch(this);
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
                this._backgroundSkin.touchable = false;
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
                this._backgroundDisabledSkin.touchable = false;
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

        public function get onChange():ISignal
        {
            return (this._onChange);
        }
		
		public function get onChangeComplete():ISignal
		{
			return (this._onChangeComplete);
		}

        public function get onEnter():ISignal
        {
            return (this._onEnter);
        }

        public function get stageTextProperties():Object
        {
            if (!this._stageTextProperties)
            {
                this._stageTextProperties = new PropertyProxy(this.stageTextProperties_onChange);
            };
            return (this._stageTextProperties);
        }

        public function set stageTextProperties(_arg1:Object):void
        {
            var _local2:PropertyProxy;
            var _local3:String;
            if (this._stageTextProperties == _arg1)
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
            if (this._stageTextProperties)
            {
                this._stageTextProperties.onChange.remove(this.stageTextProperties_onChange);
            };
            this._stageTextProperties = PropertyProxy(_arg1);
            if (this._stageTextProperties)
            {
                this._stageTextProperties.onChange.add(this.stageTextProperties_onChange);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function setFocus():void
        {
            this.setFocusInternal(null);
        }

        override public function dispose():void
        {
            if (this._textSnapshotBitmapData)
            {
                this._textSnapshotBitmapData.dispose();
                this._textSnapshotBitmapData = null;
            };
            this._onChange.removeAll();
			this._onChangeComplete.removeAll();
            super.dispose();
        }

        override public function render(_arg1:RenderSupport, _arg2:Number):void
        {
            var _local3:Rectangle;
            super.render(_arg1, _arg2);
            helperPoint.x = (helperPoint.y = 0);
            this.getTransformationMatrix(this.stage, helperMatrix);
            MatrixUtil.transformCoords(helperMatrix, 0, 0, helperPoint);
            ScrollRectManager.toStageCoordinates(helperPoint, this);
            if (((!((helperPoint.x == this._oldGlobalX))) || (!((helperPoint.y == this._oldGlobalY)))))
            {
                this._oldGlobalX = helperPoint.x;
                this._oldGlobalY = helperPoint.y;
                _local3 = this.stageText.viewPort;
                if (!_local3)
                {
                    _local3 = new Rectangle();
                };
                _local3.x = Math.round(((helperPoint.x + (this._paddingLeft * this.scaleX)) * Starling.contentScaleFactor));
                _local3.y = Math.round(((helperPoint.y + (this._paddingTop * this.scaleY)) * Starling.contentScaleFactor));
                this.stageText.viewPort = _local3;
            };
            this.stageText.visible = ((this._textSnapshot) ? !(this._textSnapshot.visible) : this._stageTextHasFocus);
        }

        override protected function initialize():void
        {
            if (!this._measureTextField)
            {
                this._measureTextField = new TextField();
                this._measureTextField.visible = false;
                this._measureTextField.mouseEnabled = (this._measureTextField.mouseWheelEnabled = false);
                this._measureTextField.autoSize = TextFieldAutoSize.LEFT;
                this._measureTextField.multiline = false;
                this._measureTextField.wordWrap = false;
                this._measureTextField.embedFonts = false;
                this._measureTextField.defaultTextFormat = new TextFormat(null, 11, 0, false, false, false);
                Starling.current.nativeStage.addChild(this._measureTextField);
            };
        }

        override protected function draw():void
        {
            var _local1:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
            var _local2:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
            var _local3:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
            var _local4:Boolean = this.isInvalid(INVALIDATION_FLAG_POSITION);
            var _local5:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
            if (_local2)
            {
                this.refreshStageTextProperties();
            };
            if (_local3)
            {
                if (this.stageText.text != this._text)
                {
                    this.stageText.text = this._text;
                };
                this._measureTextField.text = this.stageText.text;
            };
            if (_local1)
            {
                this.stageText.editable = this._isEnabled;
                if (((((!(this._isEnabled)) && (Mouse.supportsNativeCursor))) && (this._oldMouseCursor)))
                {
                    Mouse.cursor = this._oldMouseCursor;
                    this._oldMouseCursor = null;
                };
            };
            if (((_local1) || (_local2)))
            {
                this.refreshBackground();
            };
            _local5 = ((this.autoSizeIfNeeded()) || (_local5));
            if (((((((_local4) || (_local5))) || (_local2))) || (_local1)))
            {
                this.layout();
            };
            if (((((_local2) || (_local3))) || (_local5)))
            {
                this.refreshSnapshot(((this._text) && (((_local5) || (!(this._textSnapshotBitmapData))))));
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
                _local3 = this._originalSkinWidth;
            };
            if (_local2)
            {
                _local4 = this._originalSkinHeight;
            };
            return (this.setSizeInternal(_local3, _local4, false));
        }

        protected function refreshStageTextProperties():void
        {
            var _local1:String;
            var _local2:TextFormat;
            var _local3:String;
            var _local4:Object;
            for (_local1 in this._stageTextProperties)
            {
                if (this.stageText.hasOwnProperty(_local1))
                {
                    _local4 = this._stageTextProperties[_local1];
                    this.stageText[_local1] = _local4;
                };
            };
            this._measureTextField.displayAsPassword = this.stageText.displayAsPassword;
            this._measureTextField.maxChars = this.stageText.maxChars;
            this._measureTextField.restrict = this.stageText.restrict;
            _local2 = this._measureTextField.defaultTextFormat;
            _local2.color = this.stageText.color;
            _local2.font = this.stageText.fontFamily;
            _local2.italic = (this.stageText.fontPosture == FontPosture.ITALIC);
            _local2.size = this.stageText.fontSize;
            _local2.bold = (this.stageText.fontWeight == FontWeight.BOLD);
            _local3 = this.stageText.textAlign;
            if (_local3 == TextFormatAlign.START)
            {
                _local3 = TextFormatAlign.LEFT;
            }
            else
            {
                if (_local3 == TextFormatAlign.END)
                {
                    _local3 = TextFormatAlign.RIGHT;
                };
            };
            _local2.align = _local3;
            this._measureTextField.defaultTextFormat = _local2;
            this._measureTextField.setTextFormat(_local2);
        }

        protected function refreshBackground():void
        {
            this.currentBackground = this._backgroundSkin;
            if (((!(this._isEnabled)) && (this._backgroundDisabledSkin)))
            {
                if (this._backgroundSkin)
                {
                    this._backgroundSkin.visible = false;
                    this._backgroundSkin.touchable = false;
                };
                this.currentBackground = this._backgroundDisabledSkin;
            }
            else
            {
                if (this._backgroundDisabledSkin)
                {
                    this._backgroundDisabledSkin.visible = false;
                    this._backgroundDisabledSkin.touchable = false;
                };
            };
            if (this.currentBackground)
            {
                if (isNaN(this._originalSkinWidth))
                {
                    this._originalSkinWidth = this.currentBackground.width;
                };
                if (isNaN(this._originalSkinHeight))
                {
                    this._originalSkinHeight = this.currentBackground.height;
                };
            };
        }

        protected function refreshSnapshot(_arg1:Boolean):void
        {
            var _local2:Rectangle;
            if (_arg1)
            {
                _local2 = this.stageText.viewPort;
                if ((((_local2.width == 0)) || ((_local2.height == 0))))
                {
                    return;
                };
                if (((((!(this._textSnapshotBitmapData)) || (!((this._textSnapshotBitmapData.width == _local2.width))))) || (!((this._textSnapshotBitmapData.height == _local2.height)))))
                {
                    if (this._textSnapshotBitmapData)
                    {
                        this._textSnapshotBitmapData.dispose();
                    };
                    this._textSnapshotBitmapData = new BitmapData(_local2.width, _local2.height, true, 0xFF00FF);
                };
            };
            if (!this._textSnapshotBitmapData)
            {
                return;
            };
            this._textSnapshotBitmapData.fillRect(this._textSnapshotBitmapData.rect, 0xFF00FF);
            this.stageText.drawViewPortToBitmapData(this._textSnapshotBitmapData);
            if (!this._textSnapshot)
            {
                this._textSnapshot = new Image(starling.textures.Texture.fromBitmapData(this._textSnapshotBitmapData, false, false, Starling.contentScaleFactor));
                this.addChild(this._textSnapshot);
            }
            else
            {
                if (_arg1)
                {
                    this._textSnapshot.texture.dispose();
                    this._textSnapshot.texture = starling.textures.Texture.fromBitmapData(this._textSnapshotBitmapData, false, false, Starling.contentScaleFactor);
                    this._textSnapshot.readjustSize();
                }
                else
                {
					flash.display3D.textures.Texture(this._textSnapshot.texture.base).uploadFromBitmapData(this._textSnapshotBitmapData);
                };
            };
            this._textSnapshot.x = Math.round(this._paddingLeft);
            this._textSnapshot.y = Math.round(this._paddingTop);
            this._textSnapshot.visible = !(this._stageTextHasFocus);
        }

        protected function setFocusInternal(_arg1:Touch):void
        {
            var _local2:Rectangle;
            if (this.stageText)
            {
                if (_arg1)
                {
                    if (this.isRealStageText)
                    {
                        this._savedSelectionIndex = -1;
                    }
                    else
                    {
                        _arg1.getLocation(this, helperPoint);
                        helperPoint.x = (helperPoint.x - this._paddingLeft);
                        helperPoint.y = (helperPoint.y - this._paddingTop);
                        if (helperPoint.x < 0)
                        {
                            this._savedSelectionIndex = 0;
                        }
                        else
                        {
                            this._savedSelectionIndex = this._measureTextField.getCharIndexAtPoint(helperPoint.x, helperPoint.y);
                            _local2 = this._measureTextField.getCharBoundaries(this._savedSelectionIndex);
                            if (((_local2) && ((((_local2.x + _local2.width) - helperPoint.x) < (helperPoint.x - _local2.x)))))
                            {
                                this._savedSelectionIndex++;
                            };
                        };
                    };
                };
                this.stageText.assignFocus();
            }
            else
            {
                this._isWaitingToSetFocus = true;
            };
        }

        protected function layout():void
        {
            if (this.currentBackground)
            {
                this.currentBackground.visible = true;
                this.currentBackground.touchable = true;
                this.currentBackground.width = this.actualWidth;
                this.currentBackground.height = this.actualHeight;
            };
            this.refreshViewPort();
        }

        protected function refreshViewPort():void
        {
            var _local1:Rectangle = this.stageText.viewPort;
            if (!_local1)
            {
                _local1 = new Rectangle();
            };
            helperPoint.x = (helperPoint.y = 0);
            this.getTransformationMatrix(this.stage, helperMatrix);
            MatrixUtil.transformCoords(helperMatrix, 0, 0, helperPoint);
            ScrollRectManager.toStageCoordinates(helperPoint, this);
            this._oldGlobalX = helperPoint.x;
            this._oldGlobalY = helperPoint.y;
            _local1.x = Math.round(((helperPoint.x + (this._paddingLeft * this.scaleX)) * Starling.contentScaleFactor));
            _local1.y = Math.round(((helperPoint.y + (this._paddingTop * this.scaleY)) * Starling.contentScaleFactor));
            _local1.width = Math.round(Math.max(1, ((((this.actualWidth - this._paddingLeft) - this._paddingRight) * Starling.contentScaleFactor) * this.scaleX)));
            _local1.height = Math.round(Math.max(1, (((this.actualHeight - this._paddingTop) * Starling.contentScaleFactor) * this.scaleY)));
            if (((isNaN(_local1.width)) || (isNaN(_local1.height))))
            {
                _local1.width = 1;
                _local1.height = 1;
            };
            this.stageText.viewPort = _local1;
        }

        protected function stageTextProperties_onChange(_arg1:PropertyProxy, _arg2:Object):void
        {
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        protected function addedToStageHandler(_arg1:Event):void
        {
            var StageTextType:Class;
            var initOptions:Object;
            var StageTextInitOptionsType:Class;
            var event:Event = _arg1;
            if (((this._measureTextField) && (!(this._measureTextField.parent))))
            {
                Starling.current.nativeStage.addChild(this._measureTextField);
            };
            try
            {
                StageTextType = Class(getDefinitionByName("flash.text.StageText"));
                StageTextInitOptionsType = Class(getDefinitionByName("flash.text.StageTextInitOptions"));
                initOptions = new StageTextInitOptionsType(false);
            }
            catch(error:Error)
            {
                isRealStageText = false;
                StageTextType = StageTextField;
                initOptions = {multiline:false};
            };
            this.stageText = new StageTextType(initOptions);
            this.stageText.visible = false;
            this.stageText.stage = Starling.current.nativeStage;
            this.stageText.addEventListener(flash.events.Event.CHANGE, this.stageText_changeHandler);
            this.stageText.addEventListener(KeyboardEvent.KEY_DOWN, this.stageText_keyDownHandler);
            this.stageText.addEventListener(FocusEvent.FOCUS_IN, this.stageText_focusInHandler);
            this.stageText.addEventListener(FocusEvent.FOCUS_OUT, this.stageText_focusOutHandler);
            this.stageText.addEventListener(Event.COMPLETE, this.stageText_completeHandler);
            this.refreshViewPort();
        }

        protected function removedFromStageHandler(_arg1:Event):void
        {
            Starling.current.nativeStage.removeChild(this._measureTextField);
            this._touchPointID = -1;
            this.stageText.removeEventListener(flash.events.Event.CHANGE, this.stageText_changeHandler);
            this.stageText.removeEventListener(KeyboardEvent.KEY_DOWN, this.stageText_keyDownHandler);
            this.stageText.removeEventListener(FocusEvent.FOCUS_IN, this.stageText_focusInHandler);
            this.stageText.removeEventListener(FocusEvent.FOCUS_OUT, this.stageText_focusOutHandler);
            this.stageText.removeEventListener(Event.COMPLETE, this.stageText_completeHandler);
            this.stageText.stage = null;
            this.stageText.dispose();
            this.stageText = null;
        }

        protected function touchHandler(_arg1:TouchEvent):void
        {
            var _local3:Touch;
            var _local4:Touch;
            var _local5:Boolean;
            if (!this._isEnabled)
            {
                return;
            };
            var _local2:Vector.<Touch> = _arg1.getTouches(this.stage);
            if (_local2.length == 0)
            {
                if (((Mouse.supportsNativeCursor) && (this._oldMouseCursor)))
                {
                    Mouse.cursor = this._oldMouseCursor;
                    this._oldMouseCursor = null;
                };
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
                    if (((Mouse.supportsNativeCursor) && (this._oldMouseCursor)))
                    {
                        Mouse.cursor = this._oldMouseCursor;
                        this._oldMouseCursor = null;
                    };
                    return;
                };
                if (_local3.phase == TouchPhase.ENDED)
                {
                    this._touchPointID = -1;
                    _local3.getLocation(this, helperPoint);
                    ScrollRectManager.adjustTouchLocation(helperPoint, this);
                    _local5 = !((this.hitTest(helperPoint, true) == null));
                    if (((!(this._stageTextHasFocus)) && (_local5)))
                    {
                        this.setFocusInternal(_local3);
                    };
                    return;
                };
            }
            else
            {
                for each (_local3 in _local2)
                {
                    if (_local3.phase == TouchPhase.HOVER)
                    {
                        if (((Mouse.supportsNativeCursor) && (!(this._oldMouseCursor))))
                        {
                            this._oldMouseCursor = Mouse.cursor;
                            Mouse.cursor = MouseCursor.IBEAM;
                        };
                        return;
                    };
                    if (_local3.phase == TouchPhase.BEGAN)
                    {
                        this._touchPointID = _local3.id;
                        return;
                    };
                };
            };
        }

        protected function stageText_changeHandler(_arg1:*):void
        {
            this.text = this.stageText.text;
        }

        protected function stageText_completeHandler(_arg1:*):void
        {
            this.stageText.removeEventListener(Event.COMPLETE, this.stageText_completeHandler);
            this.invalidate();
            if (((this._isWaitingToSetFocus) && (this._text)))
            {
                this.validate();
                this.setFocus();
            };
        }

        protected function stageText_focusInHandler(_arg1:FocusEvent):void
        {
            this._stageTextHasFocus = true;
            if (this._textSnapshot)
            {
                this._textSnapshot.visible = false;
            };
            if (this._savedSelectionIndex < 0)
            {
                this._savedSelectionIndex = this.stageText.text.length;
            };
            this.stageText.selectRange(this._savedSelectionIndex, this._savedSelectionIndex);
            this._savedSelectionIndex = -1;
        }

        protected function stageText_focusOutHandler(_arg1:FocusEvent):void
        {
            this._stageTextHasFocus = false;
            this.stageText.selectRange(1, 1);
            this.refreshSnapshot(false);
            if (this._textSnapshot)
            {
                this._textSnapshot.visible = true;
            };
			
			this._onChangeComplete.dispatch(this);
        }

        protected function stageText_keyDownHandler(_arg1:KeyboardEvent):void
        {
            if (_arg1.keyCode == Keyboard.ENTER)
            {
                this._onEnter.dispatch(this);
            }
            else
            {
                if (_arg1.keyCode == Keyboard.BACK)
                {
                    _arg1.preventDefault();
                    Starling.current.nativeStage.focus = Starling.current.nativeStage;
                };
            };
        }


    }
}//package org.josht.starling.foxhole.controls
