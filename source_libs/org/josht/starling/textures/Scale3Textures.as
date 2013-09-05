//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.textures
{
    import starling.textures.Texture;
    import flash.geom.Rectangle;

    public class Scale3Textures 
    {

        public static const DIRECTION_HORIZONTAL:String = "horizontal";
        public static const DIRECTION_VERTICAL:String = "vertical";

        private var _texture:Texture;
        private var _firstRegionSize:Number;
        private var _secondRegionSize:Number;
        private var _direction:String;
        private var _first:Texture;
        private var _second:Texture;
        private var _third:Texture;

        public function Scale3Textures(_arg1:Texture, _arg2:Number, _arg3:Number, _arg4:String="horizontal")
        {
            this._texture = _arg1;
            this._firstRegionSize = _arg2;
            this._secondRegionSize = _arg3;
            this._direction = _arg4;
            this.initialize();
        }

        public function get texture():Texture
        {
            return (this._texture);
        }

        public function get firstRegionSize():Number
        {
            return (this._firstRegionSize);
        }

        public function get secondRegionSize():Number
        {
            return (this._secondRegionSize);
        }

        public function get direction():String
        {
            return (this._direction);
        }

        public function get first():Texture
        {
            return (this._first);
        }

        public function get second():Texture
        {
            return (this._second);
        }

        public function get third():Texture
        {
            return (this._third);
        }

        private function initialize():void
        {
            var _local2:Number;
            var _local3:Number;
            var _local4:Number;
            var _local5:Boolean;
            var _local6:Boolean;
            var _local7:Boolean;
            var _local8:Boolean;
            var _local9:Rectangle;
            var _local10:Rectangle;
            var _local11:Rectangle;
            var _local12:Rectangle;
            var _local13:Rectangle;
            var _local14:Rectangle;
            var _local15:Number;
            var _local16:Number;
            var _local1:Rectangle = this.texture.frame;
            if (this._direction == DIRECTION_VERTICAL)
            {
                _local2 = ((_local1.height - this._firstRegionSize) - this._secondRegionSize);
            }
            else
            {
                _local2 = ((_local1.width - this._firstRegionSize) - this._secondRegionSize);
            };
            if (this._direction == DIRECTION_VERTICAL)
            {
                _local3 = (this._firstRegionSize + _local1.y);
                _local4 = ((_local2 - (_local1.height - this.texture.height)) - _local1.y);
                _local5 = !((_local3 == this._firstRegionSize));
                _local6 = !(((_local1.width - _local1.x) == this.texture.width));
                _local7 = !((_local4 == _local2));
                _local8 = !((_local1.x == 0));
                _local9 = new Rectangle(0, 0, this.texture.width, _local3);
                _local10 = ((((((_local8) || (_local6))) || (_local5))) ? new Rectangle(_local1.x, _local1.y, _local1.width, this._firstRegionSize) : null);
                this._first = Texture.fromTexture(this.texture, _local9, _local10);
                _local11 = new Rectangle(0, _local3, this.texture.width, this._secondRegionSize);
                _local12 = ((((_local8) || (_local6))) ? new Rectangle(_local1.x, 0, _local1.width, this._secondRegionSize) : null);
                this._second = Texture.fromTexture(this.texture, _local11, _local12);
                _local13 = new Rectangle(0, (_local3 + this._secondRegionSize), this.texture.width, _local4);
                _local14 = ((((((_local8) || (_local6))) || (_local7))) ? new Rectangle(_local1.x, 0, _local1.width, _local2) : null);
                this._third = Texture.fromTexture(this.texture, _local13, _local14);
            }
            else
            {
                _local15 = (this._firstRegionSize + _local1.x);
                _local16 = ((_local2 - (_local1.width - this.texture.width)) - _local1.x);
                _local5 = !((_local1.y == 0));
                _local6 = !((_local16 == _local2));
                _local7 = !(((_local1.height - _local1.y) == this.texture.height));
                _local8 = !((_local15 == this._firstRegionSize));
                _local9 = new Rectangle(0, 0, _local15, this.texture.height);
                _local10 = ((((((_local8) || (_local5))) || (_local7))) ? new Rectangle(_local1.x, _local1.y, this._firstRegionSize, _local1.height) : null);
                this._first = Texture.fromTexture(this.texture, _local9, _local10);
                _local11 = new Rectangle(_local15, 0, this._secondRegionSize, this.texture.height);
                _local12 = ((((_local5) || (_local7))) ? new Rectangle(0, _local1.y, this._secondRegionSize, _local1.height) : null);
                this._second = Texture.fromTexture(this.texture, _local11, _local12);
                _local13 = new Rectangle((_local15 + this._secondRegionSize), 0, _local16, this.texture.height);
                _local14 = ((((((_local5) || (_local7))) || (_local6))) ? new Rectangle(0, _local1.y, _local2, _local1.height) : null);
                this._third = Texture.fromTexture(this.texture, _local13, _local14);
            };
        }


    }
}//package org.josht.starling.textures
