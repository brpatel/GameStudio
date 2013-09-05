//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.textures
{
    import starling.textures.Texture;
    import flash.geom.Rectangle;

    public class Scale9Textures 
    {

        private var _texture:Texture;
        private var _scale9Grid:Rectangle;
        private var _topLeft:Texture;
        private var _topCenter:Texture;
        private var _topRight:Texture;
        private var _middleLeft:Texture;
        private var _middleCenter:Texture;
        private var _middleRight:Texture;
        private var _bottomLeft:Texture;
        private var _bottomCenter:Texture;
        private var _bottomRight:Texture;

        public function Scale9Textures(_arg1:Texture, _arg2:Rectangle)
        {
            this._texture = _arg1;
            this._scale9Grid = _arg2;
            this.initialize();
        }

        public function get texture():Texture
        {
            return (this._texture);
        }

        public function get scale9Grid():Rectangle
        {
            return (this._scale9Grid);
        }

        public function get topLeft():Texture
        {
            return (this._topLeft);
        }

        public function get topCenter():Texture
        {
            return (this._topCenter);
        }

        public function get topRight():Texture
        {
            return (this._topRight);
        }

        public function get middleLeft():Texture
        {
            return (this._middleLeft);
        }

        public function get middleCenter():Texture
        {
            return (this._middleCenter);
        }

        public function get middleRight():Texture
        {
            return (this._middleRight);
        }

        public function get bottomLeft():Texture
        {
            return (this._bottomLeft);
        }

        public function get bottomCenter():Texture
        {
            return (this._bottomCenter);
        }

        public function get bottomRight():Texture
        {
            return (this._bottomRight);
        }

        private function initialize():void
        {
            var _local1:Rectangle;
            var _local2:Number;
            var _local4:Number;
            var _local5:Number;
            var _local7:Number;
            var _local8:Number;
            var _local9:Number;
            var _local10:Number;
            var _local11:Number;
            var _local12:Boolean;
            var _local13:Boolean;
            _local1 = this._texture.frame;
            _local2 = this._scale9Grid.x;
            var _local3:Number = this._scale9Grid.width;
            _local4 = ((_local1.width - this._scale9Grid.width) - this._scale9Grid.x);
            _local5 = this._scale9Grid.y;
            var _local6:Number = this._scale9Grid.height;
            _local7 = ((_local1.height - this._scale9Grid.height) - this._scale9Grid.y);
            _local8 = (_local2 + _local1.x);
            _local9 = (_local5 + _local1.y);
            _local10 = ((_local4 - (_local1.width - this._texture.width)) - _local1.x);
            _local11 = ((_local7 - (_local1.height - this._texture.height)) - _local1.y);
            _local12 = !((_local8 == _local2));
            _local13 = !((_local9 == _local5));
            var _local14 = !((_local10 == _local4));
            var _local15 = !((_local11 == _local7));
            var _local16:Rectangle = new Rectangle(0, 0, _local8, _local9);
            var _local17:Rectangle = ((((_local12) || (_local13))) ? new Rectangle(_local1.x, _local1.y, _local2, _local5) : null);
            this._topLeft = Texture.fromTexture(this._texture, _local16, _local17);
            var _local18:Rectangle = new Rectangle(_local8, 0, _local3, _local9);
            var _local19:Rectangle = ((_local13) ? new Rectangle(0, _local1.y, _local3, _local5) : null);
            this._topCenter = Texture.fromTexture(this._texture, _local18, _local19);
            var _local20:Rectangle = new Rectangle((_local8 + _local3), 0, _local10, _local9);
            var _local21:Rectangle = ((((_local13) || (_local14))) ? new Rectangle(0, _local1.y, _local4, _local5) : null);
            this._topRight = Texture.fromTexture(this._texture, _local20, _local21);
            var _local22:Rectangle = new Rectangle(0, _local9, _local8, _local6);
            var _local23:Rectangle = ((_local12) ? new Rectangle(_local1.x, 0, _local2, _local6) : null);
            this._middleLeft = Texture.fromTexture(this._texture, _local22, _local23);
            var _local24:Rectangle = new Rectangle(_local8, _local9, _local3, _local6);
            this._middleCenter = Texture.fromTexture(this._texture, _local24);
            var _local25:Rectangle = new Rectangle((_local8 + _local3), _local9, _local10, _local6);
            var _local26:Rectangle = ((_local14) ? new Rectangle(0, 0, _local4, _local6) : null);
            this._middleRight = Texture.fromTexture(this._texture, _local25, _local26);
            var _local27:Rectangle = new Rectangle(0, (_local9 + _local6), _local8, _local11);
            var _local28:Rectangle = ((((_local12) || (_local15))) ? new Rectangle(_local1.x, 0, _local2, _local7) : null);
            this._bottomLeft = Texture.fromTexture(this._texture, _local27, _local28);
            var _local29:Rectangle = new Rectangle(_local8, (_local9 + _local6), _local3, _local11);
            var _local30:Rectangle = ((_local15) ? new Rectangle(0, 0, _local3, _local7) : null);
            this._bottomCenter = Texture.fromTexture(this._texture, _local29, _local30);
            var _local31:Rectangle = new Rectangle((_local8 + _local3), (_local9 + _local6), _local10, _local11);
            var _local32:Rectangle = ((((_local15) || (_local14))) ? new Rectangle(0, 0, _local4, _local7) : null);
            this._bottomRight = Texture.fromTexture(this._texture, _local31, _local32);
        }


    }
}//package org.josht.starling.textures
