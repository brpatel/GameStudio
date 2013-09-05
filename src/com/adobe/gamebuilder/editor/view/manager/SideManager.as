package com.adobe.gamebuilder.editor.view.manager
{
    import com.adobe.gamebuilder.editor.view.Room;
    import com.adobe.gamebuilder.editor.view.layout.ReflectionAxis;
    import com.adobe.gamebuilder.editor.view.parts.RoomSide;
    
    import __AS3__.vec.Vector;

    public class SideManager 
    {

        private var _room:Room;
        private var _store:Vector.<RoomSide>;

        public function SideManager(_arg1:Room)
        {
            this._room = _arg1;
            this._store = new Vector.<RoomSide>();
        }

        public function get length():int
        {
            return (this._store.length);
        }

        public function add(_arg1:RoomSide):void
        {
            this._store.push(_arg1);
            this._room.addChild(_arg1);
            this.addListeners(_arg1);
        }

        public function indexOf(_arg1, _arg2=0):int
        {
            return (this._store.indexOf(_arg1, _arg2));
        }

        public function getItemAt(_arg1:int):RoomSide
        {
            return (this._store[_arg1]);
        }

        public function enableAll():void
        {
            var _local1:int;
            while (_local1 < this.length)
            {
                this.getItemAt(_local1).show();
                _local1++;
            };
        }

        public function disableAll():void
        {
            var _local1:int;
            while (_local1 < this.length)
            {
                this.getItemAt(_local1).hide();
                _local1++;
            };
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
                    this._store[_local1].onRemove.dispatch();
                    this._room.removeChild(this._store[_local1]);
                    _local1++;
                };
                this._store.length = 0;
            };
        }

        public function checkEnabling():void
        {
            var _local1:int;
            while (_local1 < this.length)
            {
                this.getItemAt(_local1).checkEnabling();
                _local1++;
            };
        }

        public function switchIDs(_arg1:String, _arg2:String):void
        {
            this.getSideByID(_arg1).id = "inter";
            this.getSideByID(_arg2).id = _arg1;
            this.getSideByID("inter").id = _arg2;
        }

        public function switchEndPoints():void
        {
            var _local1:int;
            while (_local1 < this.length)
            {
                this.getItemAt(_local1).switchEndPoints();
                _local1++;
            };
        }

        public function reflect(_arg1:String, _arg2:int):void
        {
            this.switchEndPoints();
            if (_arg1 == ReflectionAxis.VERTICAL)
            {
                this.switchIDs(RoomSide.SIDE_A, RoomSide.SIDE_C);
            }
            else
            {
                this.switchIDs(RoomSide.SIDE_B, RoomSide.SIDE_D);
            };
        }

        public function getSideByID(_arg1:String):RoomSide
        {
            var _local2:RoomSide;
            var _local3:int;
            while (_local3 < this.length)
            {
                if (this.getItemAt(_local3).id == _arg1)
                {
                    _local2 = this.getItemAt(_local3);
                    break;
                };
                _local3++;
            };
            return (_local2);
        }

        private function addListeners(_arg1:RoomSide):void
        {
            _arg1.change.add(this.sideChangeHandler);
        }

        private function removeListeners(_arg1:RoomSide):void
        {
            _arg1.change.removeAll();
        }

        private function sideChangeHandler():void
        {
            this._room.drawSignal.dispatch();
        }


    }
}//package at.polypex.badplaner.view.manager
