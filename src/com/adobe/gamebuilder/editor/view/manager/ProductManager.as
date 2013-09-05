package com.adobe.gamebuilder.editor.view.manager
{
    import com.adobe.gamebuilder.editor.view.Room;
    import com.adobe.gamebuilder.editor.view.parts.Product;
    import com.adobe.gamebuilder.util.Utils;
    
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import __AS3__.vec.Vector;
    
    import editor.components.MapObjectInstance;
    
    import starling.display.DisplayObject;
    import starling.utils.deg2rad;

    public class ProductManager 
    {

        private var _room:Room;
        private var _selectedProduct:Product;
        private var _store:Vector.<Product>;
        private var _radius:Number;
        private var _productStartRotation:Number;
        private var _buttonStartRotation:Number;
        private var _startCenter:Point;

        public function ProductManager(_arg1:Room)
        {
            this._room = _arg1;
            this.init();
			// for external use
			GameBuilderApp.productManager = this;
        }

        public function get room():Room
        {
            return (this._room);
        }

        private function init():void
        {
            this._store = new Vector.<Product>();
            this._room.outlineManager.productOutline.onDelete.add(this.productDeleteHandler);
            this._room.outlineManager.productOutline.onResize.add(this.resizeSelectedProduct);
            this._room.outlineManager.btnRotate.onMove.add(this.btnRotateOnMove);
            this._room.outlineManager.btnRotate.onTouchBegin.add(this.btnRotateOnTouchBegin);
            this._room.outlineManager.btnRotate.onTouchEnd.add(this.btnRotateOnTouchEnd);
        }

        private function productDeleteHandler():void
        {
			
            this.deleteSelectedProduct();
            this._room.outlineManager.hideAll();
        }

        public function get selectedProduct():Product
        {
            return (this._selectedProduct);
        }

        public function set selectedProduct(_arg1:Product):void
        {
            this._selectedProduct = _arg1;
        }

        public function add(_arg1:Product):void
        {
            this._store.push(_arg1);
            this._room.addChild(_arg1);
            this.addListeners(_arg1);
        }

        public function removeAll():void
        {
            var _local1:int;
            if (this.length > 0)
            {
                _local1 = 0;
                while (_local1 < this._store.length)
                {
                    this.deleteProduct(this._store[_local1]);
                    _local1++;
                };
                this._store = new Vector.<Product>();
            };
        }

        public function bringToFront():void
        {
            var _local1:int;
            while (_local1 < this._store.length)
            {
                this._room.setChildIndex(this._store[_local1], (this._room.numChildren - 1));
                _local1++;
            };
        }

        public function getItemAt(_arg1:int):Product
        {
            return (this._store[_arg1]);
        }

        public function get length():int
        {
            return (this._store.length);
        }

        private function resizeSelectedProduct(_arg1:Number, _arg2:Number):void
        {
            if (this._selectedProduct)
            {
                this._selectedProduct.setSize(_arg1, _arg2);
                this.updateProductOutline(this._selectedProduct, false, true);
            };
        }

        private function deleteSelectedProduct():void
        {
            if (this._selectedProduct)
            {
				this.selectedProduct.productDelete.dispatch(this._selectedProduct);
                this.removeListeners(this._selectedProduct);
                this.removeProductFromVector(this._selectedProduct);
                this.deleteProduct(this._selectedProduct);
                this._selectedProduct = null;
            };
        }

        private function deleteProduct(_arg1:Product):void
        {
            this.removeListeners(_arg1);
            this._room.removeChild(_arg1);
            _arg1.dispose();
        }

        private function removeProductFromVector(_arg1:Product):void
        {
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

        private function removeListeners(_arg1:Product):void
        {
            _arg1.moveInit.removeAll();
            _arg1.move.removeAll();
            _arg1.moveEnded.removeAll();
        }

        private function addListeners(_arg1:Product):void
        {
            _arg1.moveInit.add(this.productMoveInitHandler);
            _arg1.move.add(this.productMoveHandler);
            _arg1.moveEnded.add(this.productMoveEndedHandler);
        }

        private function productMoveInitHandler(_arg1:Product):void
        {
            var _local2:Rectangle = _arg1.getBounds(_arg1);
            var _local3:Point = this._room.globalToLocal(_arg1.localToGlobal(new Point(0, 0)));
            var _local4:Rectangle = _arg1.getBounds(this._room);
            this._selectedProduct = _arg1;
            this._room.outlineManager.showProductBox(_arg1, _local3, (_arg1.originalWidth * _arg1.scaleX), (_arg1.originalHeight * _arg1.scaleY), true, true);
        }

        private function productMoveHandler(_arg1:Product):void
        {
            var _local2:Rectangle = _arg1.getBounds(_arg1);
            var _local3:Point = this._room.globalToLocal(_arg1.localToGlobal(new Point(0, 0)));
            var _local4:Point = this._room.globalToLocal(_arg1.localToGlobal(new Point((_local2.width >> 1), (_local2.height >> 1))));
            var _local5:Rectangle = _arg1.getBounds(this._room);
            this._room.outlineManager.showDistanceCross(_arg1, _local4, _local5);
            this._room.outlineManager.showProductBox(_arg1, _local3, (_arg1.originalWidth * _arg1.scaleX), (_arg1.originalHeight * _arg1.scaleY), true, true);
        }

        private function updateProductOutline(_arg1:Product, _arg2:Boolean, _arg3:Boolean):void
        {
            var _local4:Point;
            if (_arg1 != null)
            {
                _local4 = this._room.globalToLocal(_arg1.localToGlobal(new Point(0, 0)));
                this._room.outlineManager.showProductBox(_arg1, _local4, (_arg1.originalWidth * _arg1.scaleX), (_arg1.originalHeight * _arg1.scaleY), _arg2, _arg3);
            };
        }

        private function productMoveEndedHandler(_arg1:Product):void
        {
            this._room.outlineManager.hideDistanceCross();
			
			
        }

        private function btnRotateOnTouchEnd(_arg1:DisplayObject, _arg2:Number, _arg3:Number):void
        {
            this.endRotateSelectedProduct();
			this.selectedProduct.productRotateEnded.dispatch(this.selectedProduct);
        }

        private function btnRotateOnTouchBegin(_arg1:DisplayObject, _arg2:Number, _arg3:Number):void
        {
            this.startRotateSelectedProduct(_arg2, _arg3);
        }

        private function btnRotateOnMove(_arg1:DisplayObject, _arg2:Number, _arg3:Number):void
        {
            this.rotateSelectedProduct(_arg2, _arg3);
        }

        private function getRotation(_arg1:Number, _arg2:Number):Number
        {
            var _local3:Point = new Point(_arg1, _arg2);
            return (deg2rad(Utils.calcRotation(this._startCenter, _local3)));
        }

        private function startRotateSelectedProduct(_arg1:Number, _arg2:Number):void
        {
            if (this._selectedProduct)
            {
                this._selectedProduct.setPivot("center");
                this._startCenter = new Point(this._selectedProduct.x, this._selectedProduct.y);
                this._radius = Math.sqrt(((_arg1 * _arg1) + (_arg2 * _arg2)));
                this._productStartRotation = this._selectedProduct.rotation;
                this._buttonStartRotation = this.getRotation(_arg1, _arg2);
            };
        }

        private function rotateSelectedProduct(_arg1:Number, _arg2:Number):void
        {
            if (this._selectedProduct)
            {
                this._selectedProduct.rotate((this._productStartRotation + (this.getRotation(_arg1, _arg2) - this._buttonStartRotation)));
                this.updateProductOutline(this._selectedProduct, true, false);
            };
        }

        private function endRotateSelectedProduct():void
        {
            this.updateProductOutline(this._selectedProduct, true, true);
			
        }
		
		public function getProductObjectByID(id:uint):Product{
			var product:Product;
			var i:int;
			while (i < this._store.length)
			{
				product = this._store[i];
				if (product._instanceID == id)
				{
					return (product);
				};
				i++;
			};
			return (null);
		}


    }
}//package at.polypex.badplaner.view.manager
