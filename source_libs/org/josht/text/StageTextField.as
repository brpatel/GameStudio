//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.text
{
    import flash.events.EventDispatcher;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.geom.Rectangle;
    import flash.text.TextFieldType;
    import flash.text.engine.FontPosture;
    import flash.text.engine.FontWeight;
    import flash.display.Stage;
    import flash.text.TextFormatAlign;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;

    public class StageTextField extends EventDispatcher 
    {

        protected var textField:TextField;
        protected var textFormat:TextFormat;
        protected var isComplete:Boolean = false;
        private var _autoCapitalize:String = "none";
        private var _autoCorrect:Boolean = false;
        private var _color:uint = 0;
        private var _fontFamily:String = null;
        private var _locale:String = "en";
        private var _returnKeyLabel:String = "default";
        private var _softKeyboardType:String = "default";
        private var _textAlign:String = "start";
        private var _viewPort:Rectangle;

        public function StageTextField(_arg1:Object=null)
        {
            this._viewPort = new Rectangle();
            super();
            this.initialize(_arg1);
        }

        public function get autoCapitalize():String
        {
            return (this._autoCapitalize);
        }

        public function set autoCapitalize(_arg1:String):void
        {
            this._autoCapitalize = _arg1;
        }

        public function get autoCorrect():Boolean
        {
            return (this._autoCorrect);
        }

        public function set autoCorrect(_arg1:Boolean):void
        {
            this._autoCorrect = _arg1;
        }

        public function get color():uint
        {
            return ((this.textFormat.color as uint));
        }

        public function set color(_arg1:uint):void
        {
            if (this.textFormat.color == _arg1)
            {
                return;
            };
            this.textFormat.color = _arg1;
            this.textField.defaultTextFormat = this.textFormat;
            this.textField.setTextFormat(this.textFormat);
        }

        public function get displayAsPassword():Boolean
        {
            return (this.textField.displayAsPassword);
        }

        public function set displayAsPassword(_arg1:Boolean):void
        {
            this.textField.displayAsPassword = _arg1;
        }

        public function get editable():Boolean
        {
            return ((this.textField.type == TextFieldType.INPUT));
        }

        public function set editable(_arg1:Boolean):void
        {
            this.textField.type = ((_arg1) ? TextFieldType.INPUT : TextFieldType.DYNAMIC);
        }

        public function get fontFamily():String
        {
            return (this.textFormat.font);
        }

        public function set fontFamily(_arg1:String):void
        {
            if (this.textFormat.font == _arg1)
            {
                return;
            };
            this.textFormat.font = _arg1;
            this.textField.defaultTextFormat = this.textFormat;
            this.textField.setTextFormat(this.textFormat);
        }

        public function get fontPosture():String
        {
            return (((this.textFormat.italic) ? FontPosture.ITALIC : FontPosture.NORMAL));
        }

        public function set fontPosture(_arg1:String):void
        {
            if (this.fontPosture == _arg1)
            {
                return;
            };
            this.textFormat.italic = (_arg1 == FontPosture.ITALIC);
            this.textField.defaultTextFormat = this.textFormat;
            this.textField.setTextFormat(this.textFormat);
        }

        public function get fontSize():int
        {
            return ((this.textFormat.size as int));
        }

        public function set fontSize(_arg1:int):void
        {
            if (this.textFormat.size == _arg1)
            {
                return;
            };
            this.textFormat.size = _arg1;
            this.textField.defaultTextFormat = this.textFormat;
            this.textField.setTextFormat(this.textFormat);
        }

        public function get fontWeight():String
        {
            return (((this.textFormat.bold) ? FontWeight.BOLD : FontWeight.NORMAL));
        }

        public function set fontWeight(_arg1:String):void
        {
            if (this.fontWeight == _arg1)
            {
                return;
            };
            this.textFormat.bold = (_arg1 == FontWeight.BOLD);
            this.textField.defaultTextFormat = this.textFormat;
            this.textField.setTextFormat(this.textFormat);
        }

        public function get locale():String
        {
            return (this._locale);
        }

        public function set locale(_arg1:String):void
        {
            this._locale = _arg1;
        }

        public function get maxChars():int
        {
            return (this.textField.maxChars);
        }

        public function set maxChars(_arg1:int):void
        {
            this.textField.maxChars = _arg1;
        }

        private function get multiline():Boolean
        {
            return (this.textField.multiline);
        }

        public function get restrict():String
        {
            return (this.textField.restrict);
        }

        public function set restrict(_arg1:String):void
        {
            this.textField.restrict = _arg1;
        }

        public function get returnKeyLabel():String
        {
            return (this._returnKeyLabel);
        }

        public function set returnKeyLabel(_arg1:String):void
        {
            this._returnKeyLabel = _arg1;
        }

        public function get selectionActiveIndex():int
        {
            return (this.textField.selectionBeginIndex);
        }

        public function get selectionAnchorIndex():int
        {
            return (this.textField.selectionEndIndex);
        }

        public function get softKeyboardType():String
        {
            return (this._softKeyboardType);
        }

        public function set softKeyboardType(_arg1:String):void
        {
            this._softKeyboardType = _arg1;
        }

        public function get stage():Stage
        {
            return (this.textField.stage);
        }

        public function set stage(_arg1:Stage):void
        {
            if (this.textField.stage == _arg1)
            {
                return;
            };
            if (this.textField.stage)
            {
                this.textField.parent.removeChild(this.textField);
            };
            if (_arg1)
            {
                _arg1.addChild(this.textField);
                this.dispatchCompleteIfPossible();
            };
        }

        public function get text():String
        {
            return (this.textField.text);
        }

        public function set text(_arg1:String):void
        {
            this.textField.text = _arg1;
        }

        public function get textAlign():String
        {
            return (this._textAlign);
        }

        public function set textAlign(_arg1:String):void
        {
            if (this._textAlign == _arg1)
            {
                return;
            };
            this._textAlign = _arg1;
            if (_arg1 == TextFormatAlign.START)
            {
                _arg1 = TextFormatAlign.LEFT;
            }
            else
            {
                if (_arg1 == TextFormatAlign.END)
                {
                    _arg1 = TextFormatAlign.RIGHT;
                };
            };
            this.textFormat.align = _arg1;
            this.textField.defaultTextFormat = this.textFormat;
            this.textField.setTextFormat(this.textFormat);
        }

        public function get viewPort():Rectangle
        {
            return (this._viewPort);
        }

        public function set viewPort(_arg1:Rectangle):void
        {
            if (((((!(_arg1)) || ((_arg1.width < 0)))) || ((_arg1.height < 0))))
            {
                throw (new RangeError("The Rectangle value is not valid."));
            };
            this._viewPort = _arg1;
            this.textField.x = this._viewPort.x;
            this.textField.y = this._viewPort.y;
            this.textField.width = this._viewPort.width;
            this.textField.height = this._viewPort.height;
            this.dispatchCompleteIfPossible();
        }

        public function get visible():Boolean
        {
            return (this.textField.visible);
        }

        public function set visible(_arg1:Boolean):void
        {
            this.textField.visible = _arg1;
        }

        public function assignFocus():void
        {
            if (!this.textField.parent)
            {
                return;
            };
            this.textField.stage.focus = this.textField;
        }

        public function dispose():void
        {
            this.stage = null;
            this.textField = null;
            this.textFormat = null;
        }

        public function drawViewPortToBitmapData(_arg1:BitmapData):void
        {
            if (!_arg1)
            {
                throw (new Error("The bitmap is null."));
            };
            if (((!((_arg1.width == this._viewPort.width))) || (!((_arg1.height == this._viewPort.height)))))
            {
                throw (new ArgumentError("The bitmap's width or height is different from view port's width or height."));
            };
            _arg1.draw(this.textField);
        }

        public function selectRange(_arg1:int, _arg2:int):void
        {
            this.textField.setSelection(_arg1, _arg2);
        }

        protected function dispatchCompleteIfPossible():void
        {
            if (((!(this.textField.stage)) || (this._viewPort.isEmpty())))
            {
                this.isComplete = false;
            };
            if (((this.textField.stage) && (!(this.viewPort.isEmpty()))))
            {
                this.isComplete = true;
                this.dispatchEvent(new Event(Event.COMPLETE));
            };
        }

        protected function initialize(_arg1:Object):void
        {
            this.textField = new TextField();
            this.textField.type = TextFieldType.INPUT;
            this.textField.multiline = ((((_arg1) && (_arg1.hasOwnProperty("multiline")))) && (_arg1.multiline));
            this.textField.addEventListener(Event.CHANGE, this.textField_eventHandler);
            this.textField.addEventListener(FocusEvent.FOCUS_IN, this.textField_eventHandler);
            this.textField.addEventListener(FocusEvent.FOCUS_OUT, this.textField_eventHandler);
            this.textField.addEventListener(KeyboardEvent.KEY_DOWN, this.textField_eventHandler);
            this.textField.addEventListener(KeyboardEvent.KEY_UP, this.textField_eventHandler);
            this.textFormat = new TextFormat(null, 11, 0, false, false, false);
            this.textField.defaultTextFormat = this.textFormat;
        }

        protected function textField_eventHandler(_arg1:Event):void
        {
            this.dispatchEvent(_arg1);
        }


    }
}//package org.josht.text
