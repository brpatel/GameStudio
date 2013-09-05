package com.adobe.gamebuilder.editor.view.parts
{
    import com.adobe.gamebuilder.editor.view.comps.MoveableImage;
    import com.adobe.gamebuilder.editor.view.comps.OutlineCorner;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
    
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import org.osflash.signals.Signal;
    
    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.events.Event;

    public class ProductOutline extends Sprite 
    {

        private var _topLeft:OutlineCorner;
        private var _topRight:OutlineCorner;
        private var _bottomLeft:OutlineCorner;
        private var _bottomRight:OutlineCorner;
        private var _btnDelete:ImageButton;
        private var _btnResize:MoveableImage;
        private var _onDelete:Signal;
        private var _onResize:Signal;
        private var _scaleable:Boolean;

        public function ProductOutline()
        {
            this._onDelete = new Signal();
            this._onResize = new Signal(Number, Number);
            this.visible = false;
            this.addEventListener(Event.ADDED_TO_STAGE, this.init);
        }

        public function get onResize():Signal
        {
            return (this._onResize);
        }

        public function get onDelete():Signal
        {
            return (this._onDelete);
        }

        public function get scaleable():Boolean
        {
            return (this._scaleable);
        }

        public function set scaleable(_arg1:Boolean):void
        {
            this._scaleable = _arg1;
            if (this._btnResize)
            {
                this._btnResize.visible = _arg1;
            };
        }

        public function setBounds(_arg1:Number, _arg2:Number, _arg3:Boolean=true):void
        {
            this._topLeft.x = 0;
            this._topLeft.y = 0;
            this._topRight.x = _arg1;
            this._topRight.y = 0;
            this._bottomLeft.x = 0;
            this._bottomLeft.y = _arg2;
            this._bottomRight.x = _arg1;
            this._bottomRight.y = _arg2;
            this._btnDelete.x = ((this._topLeft.x - 3) - this._btnDelete.width);
            this._btnDelete.y = ((this._topLeft.y - 3) - this._btnDelete.height);
            if (_arg3)
            {
                this._btnResize.x = this._bottomRight.x;
                this._btnResize.y = this._bottomRight.y;
            };
        }

        private function init(_arg1:Event):void
        {
            this._topLeft = new OutlineCorner("TL");
            addChild(this._topLeft);
            this._topRight = new OutlineCorner("TR");
            addChild(this._topRight);
            this._bottomLeft = new OutlineCorner("BL");
            addChild(this._bottomLeft);
            this._bottomRight = new OutlineCorner("BR");
            addChild(this._bottomRight);
            this._btnDelete = new ImageButton("icon_delete");
            this._btnDelete.onRelease.add(this.btnDeleteOnRelease);
            addChild(this._btnDelete);
            this._btnResize = new MoveableImage("icon_resize", new Rectangle(10, 10, Infinity, Infinity));
            this._btnResize.onMove.add(this.btnResizeOnMove);
            addChild(this._btnResize);
        }

        public function getGlobalBtnPosition():Point
        {
            return (localToGlobal(new Point(((this._topRight.x + 3) + (this._btnDelete.width / 2)), ((this._topRight.y - 3) - (this._btnDelete.height / 2)))));
        }

        private function btnResizeOnMove(_arg1:DisplayObject, _arg2:Number, _arg3:Number):void
        {
            this.setBounds(_arg2, _arg3, false);
            this._onResize.dispatch(_arg2, _arg3);
        }

        private function btnDeleteOnRelease(_arg1:DisplayObject):void
        {
            this._onDelete.dispatch();
        }


    }
}//package at.polypex.badplaner.view.parts
