package com.adobe.gamebuilder.editor.view.parts
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.RoomMeasure;
    import com.adobe.gamebuilder.editor.view.Room;
    import com.adobe.gamebuilder.editor.view.layout.Direction;
    import com.adobe.gamebuilder.editor.view.layout.PointAlign;
    
    import org.osflash.signals.Signal;
    
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;

    public class RoomSide extends Sprite 
    {

        public static const SIDE_A:String = "A";
        public static const SIDE_B:String = "B";
        public static const SIDE_C:String = "C";
        public static const SIDE_D:String = "D";
        public static const SIDE_E:String = "E";
        public static const SIDE_F:String = "F";

        private var _id:String;
        private var _enabled:Boolean = true;
        private var _textField:Image;
        private var _change:Signal;
        private var _move:Signal;
        private var _onRemove:Signal;
        private var _enableSignal:Signal;
        private var _movedPoint:RoomPoint;
        public var direction:String;
        public var startPoint:RoomPoint;
        public var endPoint:RoomPoint;

        public function RoomSide()
        {
            this._change = new Signal();
            this._move = new Signal();
            this._enableSignal = new Signal();
            this._onRemove = new Signal();
            addEventListener(Event.ADDED_TO_STAGE, this.init);
            addEventListener(Event.REMOVED_FROM_STAGE, this.removeHandler);
        }

        public static function createInstance(_arg1:String, _arg2:RoomPoint, _arg3:RoomPoint):RoomSide
        {
            var _local4:RoomSide = new (RoomSide)();
            _local4._id = _arg1;
            _local4.startPoint = _arg2;
            _local4.endPoint = _arg3;
            _local4.direction = (((_arg2.y)==_arg3.y) ? Direction.HORIZONTAL : Direction.VERTICAL);
            _local4.addListeners();
            return (_local4);
        }


        public function get onRemove():Signal
        {
            return (this._onRemove);
        }

        public function get enableSignal():Signal
        {
            return (this._enableSignal);
        }

        public function get enabled():Boolean
        {
            return (this._enabled);
        }

        public function get movedPoint():RoomPoint
        {
            return (this._movedPoint);
        }

        public function set enabled(_arg1:Boolean):void
        {
            this._enabled = _arg1;
            if (this._textField)
            {
                this._textField.visible = (((Common.appStep)==Constants.STEP_ROOM) ? this._enabled : false);
            };
        }

        public function checkEnabling():void
        {
            this.enabled = ((!(this.startPoint.removeable)) && (!(this.startPoint.successor.removeable)));
            this._enableSignal.dispatch();
        }

        public function get move():Signal
        {
            return (this._move);
        }

        public function set id(_arg1:String):void
        {
            this._id = _arg1;
            if (((this._textField) && (!((this._id == "inter")))))
            {
                this._textField.texture = Assets.getTextureAtlas("Interface").getTexture(this._id);
            };
        }

        public function get change():Signal
        {
            return (this._change);
        }

        public function get id():String
        {
            return (this._id);
        }

        public function show():void
        {
            if (this._textField)
            {
                this._textField.visible = this._enabled;
            };
        }

        public function hide():void
        {
            if (this._textField)
            {
                this._textField.visible = false;
            };
        }

        public function switchEndPoints():void
        {
            var _local1:RoomPoint = this.startPoint;
            this.startPoint = this.endPoint;
            this.endPoint = _local1;
            this.positionTextField();
        }

        private function init(_arg1:Event):void
        {
            this.removeChildren();
            if (((!((this._id == SIDE_E))) && (!((this._id == SIDE_F)))))
            {
                this._textField = new Image(Assets.getTextureAtlas("Interface").getTexture(this._id));
                addChild(this._textField);
            };
            this.positionTextField();
        }

        public function update():void
        {
            this.positionTextField();
        }

        public function directionUpdate(_arg1:RoomPoint):void
        {
            if (_arg1 == this.startPoint)
            {
                if (this.direction == Direction.VERTICAL)
                {
                    this.endPoint.x = this.startPoint.x;
                }
                else
                {
                    this.endPoint.y = this.startPoint.y;
                };
                this.endPoint.updateLine();
                this.endPoint.predecessor.updateLine();
                this.endPoint.successor.updateLine();
            };
            if (_arg1 == this.endPoint)
            {
                if (this.direction == Direction.VERTICAL)
                {
                    this.startPoint.x = this.endPoint.x;
                }
                else
                {
                    this.startPoint.y = this.endPoint.y;
                };
                this.startPoint.updateLine();
                this.startPoint.predecessor.updateLine();
                this.startPoint.successor.updateLine();
            };
            this._change.dispatch();
        }

        private function positionTextField():void
        {
            switch (this._id)
            {
                case SIDE_A:
                    this._textField.x = ((((this.startPoint.x + this.endPoint.x) - this._textField.width) >> 1) << 0);
                    this._textField.y = ((((this.startPoint.y + this.endPoint.y) >> 1) + (((this.startPoint.x)<this.endPoint.x) ? 20 : (-20 - this._textField.height))) << 0);
                    return;
                case SIDE_B:
                    this._textField.x = ((((this.startPoint.x + this.endPoint.x) >> 1) + (((this.startPoint.y)>this.endPoint.y) ? 20 : (-20 - this._textField.width))) << 0);
                    this._textField.y = ((((this.startPoint.y + this.endPoint.y) - this._textField.height) >> 1) << 0);
                    return;
                case SIDE_C:
                    this._textField.x = ((((this.startPoint.x + this.endPoint.x) - this._textField.width) >> 1) << 0);
                    this._textField.y = ((((this.startPoint.y + this.endPoint.y) >> 1) + (((this.startPoint.x)<this.endPoint.x) ? 20 : (-20 - this._textField.height))) << 0);
                    return;
                case SIDE_D:
                    this._textField.x = ((((this.startPoint.x + this.endPoint.x) >> 1) + (((this.startPoint.y)>this.endPoint.y) ? 20 : (-20 - this._textField.width))) << 0);
                    this._textField.y = ((((this.startPoint.y + this.endPoint.y) - this._textField.height) >> 1) << 0);
                    return;
            };
        }

        public function addListeners():void
        {
            this.startPoint.move.add(this.pointMoveHandler);
            this.endPoint.move.add(this.pointMoveHandler);
        }

        private function pointMoveHandler(_arg1:RoomPoint):void
        {
            this.positionTextField();
            this._move.dispatch();
        }

        public function set measure(_arg1:Number):void
        {
            var _local2:String;
            var _local3:Number = RoomMeasure.cm2px(_arg1);
            switch (this._id)
            {
                case SIDE_A:
                    _local2 = ((((parent as Room).horizontalReflectionState)==1) ? "end" : "start");
                    if (_local2 == "end")
                    {
                        this.startPoint.x = ((this.endPoint.x + _local3) + (((this.startPoint.hAlign)==PointAlign.LEFT) ? 0 : RoomMeasure.WALL_SIZE));
                    }
                    else
                    {
                        this.endPoint.x = ((this.startPoint.x - _local3) - (((this.endPoint.hAlign)==PointAlign.LEFT) ? RoomMeasure.WALL_SIZE : 0));
                    };
                    break;
                case SIDE_B:
                    _local2 = ((((parent as Room).verticalReflectionState)==1) ? "end" : "start");
                    if (_local2 == "end")
                    {
                        this.startPoint.y = ((this.endPoint.y - _local3) - (((this.startPoint.vAlign)==PointAlign.TOP) ? RoomMeasure.WALL_SIZE : 0));
                    }
                    else
                    {
                        this.endPoint.y = ((this.startPoint.y + _local3) + (((this.endPoint.vAlign)==PointAlign.TOP) ? 0 : RoomMeasure.WALL_SIZE));
                    };
                    break;
                case SIDE_C:
                    _local2 = ((((parent as Room).horizontalReflectionState)==1) ? "start" : "end");
                    if (_local2 == "end")
                    {
                        this.startPoint.x = ((this.endPoint.x - _local3) - (((this.startPoint.hAlign)==PointAlign.LEFT) ? RoomMeasure.WALL_SIZE : 0));
                    }
                    else
                    {
                        this.endPoint.x = ((this.startPoint.x + _local3) + (((this.endPoint.hAlign)==PointAlign.LEFT) ? 0 : RoomMeasure.WALL_SIZE));
                    };
                    break;
                case SIDE_D:
                    _local2 = ((((parent as Room).verticalReflectionState)==1) ? "start" : "end");
                    if (_local2 == "end")
                    {
                        this.startPoint.y = ((this.endPoint.y + _local3) + (((this.startPoint.vAlign)==PointAlign.TOP) ? 0 : RoomMeasure.WALL_SIZE));
                    }
                    else
                    {
                        this.endPoint.y = ((this.startPoint.y - _local3) - (((this.endPoint.vAlign)==PointAlign.TOP) ? RoomMeasure.WALL_SIZE : 0));
                    };
                    break;
            };
            this._movedPoint = (((_local2)=="end") ? this.startPoint : this.endPoint);
            this.startPoint.updateLine();
            this.endPoint.updateLine();
            this._change.dispatch();
        }

        public function get measure():Number
        {
            if ((((this._id == SIDE_A)) || ((this._id == SIDE_C))))
            {
                return (RoomMeasure.px2cm(Math.abs(((((this.startPoint.hAlign)==PointAlign.RIGHT) ? this.startPoint.x : (this.startPoint.x + RoomMeasure.WALL_SIZE)) - (((this.endPoint.hAlign)==PointAlign.RIGHT) ? this.endPoint.x : (this.endPoint.x + RoomMeasure.WALL_SIZE))))));
            };
            return (RoomMeasure.px2cm(Math.abs(((((this.startPoint.vAlign)==PointAlign.BOTTOM) ? this.startPoint.y : (this.startPoint.y + RoomMeasure.WALL_SIZE)) - (((this.endPoint.vAlign)==PointAlign.BOTTOM) ? this.endPoint.y : (this.endPoint.y + RoomMeasure.WALL_SIZE))))));
        }

        private function removeHandler(_arg1:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.init);
            removeEventListener(Event.REMOVED_FROM_STAGE, this.removeHandler);
            this.dispose();
        }

        override public function dispose():void
        {
            super.dispose();
            if (this._change != null)
            {
                this._change.removeAll();
            };
            if (this._move != null)
            {
                this._move.removeAll();
            };
            if (this.startPoint != null)
            {
                this.startPoint.move.remove(this.pointMoveHandler);
                this.startPoint = null;
            };
            if (this.endPoint != null)
            {
                this.endPoint.move.remove(this.pointMoveHandler);
                this.endPoint = null;
            };
        }


    }
}//package at.polypex.badplaner.view.parts
