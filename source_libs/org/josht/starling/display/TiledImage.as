//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.display
{
    import flash.geom.Point;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import starling.display.QuadBatch;
    import starling.textures.Texture;
    import starling.events.Event;
    import starling.textures.TextureSmoothing;
    import starling.utils.MatrixUtil;
    import starling.display.DisplayObject;
    import starling.core.RenderSupport;

    public class TiledImage extends Sprite 
    {

        private static var helperPoint:Point = new Point();
        private static var helperMatrix:Matrix = new Matrix();

        private var _propertiesChanged:Boolean = true;
        private var _layoutChanged:Boolean = true;
        private var _clippingChanged:Boolean = true;
        private var _hitArea:Rectangle;
        private var _batch:QuadBatch;
        private var _image:Image;
        private var _originalImageWidth:Number;
        private var _originalImageHeight:Number;
        private var _width:Number = NaN;
        private var _height:Number = NaN;
        private var _texture:Texture;
        private var _smoothing:String = "bilinear";
        private var _color:uint = 0xFFFFFF;
        private var _textureScale:Number = 1;
        private var _clipContent:Boolean = false;

        public function TiledImage(_arg1:Texture, _arg2:Number=1)
        {
            this._hitArea = new Rectangle();
            this._textureScale = _arg2;
            this.texture = _arg1;
            this.initializeWidthAndHeight();
            this._batch = new QuadBatch();
            this._batch.touchable = false;
            this.addChild(this._batch);
            this.addEventListener(Event.FLATTEN, this.flattenHandler);
        }

        override public function get width():Number
        {
            return (this._width);
        }

        override public function set width(_arg1:Number):void
        {
            if (this._width == _arg1)
            {
                return;
            };
            this._width = (this._hitArea.width = _arg1);
            this._layoutChanged = true;
        }

        override public function get height():Number
        {
            return (this._height);
        }

        override public function set height(_arg1:Number):void
        {
            if (this._height == _arg1)
            {
                return;
            };
            this._height = (this._hitArea.height = _arg1);
            this._layoutChanged = true;
        }

        public function get texture():Texture
        {
            return (this._texture);
        }

        public function set texture(_arg1:Texture):void
        {
            if (_arg1 == null)
            {
                throw (new ArgumentError("Texture cannot be null"));
            };
            if (this._texture == _arg1)
            {
                return;
            };
            this._texture = _arg1;
            if (!this._image)
            {
                this._image = new Image(_arg1);
                this._image.touchable = false;
            }
            else
            {
                this._image.texture = _arg1;
                this._image.readjustSize();
            };
            var _local2:Rectangle = _arg1.frame;
            this._originalImageWidth = _local2.width;
            this._originalImageHeight = _local2.height;
            this._layoutChanged = true;
        }

        public function get smoothing():String
        {
            return (this._smoothing);
        }

        public function set smoothing(_arg1:String):void
        {
            if (TextureSmoothing.isValid(_arg1))
            {
                this._smoothing = _arg1;
            }
            else
            {
                throw (new ArgumentError(("Invalid smoothing mode: " + _arg1)));
            };
            this._propertiesChanged = true;
        }

        public function get color():uint
        {
            return (this._color);
        }

        public function set color(_arg1:uint):void
        {
            if (this._color == _arg1)
            {
                return;
            };
            this._color = _arg1;
            this._propertiesChanged = true;
        }

        public function get textureScale():Number
        {
            return (this._textureScale);
        }

        public function set textureScale(_arg1:Number):void
        {
            if (this._textureScale == _arg1)
            {
                return;
            };
            this._textureScale = _arg1;
            this._layoutChanged = true;
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
            this._clippingChanged = true;
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
                _local3 = this._hitArea.x;
                _local5 = this._hitArea.y;
                _local4 = (this._hitArea.x + this._hitArea.width);
                _local6 = (this._hitArea.y + this._hitArea.height);
            }
            else
            {
                this.getTransformationMatrix(_arg1, helperMatrix);
                MatrixUtil.transformCoords(helperMatrix, this._hitArea.x, this._hitArea.y, helperPoint);
                _local3 = (((_local3 < helperPoint.x)) ? _local3 : helperPoint.x);
                _local4 = (((_local4 > helperPoint.x)) ? _local4 : helperPoint.x);
                _local5 = (((_local5 < helperPoint.y)) ? _local5 : helperPoint.y);
                _local6 = (((_local6 > helperPoint.y)) ? _local6 : helperPoint.y);
                MatrixUtil.transformCoords(helperMatrix, this._hitArea.x, (this._hitArea.y + this._hitArea.height), helperPoint);
                _local3 = (((_local3 < helperPoint.x)) ? _local3 : helperPoint.x);
                _local4 = (((_local4 > helperPoint.x)) ? _local4 : helperPoint.x);
                _local5 = (((_local5 < helperPoint.y)) ? _local5 : helperPoint.y);
                _local6 = (((_local6 > helperPoint.y)) ? _local6 : helperPoint.y);
                MatrixUtil.transformCoords(helperMatrix, (this._hitArea.x + this._hitArea.width), this._hitArea.y, helperPoint);
                _local3 = (((_local3 < helperPoint.x)) ? _local3 : helperPoint.x);
                _local4 = (((_local4 > helperPoint.x)) ? _local4 : helperPoint.x);
                _local5 = (((_local5 < helperPoint.y)) ? _local5 : helperPoint.y);
                _local6 = (((_local6 > helperPoint.y)) ? _local6 : helperPoint.y);
                MatrixUtil.transformCoords(helperMatrix, (this._hitArea.x + this._hitArea.width), (this._hitArea.y + this._hitArea.height), helperPoint);
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
            if (((_arg2) && (((!(this.visible)) || (!(this.touchable))))))
            {
                return (null);
            };
            return (((this._hitArea.containsPoint(_arg1)) ? this : null));
        }

        public function setSize(_arg1:Number, _arg2:Number):void
        {
            this.width = _arg1;
            this.height = _arg2;
        }

        override public function flatten():void
        {
            this.validate();
            super.flatten();
        }

        override public function render(_arg1:RenderSupport, _arg2:Number):void
        {
            this.validate();
            super.render(_arg1, _arg2);
        }

        protected function validate():void
        {
            var _local1:Number;
            var _local2:Number;
            var _local3:int;
            var _local4:int;
            var _local5:int;
            var _local6:Number;
            var _local7:Number;
            var _local8:int;
            var _local9:Rectangle;
            if (this._propertiesChanged)
            {
                this._image.smoothing = this._smoothing;
                this._image.color = this._color;
            };
            if (((this._propertiesChanged) || (this._layoutChanged)))
            {
                this._batch.reset();
                this._image.scaleX = (this._image.scaleY = this._textureScale);
                _local1 = (this._originalImageWidth * this._textureScale);
                _local2 = (this._originalImageHeight * this._textureScale);
                _local3 = Math.ceil((this._width / _local1));
                _local4 = Math.ceil((this._height / _local2));
                _local5 = (_local3 * _local4);
                _local6 = 0;
                _local7 = 0;
                _local8 = 0;
                while (_local8 < _local5)
                {
                    this._image.x = _local6;
                    this._image.y = _local7;
                    this._batch.addImage(this._image);
                    _local6 = (_local6 + _local1);
                    if (_local6 >= this._width)
                    {
                        _local6 = 0;
                        _local7 = (_local7 + _local2);
                    };
                    _local8++;
                };
            };
            if (((this._clippingChanged) || (this._layoutChanged)))
            {
                if (this._clipContent)
                {
                    _local9 = this.scrollRect;
                    if (!_local9)
                    {
                        _local9 = new Rectangle();
                    };
                    _local9.width = this._width;
                    _local9.height = this._height;
                    this.scrollRect = _local9;
                }
                else
                {
                    this.scrollRect = null;
                };
            };
            this._layoutChanged = false;
            this._propertiesChanged = false;
            this._clippingChanged = false;
        }

        private function initializeWidthAndHeight():void
        {
            this.width = (this._originalImageWidth * this._textureScale);
            this.height = (this._originalImageHeight * this._textureScale);
        }

        private function flattenHandler(_arg1:Event):void
        {
            this.validate();
        }


    }
}//package org.josht.starling.display
