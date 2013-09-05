package com.adobe.gamebuilder.editor.view.manager
{
    import com.adobe.gamebuilder.editor.view.Room;
    import com.adobe.gamebuilder.editor.view.comps.MoveableImage;
    import com.adobe.gamebuilder.editor.view.comps.Opening;
    import com.adobe.gamebuilder.editor.view.parts.DistanceCross;
    import com.adobe.gamebuilder.editor.view.parts.OpeningOutline;
    import com.adobe.gamebuilder.editor.view.parts.Product;
    import com.adobe.gamebuilder.editor.view.parts.ProductOutline;
    
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class OutlineManager 
    {

        private var _room:Room;
        private var _productOutline:ProductOutline;
        private var _openingOutline:OpeningOutline;
        private var _distanceCross:DistanceCross;
        private var _btnRotate:MoveableImage;

        public function OutlineManager(_arg1:Room)
        {
            this._room = _arg1;
            this.init();
        }

        public function get btnRotate():MoveableImage
        {
            return (this._btnRotate);
        }

        public function get openingOutline():OpeningOutline
        {
            return (this._openingOutline);
        }

        public function get productOutline():ProductOutline
        {
            return (this._productOutline);
        }

        private function init():void
        {
            this._distanceCross = new DistanceCross();
            this._distanceCross.visible = false;
            this._room.addChild(this._distanceCross);
            this._productOutline = new ProductOutline();
            this._room.addChild(this._productOutline);
            this._openingOutline = new OpeningOutline();
            this._room.addChild(this._openingOutline);
            this._btnRotate = new MoveableImage("icon_rotate", new Rectangle(-(Infinity), -(Infinity), Infinity, Infinity));
            this._btnRotate.visible = false;
            this._btnRotate.pivotX = (this._btnRotate.width >> 1);
            this._btnRotate.pivotY = (this._btnRotate.height >> 1);
            this._room.addChild(this._btnRotate);
        }

        public function showDistanceCross(_arg1:Product, _arg2:Point, _arg3:Rectangle):void
        {
            this._distanceCross.productBounds = _arg3;
            this._distanceCross.x = _arg2.x;
            this._distanceCross.y = _arg2.y;
            this._distanceCross.visible = true;
            this._room.setChildIndex(this._distanceCross, (this._room.numChildren - 1));
            this._distanceCross.showDistances(_arg1, this._room.pointManager);
        }

        public function hideAll():void
        {
            this.hideProductOutline();
            this.hideOpeningOutline();
        }

        public function showProductBox(_arg1:Product, _arg2:Point, _arg3:Number, _arg4:Number, _arg5:Boolean, _arg6:Boolean):void
        {
            this.hideOpeningOutline();
            this._productOutline.rotation = _arg1.rotation;
            this._productOutline.x = _arg2.x;
            this._productOutline.y = _arg2.y;
            this._productOutline.scaleable = _arg1.vo.scaleable;
            this._productOutline.setBounds(_arg3, _arg4, _arg5);
            this._productOutline.visible = true;
            this._room.setChildIndex(this._productOutline, (this._room.numChildren - 1));
            if (_arg6)
            {
                this._btnRotate.visible = true;
                this._room.setChildIndex(this._btnRotate, this._room.numChildren);
                this.positionRotateButton();
                _arg1.move.add(this.onProductMove);
            };
        }

        private function onProductMove(_arg1:Product):void
        {
            this.positionRotateButton();
        }

        private function positionRotateButton():void
        {
            var _local1:Point = this._room.globalToLocal(this._productOutline.getGlobalBtnPosition());
            this._btnRotate.x = _local1.x;
            this._btnRotate.y = _local1.y;
        }

        public function hideProductOutline():void
        {
            if (this._productOutline)
            {
                this._btnRotate.visible = false;
                this._productOutline.visible = false;
                if (this._room.productManager.selectedProduct != null)
                {
					this._room.productManager.selectedProduct.productDeSelect.dispatch();
                    this._room.productManager.selectedProduct.move.remove(this.onProductMove);
                    this._room.productManager.selectedProduct = null;
                };
            };
        }

        public function outlineOpening(_arg1:Opening, _arg2:Boolean=false):void
        {
            if (_arg2)
            {
                this.hideProductOutline();
                this._room.openingOutline.visible = true;
                this._room.setChildIndex(this._room.openingOutline, (this._room.numChildren - 1));
            };
            this._room.openingOutline.outline(_arg1);
        }

        public function hideOpeningOutline():void
        {
            if (this._room.openingOutline)
            {
                this._room.openingOutline.visible = false;
                this._room.openingManager.selectedOpening = null;
            };
        }

        public function hideDistanceCross():void
        {
            this._distanceCross.visible = false;
        }


    }
}//package at.polypex.badplaner.view.manager
