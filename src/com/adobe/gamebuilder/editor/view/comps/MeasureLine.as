package com.adobe.gamebuilder.editor.view.comps
{
    import starling.display.Quad;

    public class MeasureLine extends Quad 
    {

        public function MeasureLine(_arg1:Number, _arg2:Number=2, _arg3:uint=0xDC0033, _arg4:Boolean=true)
        {
            super(_arg1, _arg2, _arg3, _arg4);
            this.pivotX = (_arg1 >> 1);
            this.pivotY = 1;
        }

        public function setPosition(_arg1:int, _arg2:int, _arg3:Boolean=true):void
        {
            this.x = _arg1;
            this.y = _arg2;
            this.visible = _arg3;
        }

        override public function set width(_arg1:Number):void
        {
            var _local2:Number = this.rotation;
            this.rotation = 0;
            super.width = _arg1;
            this.rotation = _local2;
        }


    }
}//package at.polypex.badplaner.view.comps
