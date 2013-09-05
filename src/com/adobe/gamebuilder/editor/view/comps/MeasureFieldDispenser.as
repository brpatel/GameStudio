package com.adobe.gamebuilder.editor.view.comps
{
    import com.adobe.gamebuilder.editor.view.DrawArea;
    
    import __AS3__.vec.Vector;

    public class MeasureFieldDispenser 
    {

        private var _pointer:int;
        private var _length:int;
        private var _drawArea:DrawArea;
        private var _vector:Vector.<MeasureField>;

        public function MeasureFieldDispenser(_arg1:DrawArea)
        {
            this._drawArea = _arg1;
            this._vector = new Vector.<MeasureField>();
            this._length = 0;
            this._pointer = 0;
        }

        public function reset(_arg1:int=0):void
        {
            this._pointer = _arg1;
        }

        public function push(_arg1:MeasureField):void
        {
            this._vector.push(_arg1);
            this._length = this._vector.length;
        }

        public function getNextItem():MeasureField
        {
            if (this._pointer > (this.length - 1))
            {
                this.addNewItem();
            };
            this._pointer++;
            return (this._vector[(this._pointer - 1)]);
        }

        public function get length():int
        {
            return (this._length);
        }

        public function hideAll():void
        {
            var _local1:int;
            while (_local1 < this.length)
            {
                this._vector[_local1].visible = false;
                _local1++;
            };
        }

        private function addNewItem():void
        {
            var _local1:MeasureField = new MeasureField();
            _local1.visible = false;
            this.push(_local1);
            this._drawArea.addChild(_local1);
        }


    }
}//package at.polypex.badplaner.view.comps
