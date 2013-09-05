package com.adobe.gamebuilder.editor.storage
{
    import com.adobe.gamebuilder.editor.core.data.MobileProductVO;
    import com.adobe.gamebuilder.editor.view.Room;
    import com.adobe.gamebuilder.editor.view.comps.Opening;
    import com.adobe.gamebuilder.editor.view.parts.Door;
    import com.adobe.gamebuilder.editor.view.parts.Product;
    import com.adobe.gamebuilder.editor.view.parts.RoomPoint;
    import com.adobe.gamebuilder.editor.view.parts.RoomSide;
    import com.adobe.gamebuilder.editor.view.parts.Window;
    
    import flash.utils.ByteArray;
    
    import __AS3__.vec.Vector;
    
    import starling.utils.deg2rad;
    import starling.utils.rad2deg;

    public class StoreUtils 
    {


        public static function roomToStoredRoom(_arg1:Room):StoredRoom
        {
            var _local3:int;
            var _local4:StoredRoomPoint;
            var _local5:Vector.<Opening>;
            var _local6:int;
            var _local2:StoredRoom = new StoredRoom();
            _local3 = 0;
            while (_local3 < _arg1.pointManager.length)
            {
                _local4 = pointToStoredPoint(_arg1.pointManager.getItemAt(_local3), _local3);
                _local2.points.push(_local4);
                _local5 = _arg1.openingManager.getOpeningsByPoint(_arg1.pointManager.getItemAt(_local3));
                _local6 = 0;
                while (_local6 < _local5.length)
                {
                    _local4.blocks.push(openingToStoredBlock(_local5[_local6]));
                    _local6++;
                };
                _local3++;
            };
            _local3 = 0;
            while (_local3 < _arg1.sideManager.length)
            {
                _local2.sites.push(sideToStoredSide(_arg1.sideManager.getItemAt(_local3), _arg1));
                _local3++;
            };
            _local3 = 0;
            while (_local3 < _arg1.productManager.length)
            {
                _local2.products.push(productToStoredProduct(_arg1.productManager.getItemAt(_local3)));
                _local3++;
            };
            return (_local2);
        }

        public static function compressPlan(_arg1:StoredRoom):ByteArray
        {
            var _local2:ByteArray = new ByteArray();
            _local2.writeObject(_arg1);
            _local2.compress();
            return (_local2);
        }

        public static function pointToStoredPoint(_arg1:RoomPoint, _arg2:int):StoredRoomPoint
        {
            var _local3:StoredRoomPoint = new StoredRoomPoint();
            _local3.x = _arg1.x;
            _local3.y = _arg1.y;
            _local3.vSnap = _arg1.vAlign;
            _local3.hSnap = _arg1.hAlign;
            _local3.initial = !(_arg1.removeable);
            return (_local3);
        }

        public static function storedPointToPoint(_arg1:Object):RoomPoint
        {
            var _local2:RoomPoint;
            _local2 = new RoomPoint(!(_arg1.initial));
            _local2.hAlign = _arg1.hSnap;
            _local2.vAlign = _arg1.vSnap;
            _local2.x = _arg1.x;
            _local2.y = _arg1.y;
            return (_local2);
        }

        public static function openingToStoredBlock(_arg1:Opening):StoredBlock
        {
            var _local2:StoredBlock = new StoredBlock();
            _local2.type = (((_arg1 is Door)) ? Opening.DOOR : Opening.WINDOW);
            _local2.x = _arg1.x;
            _local2.y = _arg1.y;
            _local2.width = _arg1.width;
            _local2.horizontalState = _arg1.horizontalReflectionState;
            _local2.verticalState = _arg1.verticalReflectionState;
            return (_local2);
        }

        public static function storedBlockToOpening(_arg1:Object, _arg2:RoomPoint):Opening
        {
            var _local3:Opening = (((_arg1.type)==Opening.DOOR) ? new Door(_arg2) : new Window(_arg2));
            _local3.horizontalReflectionState = _arg1.horizontalState;
            _local3.verticalReflectionState = _arg1.verticalState;
            _local3.x = _arg1.x;
            _local3.y = _arg1.y;
            _local3.width = _arg1.width;
            return (_local3);
        }

        public static function sideToStoredSide(_arg1:RoomSide, _arg2:Room):StoredRoomSite
        {
            var _local3:StoredRoomSite = new StoredRoomSite();
            _local3.id = _arg1.id;
            _local3.startPointIndex = _arg2.pointManager.indexOf(_arg1.startPoint);
            _local3.endPointIndex = _arg2.pointManager.indexOf(_arg1.endPoint);
            _local3.alignment = _arg1.direction;
            _local3.userVisible = ((!((_arg1.id == RoomSide.SIDE_E))) && (!((_arg1.id == RoomSide.SIDE_F))));
            return (_local3);
        }

        public static function storedSideToSide(_arg1:Object, _arg2:RoomPoint, _arg3:RoomPoint):RoomSide
        {
            var _local4:RoomSide = new RoomSide();
            _local4.id = _arg1.id;
            _local4.startPoint = _arg2;
            _local4.endPoint = _arg3;
            _local4.enabled = _arg1.userVisible;
            _local4.direction = _arg1.alignment;
            _local4.addListeners();
            return (_local4);
        }

        public static function storedProductToProduct(_arg1:Object):Product
        {
            var _local2:MobileProductVO = MobileProductVO.fromProductVO(_arg1.productVO);
            var _local3:Product = new Product(_local2);
            _local3.x = _arg1.x;
            _local3.y = _arg1.y;
            if (_arg1.pivotX)
            {
                _local3.pivotX = _arg1.pivotX;
            };
            if (_arg1.pivotY)
            {
                _local3.pivotY = _arg1.pivotY;
            };
            _local3.startScaleX = _arg1.scaleX;
            _local3.startScaleY = _arg1.scaleY;
            _local3.rotation = deg2rad(Number(_arg1.rotation));
            return (_local3);
        }

        public static function productToStoredProduct(_arg1:Product):StoredProduct
        {
            var _local2:StoredProduct = new StoredProduct();
            _local2.x = _arg1.x;
            _local2.y = _arg1.y;
            _local2.pivotX = _arg1.pivotX;
            _local2.pivotY = _arg1.pivotY;
            _local2.scaleX = _arg1.scaleX;
            _local2.scaleY = _arg1.scaleY;
            _local2.rotation = rad2deg(_arg1.rotation);
            _local2.productVO = MobileProductVO.toProductVO(_arg1.vo);
            return (_local2);
        }


    }
}//package at.polypex.badplaner.storage
