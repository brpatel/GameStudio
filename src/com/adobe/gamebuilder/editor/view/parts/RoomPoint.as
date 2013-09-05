package com.adobe.gamebuilder.editor.view.parts
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.core.RoomMeasure;
    import com.adobe.gamebuilder.editor.model.data.BasePoint;
    import com.adobe.gamebuilder.editor.view.Container;
    import com.adobe.gamebuilder.editor.view.Room;
    import com.adobe.gamebuilder.editor.view.layout.PointAlign;
    import com.adobe.gamebuilder.editor.view.layout.ReflectionAxis;
    
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.system.System;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    
    import __AS3__.vec.Vector;
    
    import org.osflash.signals.Signal;
    
    import starling.animation.Transitions;
    import starling.animation.Tween;
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.TextureSmoothing;

    public class RoomPoint extends Sprite 
    {

        public static const VISUAL_RADIUS:uint = 11;
        public static const SENSOR_RADIUS:uint = 20;

        public var predecessor:RoomPoint;
        public var successor:RoomPoint;
        private var _move:Signal;
        private var _select:Signal;
        private var _addPoint:Signal;
        private var _showMenu:Signal;
        private var _removeable:Boolean;
        private var _enabled:Boolean = true;
        private var _bg:Image;
        private var _visual:Image;
        private var _roomLine:RoomLine;
        private var _hAlign:String;
        private var _vAlign:String;
        private var _delta:Point;
        private var _touch:Touch;
        private var _moveTouches:Vector.<Touch>;
        private var _touchStart:Number;
        private var _longPressTimer:Timer;
        private var _x:Number;
        private var _y:Number;
        private var _startPos:Point;
        private var _longPressDispatched:Boolean = false;
        private var _sensor:Image;
        private var _touchVisual:Image;

        public function RoomPoint(_arg1:Boolean=true)
        {
            this._removeable = _arg1;
            this.init();
        }

        public static function fromBasePoint(_arg1:BasePoint):RoomPoint
        {
            var _local2:RoomPoint = new RoomPoint(false);
            _local2._hAlign = _arg1.hAlign;
            _local2._vAlign = _arg1.vAlign;
            _local2.x = (_arg1.x - (((_arg1.hAlign)==PointAlign.LEFT) ? RoomMeasure.WALL_SIZE_HALF : -(RoomMeasure.WALL_SIZE_HALF)));
            _local2.y = (_arg1.y - (((_arg1.vAlign)==PointAlign.TOP) ? RoomMeasure.WALL_SIZE_HALF : -(RoomMeasure.WALL_SIZE_HALF)));
            return (_local2);
        }


        public function get select():Signal
        {
            return (this._select);
        }

        public function get room():Room
        {
            return ((parent as Room));
        }

        public function get addPoint():Signal
        {
            return (this._addPoint);
        }

        public function get move():Signal
        {
            return (this._move);
        }

        public function get showMenu():Signal
        {
            return (this._showMenu);
        }

        public function get roomLine():RoomLine
        {
            return (this._roomLine);
        }

        public function set removeable(_arg1:Boolean):void
        {
            this._removeable = _arg1;
        }

        public function get vAlign():String
        {
            return (this._vAlign);
        }

        public function set vAlign(_arg1:String):void
        {
            this._vAlign = _arg1;
        }

        public function get hAlign():String
        {
            return (this._hAlign);
        }

        public function set hAlign(_arg1:String):void
        {
            this._hAlign = _arg1;
        }

        public function get mx():Number
        {
            return ((((this._hAlign)==PointAlign.LEFT) ? (x + RoomMeasure.WALL_SIZE_HALF) : (x - RoomMeasure.WALL_SIZE_HALF)));
        }

        public function get my():Number
        {
            return ((((this._vAlign)==PointAlign.TOP) ? (y + RoomMeasure.WALL_SIZE_HALF) : (y - RoomMeasure.WALL_SIZE_HALF)));
        }

        private function init():void
        {
            this._move = new Signal(RoomPoint);
            this._select = new Signal(RoomPoint);
            this._addPoint = new Signal(RoomPoint, Point);
            this._showMenu = new Signal(RoomPoint, Boolean);
            this.addEventListener(TouchEvent.TOUCH, this.pointTouchHandler);
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.pointRemoveHandler);
            this._roomLine = new RoomLine();
            this._roomLine.touchable = true;
            this._roomLine.addEventListener(TouchEvent.TOUCH, this.roomLineTouchHandler);
            addChild(this._roomLine);
            this._sensor = new Image(Assets.getTextureAtlas("Interface").getTexture("room_point_icon"));
            this._sensor.scaleX = (this._sensor.scaleY = ((SENSOR_RADIUS * 2) / this._sensor.width));
            this._sensor.alpha = 0;
            this._sensor.x = (-(this._sensor.width) >> 1);
            this._sensor.y = (-(this._sensor.height) >> 1);
            addChild(this._sensor);
            this._bg = new Image(Assets.getTextureAtlas("Interface").getTexture("room_point_bg"));
            this._bg.smoothing = TextureSmoothing.NONE;
            this._bg.width = RoomMeasure.WALL_SIZE;
            this._bg.height = RoomMeasure.WALL_SIZE;
            this._bg.x = (-(this._bg.width) >> 1);
            this._bg.y = (-(this._bg.height) >> 1);
            addChild(this._bg);
            this._visual = new Image(Assets.getTextureAtlas("Interface").getTexture("room_point_icon"));
            this._visual.x = (-(this._visual.width) >> 1);
            this._visual.y = (-(this._visual.height) >> 1);
            addChild(this._visual);
            this._touchVisual = new Image(Assets.getTextureAtlas("Interface").getTexture("room_point_handle"));
            this._touchVisual.x = (-(this._touchVisual.width) >> 1);
            this._touchVisual.y = (-(this._touchVisual.height) >> 1);
            this._touchVisual.visible = false;
            addChild(this._touchVisual);
        }

        private function roomLineTouchHandler(_arg1:TouchEvent):void
        {
            var _local3:DisplayObject;
            var _local4:Point;
            var _local2:Touch = _arg1.touches[0];
            if (((((!((_local2 == null))) && ((_local2.tapCount == 2)))) && ((_local2.phase == TouchPhase.ENDED))))
            {
                _local3 = (_arg1.currentTarget as RoomLine).hitTest(_local2.getLocation((_arg1.currentTarget as RoomLine)), true);
                if (((((!((_local3 == null))) && ((_local3.name == "dragSensor")))) && (this._enabled)))
                {
                    _local4 = _local2.getLocation((_arg1.currentTarget as RoomLine));
                    _local4.y = 0;
                    this._addPoint.dispatch(this, parent.globalToLocal((_arg1.currentTarget as RoomLine).localToGlobal(_local4)));
                };
            };
            _arg1.stopImmediatePropagation();
        }

        public function switchAlignment(_arg1:String):void
        {
            if (_arg1 == ReflectionAxis.HORIZONTAL)
            {
                this._hAlign = (((this._hAlign)==PointAlign.LEFT) ? PointAlign.RIGHT : PointAlign.LEFT);
            }
            else
            {
                this._vAlign = (((this._vAlign)==PointAlign.BOTTOM) ? PointAlign.TOP : PointAlign.BOTTOM);
            };
        }

        public function switchNeighbourPoints():void
        {
            var _local1:RoomPoint = this.successor;
            this.successor = this.predecessor;
            this.predecessor = _local1;
            this.updateLine();
        }

        public function get enabled():Boolean
        {
            return (this._enabled);
        }

        public function get removeable():Boolean
        {
            return (this._removeable);
        }

        public function enable():void
        {
            this._enabled = true;
            this._visual.visible = true;
            this.addEventListener(TouchEvent.TOUCH, this.pointTouchHandler);
        }

        public function disable():void
        {
            this._enabled = false;
            this._visual.visible = false;
            this.removeEventListener(TouchEvent.TOUCH, this.pointTouchHandler);
        }

        public function get globalX():Number
        {
            return ((this.x + (this.parent as Room).x));
        }

        public function get globalY():Number
        {
            return ((this.y + (this.parent as Room).y));
        }

        private function pointTouchHandler(_arg1:TouchEvent):void
        {
            var _local2:Tween;
            this._touch = _arg1.getTouch(this);
            if (((!((this._touch == null))) && ((this._touch.phase == TouchPhase.BEGAN))))
            {
                this._select.dispatch(this);
                this._x = this.x;
                this._y = this.y;
                this._startPos = new Point(this.x, this.y);
                this._longPressDispatched = false;
                this._longPressTimer = new Timer(100);
                this._longPressTimer.addEventListener(TimerEvent.TIMER, this.checkLongPress, false, 0, true);
                this._longPressTimer.start();
                this._touchStart = getTimer();
                this._touchVisual.alpha = 0;
                this._touchVisual.visible = true;
                _local2 = new Tween(this._touchVisual, 0.3, Transitions.EASE_OUT);
                _local2.animate("alpha", 1);
                Starling.juggler.add(_local2);
            };
            if (((!((this._touch == null))) && ((this._touch.phase == TouchPhase.ENDED))))
            {
                if (this._longPressTimer != null)
                {
                    this._longPressTimer.stop();
                    this._longPressTimer = null;
                };
                this._touchVisual.visible = false;
                if (this._longPressDispatched)
                {
                    _arg1.stopImmediatePropagation();
                };
                System.pauseForGCIfCollectionImminent();
            };
            if (!(this.room.parent as Container).moving)
            {
                this._moveTouches = _arg1.getTouches(this, TouchPhase.MOVED);
                if (this._moveTouches.length == 1)
                {
                    if (Math.sqrt((Math.pow((this.x - this._startPos.x), 2) + Math.pow((this.y - this._startPos.y), 2))) > 3)
                    {
                        this._showMenu.dispatch(this, false);
                        this._touchStart = getTimer();
                    };
                    this._delta = this._moveTouches[0].getMovement(parent);
                    this._x = (this._x + this._delta.x);
                    this._y = (this._y + this._delta.y);
                    (_arg1.currentTarget as RoomPoint).x = RoomMeasure.pointPos(this._x, "x", this.hAlign, this.vAlign);
                    (_arg1.currentTarget as RoomPoint).y = RoomMeasure.pointPos(this._y, "y", this.hAlign, this.vAlign);
                    this.updateLine();
                    this.predecessor.updateLine();
                    this._move.dispatch(this);
                };
            };
        }

        protected function checkLongPress(_arg1:TimerEvent):void
        {
            if ((getTimer() - this._touchStart) > 1200)
            {
                this._longPressTimer.stop();
                this._longPressTimer = null;
                this._longPressDispatched = true;
                this._showMenu.dispatch(this, true);
            };
        }

        public function updateLine():void
        {
            this._roomLine.update();
        }

        private function pointRemoveHandler():void
        {
            this.dispose();
        }

        override public function dispose():void
        {
            super.dispose();
            if (this.predecessor != null)
            {
                this.predecessor = null;
            };
            if (this.successor != null)
            {
                this.successor = null;
            };
            this.removeEventListener(TouchEvent.TOUCH, this.pointTouchHandler);
            this.removeEventListener(Event.REMOVED_FROM_STAGE, this.pointRemoveHandler);
            if (this._roomLine != null)
            {
                this._roomLine.removeEventListener(TouchEvent.TOUCH, this.roomLineTouchHandler);
            };
        }

        public function toString():String
        {
            return ((((("[RoomPoint (x:" + this.x) + ", y:") + this.y) + ")]"));
        }


    }
}//package at.polypex.badplaner.view.parts
