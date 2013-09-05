package com.adobe.gamebuilder.editor.view.comps
{
    import com.adobe.gamebuilder.editor.view.DrawArea;
    
    import __AS3__.vec.Vector;

    public class MeasureLineDispenser 
    {

        private var _drawArea:DrawArea;
        private var _vector:Vector.<MeasureLine>;
        private var _pointer:int;
        private var _length:int;
        private var _width:int;
        private var _pivotX:int;
        private var _pivotY:int;

        public function MeasureLineDispenser(_arg1:DrawArea, _arg2:Number, _arg3:int, _arg4:int)
        {
            this._drawArea = _arg1;
            this._width = _arg2;
            this._pivotX = _arg3;
            this._pivotY = _arg4;
            this._vector = new Vector.<MeasureLine>();
            this._length = 0;
            this._pointer = 0;
        }

        public function reset(_arg1:int=0):void
        {
            this._pointer = _arg1;
        }

        public function push(_arg1:MeasureLine):void
        {
            this._vector.push(_arg1);
            this._length = this._vector.length;
        }

        public function getNextItem():MeasureLine
        {
            if (this._pointer > (this.length - 1))
            {
                this.addNewItem();
            };
            return (this._vector[this._pointer++]);
        }

        public function getItemAt(_arg1:int):MeasureLine
        {
            if (_arg1 > (this.length - 1))
            {
                this.addNewItem();
            };
            return (this._vector[_arg1]);
        }

        public function addNewItem():void
        {
            var _local1:MeasureLine = new MeasureLine(this._width);
            _local1.pivotX = this._pivotX;
            _local1.pivotY = this._pivotY;
            _local1.visible = false;
            this.push(_local1);
            this._drawArea.addChild(_local1);
        }

        public function get length():int
        {
            return (this._length);
        }

        public function hideExcessive():void
        {
            var _local1:int;
            if (this._pointer <= (this.length - 1))
            {
                _local1 = this._pointer;
                while (_local1 < this.length)
                {
                    this._vector[_local1].visible = false;
                    _local1++;
                };
            };
        }

        public function showAll():void
        {
            var _local1:int;
            while (_local1 < this.length)
            {
                this._vector[_local1].visible = true;
                _local1++;
            };
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


    }
}//package at.polypex.badplaner.view.comps
