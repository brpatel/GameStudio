package com.adobe.gamebuilder.editor.view.parts
{
    import com.adobe.gamebuilder.editor.core.RoomMeasure;
    import com.adobe.gamebuilder.editor.view.Room;
    import com.adobe.gamebuilder.editor.view.comps.MoveableImage;
    import com.adobe.gamebuilder.editor.view.comps.Opening;
    import com.adobe.gamebuilder.editor.view.comps.OutlineCorner;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
    import com.adobe.gamebuilder.editor.view.layout.ReflectionAxis;
    
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import org.osflash.signals.Signal;
    
    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.events.Event;

    public class OpeningOutline extends Sprite 
    {

        private const BUTTON_PADDING:uint = 8;

        private var _topLeft:OutlineCorner;
        private var _topRight:OutlineCorner;
        private var _bottomLeft:OutlineCorner;
        private var _bottomRight:OutlineCorner;
        private var _btnDelete:ImageButton;
        private var _btnResize:MoveableImage;
        private var _btnReflectVer:ImageButton;
        private var _btnReflectHor:ImageButton;
        private var _onDelete:Signal;
        private var _onResize:Signal;
        private var _onReflect:Signal;

        public function OpeningOutline()
        {
            this._onDelete = new Signal();
            this._onResize = new Signal(Number, Number);
            this._onReflect = new Signal(String);
            this.visible = false;
            this.addEventListener(Event.ADDED_TO_STAGE, this.init);
        }

        public function get onReflect():Signal
        {
            return (this._onReflect);
        }

        public function get onResize():Signal
        {
            return (this._onResize);
        }

        public function get onDelete():Signal
        {
            return (this._onDelete);
        }

        public function outline(_arg1:Opening):void
        {
            var _local2:Point = (parent as Room).globalToLocal(_arg1.localToGlobal(new Point(0, 0)));
            var _local3:Rectangle = _arg1.getBounds(_arg1);
            this._topLeft.x = 0;
            this._topLeft.y = _local3.y;
            this._topRight.x = _local3.width;
            this._topRight.y = _local3.y;
            this._bottomLeft.x = 0;
            this._bottomLeft.y = (_local3.y + _local3.height);
            this._bottomRight.x = _local3.width;
            this._bottomRight.y = (_local3.y + _local3.height);
            this._btnDelete.x = ((this._topLeft.x - this.BUTTON_PADDING) - this._btnDelete.width);
            this._btnDelete.y = ((this._topLeft.y - this.BUTTON_PADDING) - this._btnDelete.height);
            this._btnResize.x = (this._bottomRight.x + this.BUTTON_PADDING);
            this._btnResize.y = ((RoomMeasure.WALL_SIZE - this._btnResize.height) >> 1);
            if ((_arg1 is Door))
            {
                this._btnReflectVer.visible = true;
                this._btnReflectVer.x = (this._bottomRight.x + this.BUTTON_PADDING);
                this._btnReflectVer.y = (((this._topRight.y + this._bottomRight.y) - this._btnReflectHor.height) >> 1);
                this._btnReflectHor.visible = true;
                this._btnReflectHor.x = (((this._topLeft.x + this._topRight.x) - this._btnReflectHor.width) >> 1);
                this._btnReflectHor.y = ((this._topLeft.y - this.BUTTON_PADDING) - this._btnReflectHor.height);
            }
            else
            {
                this._btnReflectVer.visible = false;
                this._btnReflectHor.visible = false;
            };
            this.x = _local2.x;
            this.y = _local2.y;
            this.rotation = _arg1.point.roomLine.rotation;
        }

        private function init(_arg1:Event):void
        {
            this._topLeft = new OutlineCorner("TL", 14, RoomMeasure.WALL_SIZE);
            addChild(this._topLeft);
            this._topRight = new OutlineCorner("TR", 14, RoomMeasure.WALL_SIZE);
            addChild(this._topRight);
            this._bottomLeft = new OutlineCorner("BL", 14, RoomMeasure.WALL_SIZE);
            addChild(this._bottomLeft);
            this._bottomRight = new OutlineCorner("BR", 14, RoomMeasure.WALL_SIZE);
            addChild(this._bottomRight);
            this._btnDelete = new ImageButton("icon_delete");
            this._btnDelete.onRelease.add(this.btnDeleteOnRelease);
            addChild(this._btnDelete);
            this._btnResize = new MoveableImage("icon_resize_openings", new Rectangle(RoomMeasure.cm2px(Opening.MIN_SIZE), RoomMeasure.cm2px(Opening.MIN_SIZE), Infinity, Infinity));
            this._btnResize.onMove.add(this.btnResizeOnMove);
            addChild(this._btnResize);
            this._btnReflectVer = new ImageButton("icon_reflect_ver");
            this._btnReflectVer.onRelease.add(this.btnReflectVerOnRelease);
            this._btnReflectVer.visible = false;
            addChild(this._btnReflectVer);
            this._btnReflectHor = new ImageButton("icon_reflect_hor");
            this._btnReflectHor.onRelease.add(this.btnReflectHorRelease);
            this._btnReflectHor.visible = false;
            addChild(this._btnReflectHor);
        }

        private function btnReflectHorRelease(_arg1:DisplayObject):void
        {
            this._onReflect.dispatch(ReflectionAxis.HORIZONTAL);
        }

        private function btnReflectVerOnRelease(_arg1:DisplayObject):void
        {
            this._onReflect.dispatch(ReflectionAxis.VERTICAL);
        }

        private function btnResizeOnMove(_arg1:DisplayObject, _arg2:Number, _arg3:Number):void
        {
            this._onResize.dispatch((_arg2 - this.BUTTON_PADDING), _arg3);
        }

        private function btnDeleteOnRelease(_arg1:DisplayObject):void
        {
            this._onDelete.dispatch();
        }


    }
}//package at.polypex.badplaner.view.parts
