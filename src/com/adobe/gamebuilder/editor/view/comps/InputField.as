package com.adobe.gamebuilder.editor.view.comps
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.manager.InputFieldManager;
    
    import flash.geom.Rectangle;
    
    import org.josht.starling.display.Scale9Image;
    import org.josht.starling.textures.Scale9Textures;
    import org.osflash.signals.Signal;
    
    import starling.display.DisplayObjectContainer;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.text.TextField;
    import starling.textures.TextureSmoothing;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    public class InputField extends DisplayObjectContainer 
    {

        private var _bg:Scale9Image;
        private var _display:TextField;
        private var _active:Boolean;
        private var _alert:Boolean;
        private var _enabled:Boolean = true;
        private var _onActivate:Signal;
		private var _onChange:Signal;
        private var _fieldWidth:uint;
        private var _fieldHeight:uint;
        private var _labelKey:String;
        private var _restrict:String;
        private var _maxChars:uint;
        private var texturesUp:Scale9Textures;
        private var texturesAlert:Scale9Textures;
        private var texturesDisabled:Scale9Textures;
        private var _hAlign:String;
        private var _vAlign:String;

        public function InputField(_arg1:int=80, _arg2:String="", _arg3:String="", _arg4:uint=128, _arg5:uint=35)
        {
            this._onActivate = new Signal(InputField);
			this._onChange = new Signal(InputField);
            this._labelKey = _arg2;
            this._restrict = _arg3;
            this._maxChars = _arg4;
            this._fieldWidth = _arg1;
            this._fieldHeight = _arg5;
            this.texturesUp = new Scale9Textures(Assets.getTextureAtlas("Interface").getTexture("textinput_skin_up"), new Rectangle(4, 5, 26, 26));
            this.texturesAlert = new Scale9Textures(Assets.getTextureAtlas("Interface").getTexture("textinput_skin_alert"), new Rectangle(4, 5, 26, 26));
            this.texturesDisabled = new Scale9Textures(Assets.getTextureAtlas("Interface").getTexture("textinput_skin_disabled"), new Rectangle(4, 5, 26, 26));
            this._bg = new Scale9Image(this.texturesUp);
            this._bg.smoothing = TextureSmoothing.NONE;
            this._bg.width = this._fieldWidth;
            this._bg.height = this._fieldHeight;
            addChild(this._bg);
            this._display = new TextField((this._fieldWidth - 8), _arg5, "", Constants.DEFAULT_FONT, 16,0X000000 /*Constants.DEFAULT_FONT_COLOR*/);
            this._display.x = 8;
            this._display.y = -1;
            this._display.vAlign = ((this._vAlign) ? this._vAlign : VAlign.CENTER);
            this._display.hAlign = ((this._hAlign) ? this._hAlign : HAlign.LEFT);
            this._display.touchable = false;
			this._display
            addChild(this._display);
            this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
        }

        public function get maxChars():uint
        {
            return (this._maxChars);
        }

        public function set hAlign(_arg1:String):void
        {
            this._hAlign = _arg1;
            if (this._display)
            {
                this._display.hAlign = _arg1;
            };
        }

        public function set vAlign(_arg1:String):void
        {
            this._vAlign = _arg1;
            if (this._display)
            {
                this._display.vAlign = _arg1;
            };
        }

        public function get restrict():String
        {
            return (this._restrict);
        }

        private function addedToStageHandler():void
        {
            this._bg.addEventListener(TouchEvent.TOUCH, this.touchHandler);
        }

        public function get labelKey():String
        {
            return (this._labelKey);
        }

        public function get alert():Boolean
        {
            return (this._alert);
        }

        public function set alert(_arg1:Boolean):void
        {
            this._alert = _arg1;
            this.setTexture();
        }

        public function get onActivate():Signal
        {
            return (this._onActivate);
        }
		
		public function get onChange():Signal
		{
			return (this._onChange);
		}

        public function get active():Boolean
        {
            return (this._active);
        }

        public function set active(_arg1:Boolean):void
        {
            this._active = _arg1;
            this.setTexture();
        }

        public function get enabled():Boolean
        {
            return (this._enabled);
        }

        public function set enabled(_arg1:Boolean):void
        {
            this._enabled = _arg1;
            this.setTexture();
        }

        public function set text(_arg1:String):void
        {
            this._display.text = _arg1;
        }

        public function get text():String
        {
            return (this._display.text);
        }

        private function setTexture():void
        {
            if (this._bg)
            {
                if (!this._enabled)
                {
                    this._bg.textures = this.texturesDisabled;
                }
                else
                {
                    if (this._alert)
                    {
                        this._bg.textures = this.texturesAlert;
                    }
                    else
                    {
                        this._bg.textures = this.texturesUp;
                    };
                };
            };
        }

        private function activateInputOverlay():void
        {
            this.active = true;
            this.alert = false;
            InputFieldManager.instance.showInput(this);
        }

        private function touchHandler(_arg1:TouchEvent):void
        {
            var _local2:Touch;
            if (this._enabled)
            {
                _local2 = _arg1.getTouch(stage);
                if (this.text == "")
                {
                    if (_local2.phase == TouchPhase.ENDED)
                    {
                        this.activateInputOverlay();
                    };
                }
                else
                {
                    if (_local2.phase == TouchPhase.BEGAN)
                    {
                        this.activateInputOverlay();
                    };
                };
            };
        }


    }
}//package at.polypex.badplaner.view.comps
