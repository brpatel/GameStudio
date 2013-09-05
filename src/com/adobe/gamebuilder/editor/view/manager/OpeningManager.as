package com.adobe.gamebuilder.editor.view.manager
{
    import com.adobe.gamebuilder.editor.core.RoomMeasure;
    import com.adobe.gamebuilder.editor.view.Container;
    import com.adobe.gamebuilder.editor.view.Room;
    import com.adobe.gamebuilder.editor.view.comps.Opening;
    import com.adobe.gamebuilder.editor.view.parts.RoomPoint;
    
    import flash.geom.Point;
    
    import __AS3__.vec.Vector;
    
    import starling.display.Quad;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    public class OpeningManager 
    {

        private var _room:Room;
        private var _selectedOpening:Opening;
        private var _store:Vector.<Opening>;
        private var _delta:Point;
        private var _moveTouches:Vector.<Touch>;

        public function OpeningManager(_arg1:Room)
        {
            this._room = _arg1;
            this.init();
        }

        private function init():void
        {
            this._store = new Vector.<Opening>();
            this._room.openingOutline.onDelete.add(this.deleteHandler);
            this._room.openingOutline.onResize.add(this.resizeHandler);
            this._room.openingOutline.onReflect.add(this.reflectHandler);
        }

        public function get selectedOpening():Opening
        {
            return (this._selectedOpening);
        }

        public function set selectedOpening(_arg1:Opening):void
        {
            this._selectedOpening = _arg1;
        }

        public function get length():int
        {
            return (this._store.length);
        }

        public function add(_arg1:Opening, _arg2:RoomPoint, _arg3:Boolean=true):void
        {
            this._store.push(_arg1);
            _arg2.roomLine.addChild(_arg1);
            this.addListeners(_arg1);
            if (_arg3)
            {
                this._room.drawSignal.dispatch();
            };
        }

        public function getItemAt(_arg1:int):Opening
        {
            return (this._store[_arg1]);
        }

        public function getOpeningsByPoint(_arg1:RoomPoint):Vector.<Opening>
        {
            var _local2:Vector.<Opening> = new Vector.<Opening>();
            var _local3:int;
            while (_local3 < this._store.length)
            {
                if (this._store[_local3].point === _arg1)
                {
                    _local2.push(this._store[_local3]);
                };
                _local3++;
            };
            return (_local2);
        }

        public function removeAll():void
        {
            var _local1:int;
            if (this.length > 0)
            {
                _local1 = 0;
                while (_local1 < this._store.length)
                {
                    this.deleteOpening(this._store[_local1]);
                    _local1++;
                };
                this._store = new Vector.<Opening>();
            };
        }

        private function deleteHandler():void
        {
            if (this._selectedOpening)
            {
                this.remove(this._selectedOpening);
                this._selectedOpening = null;
                this._room.outlineManager.hideAll();
                this._room.drawSignal.dispatch();
            };
        }

        private function resizeHandler(_arg1:Number, _arg2:Number):void
        {
            if (this._selectedOpening)
            {
                this.resizeOpening(this._selectedOpening, _arg1, _arg2);
            };
        }

        private function reflectHandler(_arg1:String):void
        {
            if (this._selectedOpening)
            {
                this._selectedOpening.reflect(_arg1);
                this._room.outlineManager.outlineOpening(this._selectedOpening, false);
                this._room.drawSignal.dispatch();
            };
        }

        private function resizeOpening(_arg1:Opening, _arg2:Number, _arg3:Number):void
        {
            _arg2 = Math.max(RoomMeasure.cm2px(Opening.MIN_SIZE), Math.min(RoomMeasure.cm2px(Opening.MAX_SIZE), _arg2));
            _arg1.setSize(_arg2, _arg3);
            this._room.outlineManager.outlineOpening(_arg1, false);
            this._room.drawSignal.dispatch();
        }

        private function deleteOpening(_arg1:Opening):void
        {
            this.removeListeners(_arg1);
            _arg1.point.roomLine.removeChild(_arg1);
        }

        private function remove(_arg1:Opening):void
        {
            this.removeListeners(_arg1);
            _arg1.point.roomLine.removeChild(_arg1);
            var _local2:int;
            while (_local2 < this._store.length)
            {
                if (_arg1 === this._store[_local2])
                {
                    this._store.splice(_local2, 1);
                    return;
                };
                _local2++;
            };
        }

        public function addListeners(_arg1:Opening):void
        {
            _arg1.addEventListener(TouchEvent.TOUCH, this.openingTouchHandler);
        }

        public function removeListeners(_arg1:Opening):void
        {
            _arg1.addEventListener(TouchEvent.TOUCH, this.openingTouchHandler);
        }

        private function openingTouchHandler(_arg1:TouchEvent):void
        {
            var _local2:Touch = _arg1.getTouch(this._room.stage);
            if (_local2 != null)
            {
                if (_local2.phase == TouchPhase.BEGAN)
                {
                    this._selectedOpening = (_arg1.currentTarget as Opening);
                    this._room.outlineManager.outlineOpening(this._selectedOpening, true);
                    if ((_arg1.currentTarget as Opening).x < RoomMeasure.WALL_SIZE_HALF)
                    {
                        (_arg1.currentTarget as Opening).x = RoomMeasure.WALL_SIZE_HALF;
                    };
                };
            };
            if (((!((this._selectedOpening == null))) && (!((this._room.parent as Container).moving))))
            {
                this._moveTouches = _arg1.getTouches(this._selectedOpening, TouchPhase.MOVED);
                if (this._moveTouches.length >= 1)
                {
                    this._delta = this._moveTouches[0].getMovement(this._selectedOpening);
                    if ((((((_arg1.currentTarget as Opening).x + this._delta.x) >= RoomMeasure.WALL_SIZE_HALF)) && ((((_arg1.currentTarget as Opening).x + this._delta.x) <= (((this._selectedOpening.point.roomLine.sensor as Quad).width - (_arg1.currentTarget as Opening).width) - RoomMeasure.WALL_SIZE_HALF)))))
                    {
                        (_arg1.currentTarget as Opening).x = ((_arg1.currentTarget as Opening).x + this._delta.x);
                        this._room.outlineManager.outlineOpening(this._selectedOpening);
                        this._room.drawSignal.dispatch();
                    };
                };
            };
        }


    }
}//package at.polypex.badplaner.view.manager
