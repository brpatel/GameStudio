package com.adobe.gamebuilder.editor.view.comps
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import __AS3__.vec.Vector;
    
    import org.osflash.signals.Signal;
    
    import starling.display.Image;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;

    public class MoveableImage extends Image 
    {

        private var _onTouchEnd:Signal;
        private var _onMove:Signal;
        private var _onTouchBegin:Signal;
        private var _delta:Point;
        private var _virtualPos:Point;
        private var _moveRect:Rectangle;
        private var _iconTexture:Texture;

        public function MoveableImage(_arg1:String, _arg2:Rectangle)
        {
            this._delta = new Point();
            this._virtualPos = new Point();
            super(Assets.getTextureAtlas("Interface").getTexture(_arg1));
            this._moveRect = _arg2;
            this._onTouchEnd = new Signal(MoveableImage, Number, Number);
            this._onMove = new Signal(MoveableImage, Number, Number);
            this._onTouchBegin = new Signal(MoveableImage, Number, Number);
            addEventListener(TouchEvent.TOUCH, this.onTouch);
        }

        public function get onTouchBegin():Signal
        {
            return (this._onTouchBegin);
        }

        public function get onMove():Signal
        {
            return (this._onMove);
        }

        public function get onTouchEnd():Signal
        {
            return (this._onTouchEnd);
        }

        private function onTouch(_arg1:TouchEvent):void
        {
            var _local2:Touch = _arg1.getTouch(stage);
            if (_local2 != null)
            {
                if (_local2.phase == TouchPhase.BEGAN)
                {
                    this._virtualPos.x = x;
                    this._virtualPos.y = y;
                    this._onTouchBegin.dispatch(this, x, y);
                }
                else
                {
                    if (_local2.phase == TouchPhase.ENDED)
                    {
                        this._onTouchEnd.dispatch(this, x, y);
                    };
                };
            };
            var _local3:Vector.<Touch> = _arg1.getTouches(this, TouchPhase.MOVED);
            if (_local3.length >= 1)
            {
                this._delta = _local3[0].getMovement(parent);
                this._virtualPos.x = (this._virtualPos.x + this._delta.x);
                this._virtualPos.y = (this._virtualPos.y + this._delta.y);
                if (this._moveRect.width > 0)
                {
                    x = Math.max(this._moveRect.x, this._virtualPos.x);
                };
                if (this._moveRect.height > 0)
                {
                    y = Math.max(this._moveRect.y, this._virtualPos.y);
                };
                this._onMove.dispatch(this, x, y);
            };
        }


    }
}//package at.polypex.badplaner.view.comps
