//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls.text
{
    import org.josht.starling.foxhole.core.FoxholeControl;
    import flash.geom.Matrix;
    import starling.display.Image;
    import starling.display.QuadBatch;
    import org.josht.starling.foxhole.text.BitmapFontTextFormat;
    import starling.text.BitmapFont;
    import flash.geom.Rectangle;
    import starling.core.RenderSupport;
    import starling.text.BitmapChar;
    import flash.geom.Point;
    import org.josht.starling.foxhole.core.*;

    public class BitmapFontTextRenderer extends FoxholeControl implements ITextRenderer 
    {

        private static const helperMatrix:Matrix = new Matrix();

        private static var helperImage:Image;

        private var _characterBatch:QuadBatch;
        protected var currentTextFormat:BitmapFontTextFormat;
        protected var _textFormat:BitmapFontTextFormat;
        protected var _disabledTextFormat:BitmapFontTextFormat;
        private var _text:String = "";
        private var _smoothing:String = "bilinear";
        private var _snapToPixels:Boolean = true;
        private var _truncationText:String = "...";

        public function BitmapFontTextRenderer()
        {
            this.isQuickHitAreaEnabled = true;
        }

        public function get textFormat():BitmapFontTextFormat
        {
            return (this._textFormat);
        }

        public function set textFormat(_arg1:BitmapFontTextFormat):void
        {
            if (this._textFormat == _arg1)
            {
                return;
            };
            this._textFormat = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get disabledTextFormat():BitmapFontTextFormat
        {
            return (this._disabledTextFormat);
        }

        public function set disabledTextFormat(_arg1:BitmapFontTextFormat):void
        {
            if (this._disabledTextFormat == _arg1)
            {
                return;
            };
            this._disabledTextFormat = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get text():String
        {
            return (this._text);
        }

        public function set text(_arg1:String):void
        {
            if (this._text == _arg1)
            {
                return;
            };
            this._text = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get smoothing():String
        {
            return (this._smoothing);
        }

        public function set smoothing(_arg1:String):void
        {
            if (this._smoothing == _arg1)
            {
                return;
            };
            this._smoothing = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get snapToPixels():Boolean
        {
            return (this._snapToPixels);
        }

        public function set snapToPixels(_arg1:Boolean):void
        {
            if (this._snapToPixels == _arg1)
            {
                return;
            };
            this._snapToPixels = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get truncationText():String
        {
            return (this._truncationText);
        }

        public function set truncationText(_arg1:String):void
        {
            if (this._truncationText == _arg1)
            {
                return;
            };
            this._truncationText = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA, INVALIDATION_FLAG_SIZE);
        }

        public function get baseline():Number
        {
            var _local2:Number;
            if (!this._textFormat)
            {
                return (0);
            };
            var _local1:BitmapFont = this._textFormat.font;
            _local2 = this._textFormat.size;
            var _local3:Number = ((isNaN(_local2)) ? 1 : (_local2 / _local1.size));
            return ((_local1.baseline * _local3));
        }

        override public function render(_arg1:RenderSupport, _arg2:Number):void
        {
            var _local3:Rectangle;
            if (this._snapToPixels)
            {
                this.getTransformationMatrix(this.stage, helperMatrix);
                this._characterBatch.x = (Math.round(helperMatrix.tx) - helperMatrix.tx);
                this._characterBatch.y = (Math.round(helperMatrix.ty) - helperMatrix.ty);
                _local3 = this.scrollRect;
                if (_local3)
                {
                    this._characterBatch.x = (this._characterBatch.x + (Math.round(_local3.x) - _local3.x));
                    this._characterBatch.y = (this._characterBatch.y + (Math.round(_local3.y) - _local3.y));
                };
            }
            else
            {
                this._characterBatch.x = (this._characterBatch.y = 0);
            };
            super.render(_arg1, _arg2);
        }

        public function measureText(_arg1:Point=null):Point
        {
            var _local3:Number;
            var _local15:int;
            var _local16:BitmapChar;
            if (((this.isInvalid(INVALIDATION_FLAG_STYLES)) || (this.isInvalid(INVALIDATION_FLAG_STATE))))
            {
                this.refreshTextFormat();
            };
            if (!_arg1)
            {
                _arg1 = new Point();
            }
            else
            {
                _arg1.x = (_arg1.y = 0);
            };
            if (!this.currentTextFormat)
            {
                return (_arg1);
            };
            var _local2:BitmapFont = this.currentTextFormat.font;
            _local3 = this.currentTextFormat.size;
            var _local4:Number = this.currentTextFormat.letterSpacing;
            var _local5:Boolean = this.currentTextFormat.isKerningEnabled;
            var _local6:Number = ((isNaN(_local3)) ? 1 : (_local3 / _local2.size));
            var _local7:uint = this.currentTextFormat.color;
            var _local8:Number = (_local2.lineHeight * _local6);
            var _local9:Number = 0;
            var _local10:Number = 0;
            var _local11:Number = 0;
            var _local12:Number = NaN;
            var _local13:int = ((this._text) ? this._text.length : 0);
            var _local14:int;
            while (_local14 < _local13)
            {
                _local15 = this._text.charCodeAt(_local14);
                if ((((_local15 == 10)) || ((_local15 == 13))))
                {
                    _local10 = Math.max(0, (_local10 - _local4));
                    _local9 = Math.max(_local9, _local10);
                    _local12 = NaN;
                    _local10 = 0;
                    _local11 = (_local11 + _local8);
                }
                else
                {
                    _local16 = _local2.getChar(_local15);
                    if (_local16)
                    {
                        if (((_local5) && (!(isNaN(_local12)))))
                        {
                            _local10 = (_local10 + _local16.getKerning(_local12));
                        };
                        _local10 = (_local10 + ((_local16.xAdvance * _local6) + _local4));
                        _local12 = _local15;
                    };
                };
                _local14++;
            };
            _local10 = Math.max(0, (_local10 - _local4));
            _local9 = Math.max(_local9, _local10);
            _arg1.x = _local9;
            _arg1.y = (_local11 + (_local2.lineHeight * _local6));
            return (_arg1);
        }

        override protected function initialize():void
        {
            this._characterBatch = new QuadBatch();
            this._characterBatch.touchable = false;
            this.addChild(this._characterBatch);
        }

        override protected function draw():void
        {
            var _local5:BitmapFont;
            var _local6:Number;
            var _local7:Number;
            var _local8:Boolean;
            var _local9:Number;
            var _local10:uint;
            var _local11:Number;
            var _local12:Number;
            var _local13:Number;
            var _local14:Number;
            var _local15:Number;
            var _local16:String;
            var _local17:int;
            var _local18:int;
            var _local19:int;
            var _local20:BitmapChar;
            var _local1:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
            var _local2:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
            var _local3:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
            var _local4:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
            if (((_local2) || (_local4)))
            {
                this.refreshTextFormat();
            };
            if (((((_local1) || (_local2))) || (_local3)))
            {
                this._characterBatch.reset();
                if (!this.currentTextFormat)
                {
                    this.setSizeInternal(0, 0, false);
                    return;
                };
                _local5 = this.currentTextFormat.font;
                _local6 = this.currentTextFormat.size;
                _local7 = this.currentTextFormat.letterSpacing;
                _local8 = this.currentTextFormat.isKerningEnabled;
                _local9 = ((isNaN(_local6)) ? 1 : (_local6 / _local5.size));
                _local10 = this.currentTextFormat.color;
                _local11 = (_local5.lineHeight * _local9);
                _local12 = 0;
                _local13 = 0;
                _local14 = 0;
                _local15 = NaN;
                _local16 = this.getTruncatedText();
                if (helperImage)
                {
                    helperImage.color = _local10;
                    helperImage.smoothing = this._smoothing;
                };
                _local17 = ((_local16) ? _local16.length : 0);
                _local18 = 0;
                while (_local18 < _local17)
                {
                    _local19 = _local16.charCodeAt(_local18);
                    if ((((_local19 == 10)) || ((_local19 == 13))))
                    {
                        _local13 = Math.max(0, (_local13 - _local7));
                        _local12 = Math.max(_local12, _local13);
                        _local15 = NaN;
                        _local13 = 0;
                        _local14 = (_local14 + _local11);
                    }
                    else
                    {
                        _local20 = _local5.getChar(_local19);
                        if (_local20)
                        {
                            if (((_local8) && (!(isNaN(_local15)))))
                            {
                                _local13 = (_local13 + _local20.getKerning(_local15));
                            };
                            if (!helperImage)
                            {
                                helperImage = new Image(_local20.texture);
                                helperImage.color = _local10;
                                helperImage.smoothing = this._smoothing;
                            }
                            else
                            {
                                helperImage.texture = _local20.texture;
                            };
                            helperImage.readjustSize();
                            helperImage.scaleX = (helperImage.scaleY = _local9);
                            helperImage.x = (_local13 + (_local20.xOffset * _local9));
                            helperImage.y = (_local14 + (_local20.yOffset * _local9));
                            if (this._snapToPixels)
                            {
                                helperImage.x = Math.round(helperImage.x);
                                helperImage.y = Math.round(helperImage.y);
                            };
                            helperImage.color = _local10;
                            helperImage.smoothing = this._smoothing;
                            _local13 = (_local13 + ((_local20.xAdvance * _local9) + _local7));
                            _local15 = _local19;
                            this._characterBatch.addImage(helperImage);
                        };
                    };
                    _local18++;
                };
                _local13 = Math.max(0, (_local13 - _local7));
                _local12 = Math.max(_local12, _local13);
                this.setSizeInternal(_local12, (_local14 + (_local5.lineHeight * _local9)), false);
            };
        }

        protected function refreshTextFormat():void
        {
            if (((!(this._isEnabled)) && (this._disabledTextFormat)))
            {
                this.currentTextFormat = this._disabledTextFormat;
            }
            else
            {
                this.currentTextFormat = this._textFormat;
            };
        }

        protected function getTruncatedText():String
        {
            var _local2:Number;
            var _local12:int;
            var _local13:BitmapChar;
            var _local14:Number;
            if ((((((this._maxWidth == Number.POSITIVE_INFINITY)) || ((this._text.indexOf(String.fromCharCode(10)) >= 0)))) || ((this._text.indexOf(String.fromCharCode(13)) >= 0))))
            {
                return (this._text);
            };
            var _local1:BitmapFont = this.currentTextFormat.font;
            _local2 = this.currentTextFormat.size;
            var _local3:Number = this.currentTextFormat.letterSpacing;
            var _local4:Boolean = this.currentTextFormat.isKerningEnabled;
            var _local5:Number = ((isNaN(_local2)) ? 1 : (_local2 / _local1.size));
            var _local6:Number = 0;
            var _local7:Number = NaN;
            var _local8:int = ((this._text) ? this._text.length : 0);
            var _local9:Boolean;
            var _local10:int = -1;
            var _local11:int;
            while (_local11 < _local8)
            {
                _local12 = this._text.charCodeAt(_local11);
                _local13 = _local1.getChar(_local12);
                if (_local13)
                {
                    _local14 = 0;
                    if (((_local4) && (!(isNaN(_local7)))))
                    {
                        _local14 = _local13.getKerning(_local7);
                    };
                    _local6 = (_local6 + (_local14 + (_local13.xAdvance * _local5)));
                    if (_local6 > this._maxWidth)
                    {
                        _local10 = _local11;
                        break;
                    };
                    _local6 = (_local6 + _local3);
                    _local7 = _local12;
                };
                _local11++;
            };
            if (_local10 >= 0)
            {
                _local8 = this._truncationText.length;
                _local11 = 0;
                while (_local11 < _local8)
                {
                    _local12 = this._truncationText.charCodeAt(_local11);
                    _local13 = _local1.getChar(_local12);
                    if (_local13)
                    {
                        _local14 = 0;
                        if (((_local4) && (!(isNaN(_local7)))))
                        {
                            _local14 = _local13.getKerning(_local7);
                        };
                        _local6 = (_local6 + ((_local14 + (_local13.xAdvance * _local5)) + _local3));
                        _local7 = _local12;
                    };
                    _local11++;
                };
                _local6 = (_local6 - _local3);
                _local11 = _local10;
                while (_local11 >= 0)
                {
                    _local12 = this._text.charCodeAt(_local11);
                    _local7 = (((_local11 > 0)) ? this._text.charCodeAt((_local11 - 1)) : NaN);
                    _local13 = _local1.getChar(_local12);
                    if (_local13)
                    {
                        _local14 = 0;
                        if (((_local4) && (!(isNaN(_local7)))))
                        {
                            _local14 = _local13.getKerning(_local7);
                        };
                        _local6 = (_local6 - ((_local14 + (_local13.xAdvance * _local5)) + _local3));
                        if (_local6 <= this._maxWidth)
                        {
                            return ((this._text.substr(0, _local11) + this._truncationText));
                        };
                    };
                    _local11--;
                };
                return (this._truncationText);
            };
            return (this._text);
        }


    }
}//package org.josht.starling.foxhole.controls.text
