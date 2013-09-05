package com.adobe.gamebuilder.editor.view.manager
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.RoomMeasure;
    import com.adobe.gamebuilder.editor.core.data.SystemMessage;
    import com.adobe.gamebuilder.editor.model.data.Extrema;
    import com.adobe.gamebuilder.editor.view.Room;
    import com.adobe.gamebuilder.editor.view.layout.OverlayConfig;
    import com.adobe.gamebuilder.editor.view.layout.ReflectionAxis;
    import com.adobe.gamebuilder.editor.view.overlays.RoomPointMenu;
    import com.adobe.gamebuilder.editor.view.parts.RoomPoint;
    
    import flash.geom.Point;
    
    import __AS3__.vec.Vector;

    public class PointManager 
    {

        private var _room:Room;
        private var _store:Vector.<RoomPoint>;
        private var _length:int = 0;
        private var _roomPointMenu:RoomPointMenu;
        private var _topPoints:Vector.<RoomPoint>;
        private var _leftPoints:Vector.<RoomPoint>;
        private var _botPoints:Vector.<RoomPoint>;
        private var _rightPoints:Vector.<RoomPoint>;

        public function PointManager(_arg1:Room)
        {
            this._room = _arg1;
            this._store = new Vector.<RoomPoint>();
        }

        public function get rightPoints():Vector.<RoomPoint>
        {
            return (this._rightPoints);
        }

        public function get botPoints():Vector.<RoomPoint>
        {
            return (this._botPoints);
        }

        public function get leftPoints():Vector.<RoomPoint>
        {
            return (this._leftPoints);
        }

        public function get topPoints():Vector.<RoomPoint>
        {
            return (this._topPoints);
        }

        public function get length():int
        {
            return (this._length);
        }

        public function indexOf(_arg1, _arg2=0):int
        {
            return (this._store.indexOf(_arg1, _arg2));
        }

        public function getItemAt(_arg1:int):RoomPoint
        {
            return (this._store[_arg1]);
        }

        public function add(_arg1:RoomPoint):void
        {
            this._store.push(_arg1);
            this._room.addChild(_arg1);
            this.addListeners(_arg1);
            this._length = this._store.length;
            this._room.productManager.bringToFront();
        }

        public function addItemAt(_arg1:int, _arg2:RoomPoint):void
        {
            if (_arg1 < this.length)
            {
                this._store.splice(_arg1, 0, _arg2);
            }
            else
            {
                this._store.unshift(_arg2);
            };
            this._room.addChild(_arg2);
            this.addListeners(_arg2);
            this._length = this._store.length;
            this.setNeighbours(_arg2);
            _arg2.updateLine();
            _arg2.predecessor.updateLine();
            _arg2.successor.updateLine();
            this._room.productManager.bringToFront();
        }

        public function removeItem(_arg1:RoomPoint):void
        {
            this.removeListeners(_arg1);
            this._store.splice(this._store.indexOf(_arg1), 1);
            this._length = this._store.length;
            this.setNeighbours(_arg1.predecessor);
            this.setNeighbours(_arg1.successor);
            _arg1.predecessor.updateLine();
            _arg1.successor.updateLine();
            this._room.removeChild(_arg1);
        }

        public function removeAll():void
        {
            var _local1:int;
            if (this.length > 0)
            {
                _local1 = 0;
                while (_local1 < this._store.length)
                {
                    this.removeListeners(this._store[_local1]);
                    this._room.removeChild(this._store[_local1]);
                    _local1++;
                };
                this._store = new Vector.<RoomPoint>();
                this._length = this._store.length;
            };
        }

        public function reflect(_arg1:String, _arg2:int):void
        {
            var _local3:int;
            var _local4:int = Math.floor(((this.getExtremum("min", _arg1) + this.getExtremum("max", _arg1)) >> 1));
            if (_arg1 == ReflectionAxis.HORIZONTAL)
            {
                _local3 = 0;
                while (_local3 < this._length)
                {
                    this.getItemAt(_local3).x = (_local4 + (_local4 - this.getItemAt(_local3).x));
                    this.getItemAt(_local3).switchAlignment(ReflectionAxis.HORIZONTAL);
                    _local3++;
                };
            }
            else
            {
                _local3 = 0;
                while (_local3 < this._length)
                {
                    this.getItemAt(_local3).y = (_local4 + (_local4 - this.getItemAt(_local3).y));
                    this.getItemAt(_local3).switchAlignment(ReflectionAxis.VERTICAL);
                    _local3++;
                };
            };
            this.reverse();
        }

        public function setNeighbours(_arg1:RoomPoint):void
        {
            var _local2:int = this._store.indexOf(_arg1);
            if (_local2 == 0)
            {
                _arg1.predecessor = this.getItemAt((this.length - 1));
                _arg1.successor = this.getItemAt(1);
            }
            else
            {
                if (_local2 == (this.length - 1))
                {
                    _arg1.predecessor = this.getItemAt((_local2 - 1));
                    _arg1.successor = this.getItemAt(0);
                }
                else
                {
                    _arg1.predecessor = this.getItemAt((_local2 - 1));
                    _arg1.successor = this.getItemAt((_local2 + 1));
                };
            };
            _arg1.predecessor.successor = _arg1;
            _arg1.successor.predecessor = _arg1;
        }

        public function getExtrema():Extrema
        {
            var _local1:Extrema = new Extrema();
            var _local2:int;
            while (_local2 < this.length)
            {
                if (this.getItemAt(_local2).x > _local1.horMax)
                {
                    _local1.horMax = this.getItemAt(_local2).x;
                };
                if (this.getItemAt(_local2).x < _local1.horMin)
                {
                    _local1.horMin = this.getItemAt(_local2).x;
                };
                if (this.getItemAt(_local2).y > _local1.verMax)
                {
                    _local1.verMax = this.getItemAt(_local2).y;
                };
                if (this.getItemAt(_local2).y < _local1.verMin)
                {
                    _local1.verMin = this.getItemAt(_local2).y;
                };
                _local2++;
            };
            return (_local1);
        }

        public function getExtremum(_arg1:String, _arg2:String):Number
        {
            var _local3:String = (((_arg2)==ReflectionAxis.HORIZONTAL) ? "x" : "y");
            var _local4:Number = this.getItemAt(0)[_local3];
            var _local5:int;
            while (_local5 < this.length)
            {
                _local4 = (((_arg1)=="max") ? Math.max(_local4, this.getItemAt(_local5)[_local3]) : Math.min(_local4, this.getItemAt(_local5)[_local3]));
                _local5++;
            };
            return (_local4);
        }

        private function switchNeighbourPoints():void
        {
            var _local1:int;
            while (_local1 < this.length)
            {
                this.getItemAt(_local1).switchNeighbourPoints();
                _local1++;
            };
        }

        public function reverse():void
        {
            this._store.reverse();
            this.switchNeighbourPoints();
        }

        public function updateAll():void
        {
            var _local1:int;
            while (_local1 < this.length)
            {
                this.getItemAt(_local1).updateLine();
                _local1++;
            };
        }

        public function enableAll():void
        {
            var _local1:int;
            while (_local1 < this.length)
            {
                this.getItemAt(_local1).enable();
                _local1++;
            };
        }

        public function disableAll():void
        {
            var _local1:int;
            while (_local1 < this.length)
            {
                this.getItemAt(_local1).disable();
                _local1++;
            };
        }

        public function removePointHandler(_arg1:RoomPoint):void
        {
            this.removeItem(_arg1);
            this.updateSides();
            this._room.drawSignal.dispatch();
        }

        private function updateSides():void
        {
            this._room.sideManager.checkEnabling();
        }

        private function showPointMenu(_arg1:RoomPoint, _arg2:Boolean):void
        {
            var _local3:Point;
            if (((_arg1.removeable) && ((_arg2 == true))))
            {
                _local3 = this._room.localToGlobal(new Point(_arg1.x, _arg1.y));
                if (this._roomPointMenu == null)
                {
                    this._roomPointMenu = new RoomPointMenu(new OverlayConfig(40, 40, 0xFFFFFF, 0, true, true));
                    this._roomPointMenu.removePoint.add(this.removePointHandler);
                    this._roomPointMenu.onClose.add(this.onMenuClose);
                };
                this._roomPointMenu.x = ((_local3.x - this._roomPointMenu.config.width) - 5);
                this._roomPointMenu.y = ((_local3.y - this._roomPointMenu.config.height) - 5);
                this._roomPointMenu.point = _arg1;
                this._roomPointMenu.show(false, false);
            };
            if ((((_arg2 == false)) && (!((this._roomPointMenu == null)))))
            {
                this._roomPointMenu.hide();
            };
        }

        private function onPointMove(_arg1:RoomPoint):void
        {
            var _local2:Point;
            this._room.drawSignal.dispatch();
            if (this._roomPointMenu != null)
            {
                _local2 = this._room.localToGlobal(new Point(_arg1.x, _arg1.y));
                this._roomPointMenu.x = ((_local2.x - this._roomPointMenu.config.width) - 5);
                this._roomPointMenu.y = ((_local2.y - this._roomPointMenu.config.height) - 5);
            };
        }

        private function onPointSelect(_arg1:RoomPoint):void
        {
            this._room.outlineManager.hideAll();
            this._room.setChildIndex(_arg1, this.maxChildIndex());
        }

        private function maxChildIndex():int
        {
            var _local1:uint;
            var _local2:int;
            while (_local2 < this.length)
            {
                _local1 = Math.max(_local1, this._room.getChildIndex(this._store[_local2]));
                _local2++;
            };
            return (_local1);
        }

        private function onMenuClose(_arg1:Object):void
        {
        }

        private function addNewPoint(_arg1:RoomPoint, _arg2:Point):void
        {
            var _local3:RoomPoint;
            if (this.length < Constants.MAX_POINTS)
            {
                _local3 = new RoomPoint();
                _local3.x = _arg2.x;
                _local3.y = _arg2.y;
                _local3.hAlign = _arg1.hAlign;
                _local3.vAlign = _arg1.vAlign;
                this.addItemAt((this.indexOf(_arg1) + 1), _local3);
                _local3.updateLine();
                this.updateSides();
                this._room.drawSignal.dispatch();
            }
            else
            {
                this._room.systemMessage.dispatch(new SystemMessage(Common.getResourceString("roomMaxPoints", "iLabels", [Constants.MAX_POINTS])));
            };
        }

        private function addListeners(_arg1:RoomPoint):void
        {
            _arg1.select.add(this.onPointSelect);
            _arg1.move.add(this.onPointMove);
            _arg1.addPoint.add(this.addNewPoint);
            _arg1.showMenu.add(this.showPointMenu);
        }

        private function removeListeners(_arg1:RoomPoint):void
        {
            _arg1.move.removeAll();
            _arg1.addPoint.removeAll();
            _arg1.showMenu.removeAll();
        }

        public function sortPoints():void
        {
            var _local1:Number = this._store[0].x;
            var _local2:Number = _local1;
            var _local3:Number = this._store[0].y;
            var _local4:Number = _local3;
            this._topPoints = new Vector.<RoomPoint>();
            this._topPoints.push(this._store[0]);
            this._leftPoints = new Vector.<RoomPoint>();
            this._leftPoints.push(this._store[0]);
            this._botPoints = new Vector.<RoomPoint>();
            this._botPoints.push(this._store[0]);
            this._rightPoints = new Vector.<RoomPoint>();
            this._rightPoints.push(this._store[0]);
            var _local5:int = 1;
            while (_local5 < this._store.length)
            {
                if (this._store[_local5].x <= _local1)
                {
                    if (this._store[_local5].x < _local1)
                    {
                        this._leftPoints = new Vector.<RoomPoint>();
                    };
                    this._leftPoints.push(this._store[_local5]);
                    _local1 = this._store[_local5].x;
                };
                if (this._store[_local5].x >= _local2)
                {
                    if (this._store[_local5].x > _local2)
                    {
                        this._rightPoints = new Vector.<RoomPoint>();
                    };
                    this._rightPoints.push(this._store[_local5]);
                    _local2 = this._store[_local5].x;
                };
                if (this._store[_local5].y >= _local4)
                {
                    if (this._store[_local5].y > _local4)
                    {
                        this._botPoints = new Vector.<RoomPoint>();
                    };
                    this._botPoints.push(this._store[_local5]);
                    _local4 = this._store[_local5].y;
                };
                if (this._store[_local5].y <= _local3)
                {
                    if (this._store[_local5].y < _local3)
                    {
                        this._topPoints = new Vector.<RoomPoint>();
                    };
                    this._topPoints.push(this._store[_local5]);
                    _local3 = this._store[_local5].y;
                };
                _local5++;
            };
            this._topPoints.sort(RoomMeasure.horizontalSort);
            this._botPoints.sort(RoomMeasure.horizontalSort);
            this._leftPoints.sort(RoomMeasure.verticalSort);
            this._rightPoints.sort(RoomMeasure.verticalSort);
        }


    }
}//package at.polypex.badplaner.view.manager
