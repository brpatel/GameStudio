package com.adobe.gamebuilder.editor.view.manager
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.RoomMeasure;
    import com.adobe.gamebuilder.editor.model.data.BaseRoom;
    import com.adobe.gamebuilder.editor.model.data.BaseSide;
    import com.adobe.gamebuilder.editor.storage.StoreUtils;
    import com.adobe.gamebuilder.editor.storage.StoredRoom;
    import com.adobe.gamebuilder.editor.storage.StoredRoomPoint;
    import com.adobe.gamebuilder.editor.view.Room;
    import com.adobe.gamebuilder.editor.view.comps.Opening;
    import com.adobe.gamebuilder.editor.view.layout.PointAlign;
    import com.adobe.gamebuilder.editor.view.parts.Product;
    import com.adobe.gamebuilder.editor.view.parts.RoomPoint;
    import com.adobe.gamebuilder.editor.view.parts.RoomSide;
    
    import starling.events.Event;

    public class LoadManager 
    {

        private var _room:Room;

        public function LoadManager(_arg1:Room)
        {
            this._room = _arg1;
        }

        public function restoreRoom(_arg1:StoredRoom):void
        {
            var _local2:int;
            var _local3:RoomPoint;
            var _local4:Opening;
            var _local5:RoomSide;
            var _local6:Product;
            var _local8:int;
            Common.log(("restoreRoom, version=" + _arg1.version));
            var _local7:int = _arg1.points.length;
            _local2 = 0;
            while (_local2 < _local7)
            {
                _local3 = StoreUtils.storedPointToPoint(_arg1.points[_local2]);
                this._room.pointManager.add(_local3);
                _local8 = 0;
                while (_local8 < (_arg1.points[_local2] as StoredRoomPoint).blocks.length)
                {
                    _local4 = StoreUtils.storedBlockToOpening((_arg1.points[_local2] as StoredRoomPoint).blocks[_local8], _local3);
                    this._room.openingManager.add(_local4, _local3, false);
                    _local8++;
                };
                _local2++;
            };
            _local2 = 0;
            while (_local2 < _local7)
            {
                this._room.pointManager.setNeighbours(this._room.pointManager.getItemAt(_local2));
                this._room.pointManager.getItemAt(_local2).updateLine();
                _local2++;
            };
            _local7 = _arg1.sites.length;
            _local2 = 0;
            while (_local2 < _local7)
            {
                _local5 = StoreUtils.storedSideToSide(_arg1.sites[_local2], this._room.pointManager.getItemAt(_arg1.sites[_local2].startPointIndex), this._room.pointManager.getItemAt(_arg1.sites[_local2].endPointIndex));
                this._room.sideManager.add(_local5);
                _local2++;
            };
            _local7 = _arg1.products.length;
            _local2 = 0;
            while (_local2 < _local7)
            {
                _local6 = StoreUtils.storedProductToProduct(_arg1.products[_local2]);
                this._room.productManager.add(_local6);
                _local2++;
            };
        }

        public function importRoom(_arg1:Object):void
        {
            var _local2:int;
            var _local3:RoomPoint;
            var _local4:Opening;
            var _local5:RoomSide;
            var _local6:Product;
            var _local12:int;
            Common.log(("importRoom, version=" + _arg1.version));
            var _local7:Number = Infinity;
            var _local8:Number = Infinity;
            var _local9:int = _arg1.points.length;
            _local2 = 0;
            while (_local2 < _local9)
            {
                _local3 = StoreUtils.storedPointToPoint(_arg1.points[_local2]);
                _local3.x = (_local3.x + (((_local3.hAlign)==PointAlign.RIGHT) ? 0 : (RoomMeasure.WALL_SIZE_ONLINE - RoomMeasure.WALL_SIZE)));
                _local3.y = (_local3.y + (((_local3.vAlign)==PointAlign.BOTTOM) ? 0 : (RoomMeasure.WALL_SIZE_ONLINE - RoomMeasure.WALL_SIZE)));
                if (_local3.x < _local7)
                {
                    _local7 = _local3.x;
                };
                if (_local3.y < _local8)
                {
                    _local8 = _local3.y;
                };
                this._room.pointManager.add(_local3);
                _local12 = 0;
                while (_local12 < _arg1.points[_local2].blocks.length)
                {
                    _local4 = StoreUtils.storedBlockToOpening(_arg1.points[_local2].blocks[_local12], _local3);
                    _local4.x = (_local4.x - ((RoomMeasure.WALL_SIZE_ONLINE - RoomMeasure.WALL_SIZE) / 2));
                    this._room.openingManager.add(_local4, _local3, false);
                    _local12++;
                };
                _local2++;
            };
            var _local10:Number = -((_local7 + RoomMeasure.WALL_SIZE_HALF));
            var _local11:Number = -((_local8 + RoomMeasure.WALL_SIZE_HALF));
            _local2 = 0;
            while (_local2 < _local9)
            {
                _local3 = this._room.pointManager.getItemAt(_local2);
                _local3.x = (_local3.x + _local10);
                _local3.y = (_local3.y + _local11);
                this._room.pointManager.setNeighbours(_local3);
                _local2++;
            };
            _local2 = 0;
            while (_local2 < _local9)
            {
                this._room.pointManager.getItemAt(_local2).updateLine();
                _local2++;
            };
            _local9 = _arg1.sites.length;
            _local2 = 0;
            while (_local2 < _local9)
            {
                _local5 = StoreUtils.storedSideToSide(_arg1.sites[_local2], this._room.pointManager.getItemAt(_arg1.sites[_local2].startPointIndex), this._room.pointManager.getItemAt(_arg1.sites[_local2].endPointIndex));
                this._room.sideManager.add(_local5);
                _local2++;
            };
            _local9 = _arg1.products.length;
            _local2 = 0;
            while (_local2 < _arg1.products.length)
            {
                _local6 = StoreUtils.storedProductToProduct(_arg1.products[_local2]);
                _local6.addEventListener(Event.COMPLETE, this.initImportedProduct);
                _local6.x = (_local6.x + (_local10 - RoomMeasure.WALL_SIZE_HALF));
                _local6.y = (_local6.y + (_local11 - RoomMeasure.WALL_SIZE_HALF));
                this._room.productManager.add(_local6);
                _local2++;
            };
        }

        private function initImportedProduct(_arg1:Event):void
        {
            (_arg1.currentTarget as Product).finishImport();
        }

        public function loadBaseRoom(_arg1:BaseRoom):void
        {
            var _local2:int;
            var _local3:BaseSide;
            _local2 = 0;
            while (_local2 < _arg1.points.length)
            {
                this._room.pointManager.add(RoomPoint.fromBasePoint(_arg1.points[_local2]));
                _local2++;
            };
            _local2 = 0;
            while (_local2 < _arg1.points.length)
            {
                this._room.pointManager.setNeighbours(this._room.pointManager.getItemAt(_local2));
                this._room.pointManager.getItemAt(_local2).updateLine();
                _local2++;
            };
            _local2 = 0;
            while (_local2 < _arg1.sides.length)
            {
                _local3 = (_arg1.sides[_local2] as BaseSide);
                this._room.sideManager.add(RoomSide.createInstance(_local3.id, this._room.pointManager.getItemAt(_local3.startIndex), this._room.pointManager.getItemAt(_local3.endIndex)));
                _local2++;
            };
        }


    }
}//package at.polypex.badplaner.view.manager
