//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.display
{
    import flash.errors.IllegalOperationError;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import org.josht.starling.textures.Scale3Textures;
    
    import starling.core.RenderSupport;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.QuadBatch;
    import starling.events.Event;
    import starling.utils.MatrixUtil;

    public class Scale3Image extends Sprite 
    {

        private static const helperMatrix:Matrix = new Matrix();
        private static const helperPoint:Point = new Point();

        private static var helperImage:starling.display.Image;

        private var _propertiesChanged:Boolean = true;
        private var _layoutChanged:Boolean = true;
        private var _textures:Scale3Textures;
        private var _width:Number = NaN;
        private var _height:Number = NaN;
        private var _textureScale:Number = 1;
        private var _smoothing:String = "bilinear";
        private var _color:uint = 0xFFFFFF;
        private var _hitArea:Rectangle;
        private var _batch:QuadBatch;

        public function Scale3Image(_arg1:Scale3Textures, _arg2:Number=1)
        {
            this._textures = _arg1;
            this._textureScale = _arg2;
            this._hitArea = new Rectangle();
            this.readjustSize();
            this._batch = new QuadBatch();
            this._batch.touchable = false;
            this.addChild(this._batch);
            this.addEventListener(Event.FLATTEN, this.flattenHandler);
        }

        public function get textures():Scale3Textures
        {
            return (this._textures);
        }

        public function set textures(_arg1:Scale3Textures):void
        {
            if (!_arg1)
            {
                throw (new IllegalOperationError("Scale3Image textures cannot be null."));
            };
            if (this._textures == _arg1)
            {
                return;
            };
            this._textures = _arg1;
            this._layoutChanged = true;
            this._propertiesChanged = true;
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

        public function readjustSize():void
        {
            var _local1:Rectangle = this._textures.texture.frame;
            this.width = (_local1.width * this._textureScale);
            this.height = (_local1.height * this._textureScale);
        }

        protected function validate():void
        {
            var _local1:Rectangle;
            var _local2:Number;
            var _local3:Number;
            var _local4:Number;
            var _local5:Number;
            var _local6:Number;
            if (((this._propertiesChanged) || (this._layoutChanged)))
            {
                this._batch.reset();
                if (!helperImage)
                {
                    helperImage = new starling.display.Image(this._textures.first);
                };
                helperImage.smoothing = this._smoothing;
                helperImage.color = this._color;
                _local1 = this._textures.texture.frame;
                if (this._textures.direction == Scale3Textures.DIRECTION_VERTICAL)
                {
                    _local2 = this._width;
                    _local3 = (_local2 / _local1.width);
                    _local4 = (this._textures.firstRegionSize * _local3);
                    _local5 = (((_local1.height - this._textures.firstRegionSize) - this._textures.secondRegionSize) * _local3);
                    _local6 = ((this._height - _local4) - _local5);
                    if (_local2 > 0)
                    {
                        helperImage.texture = this._textures.first;
                        helperImage.readjustSize();
                        helperImage.x = 0;
                        helperImage.y = 0;
                        helperImage.width = _local2;
                        helperImage.height = _local4;
                        if (_local4 > 0)
                        {
                            this._batch.addImage(helperImage);
                        };
                        helperImage.texture = this._textures.second;
                        helperImage.readjustSize();
                        helperImage.x = 0;
                        helperImage.y = _local4;
                        helperImage.width = _local2;
                        helperImage.height = _local6;
                        if (_local6 > 0)
                        {
                            this._batch.addImage(helperImage);
                        };
                        helperImage.texture = this._textures.third;
                        helperImage.readjustSize();
                        helperImage.x = 0;
                        helperImage.y = (this._height - _local5);
                        helperImage.width = _local2;
                        helperImage.height = _local5;
                        if (_local5 > 0)
                        {
                            this._batch.addImage(helperImage);
                        };
                    };
                }
                else
                {
                    _local2 = this._height;
                    _local3 = (_local2 / _local1.height);
                    _local4 = (this._textures.firstRegionSize * _local3);
                    _local5 = (((_local1.width - this._textures.firstRegionSize) - this._textures.secondRegionSize) * _local3);
                    _local6 = ((this._width - _local4) - _local5);
                    if (_local2 > 0)
                    {
                        helperImage.texture = this._textures.first;
                        helperImage.readjustSize();
                        helperImage.x = 0;
                        helperImage.y = 0;
                        helperImage.width = _local4;
                        helperImage.height = _local2;
                        if (_local4 > 0)
                        {
                            this._batch.addImage(helperImage);
                        };
                        helperImage.texture = this._textures.second;
                        helperImage.readjustSize();
                        helperImage.x = _local4;
                        helperImage.y = 0;
                        helperImage.width = _local6;
                        helperImage.height = _local2;
                        if (_local6 > 0)
                        {
                            this._batch.addImage(helperImage);
                        };
                        helperImage.texture = this._textures.third;
                        helperImage.readjustSize();
                        helperImage.x = (this._width - _local5);
                        helperImage.y = 0;
                        helperImage.width = _local5;
                        helperImage.height = _local2;
                        if (_local5 > 0)
                        {
                            this._batch.addImage(helperImage);
                        };
                    };
                };
            };
            this._propertiesChanged = false;
            this._layoutChanged = false;
        }

        private function flattenHandler(_arg1:Event):void
        {
            this.validate();
        }


    }
}//package org.josht.starling.display
