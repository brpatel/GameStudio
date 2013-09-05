package com.adobe.gamebuilder.editor.view.comps
{
    import starling.text.TextField;

    public class MeasureField extends TextField 
    {

        public function MeasureField(_arg1:int=50, _arg2:int=20, _arg3:String="", _arg4:String="defaultFont", _arg5:Number=12, _arg6:uint=0xDC0033, _arg7:Boolean=false)
        {
            super(_arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7);
        }

        override public function set text(_arg1:String):void
        {
            super.text = (((_arg1)=="0") ? "" : _arg1);
        }

        public function setPosition(_arg1:int, _arg2:int, _arg3:Boolean=true):void
        {
            this.x = _arg1;
            this.y = _arg2;
            this.visible = _arg3;
        }


    }
}//package at.polypex.badplaner.view.comps
