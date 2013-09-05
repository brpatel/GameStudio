package com.adobe.gamebuilder.editor.view.layout
{
    public class OverlayConfig 
    {

        public var width:uint;
        public var height:uint;
        public var bgColor:int;
        public var bgAlpha:Number;
        public var closeOnTouchOutside:Boolean;
        public var reuse:Boolean;
        public var hideOnRemove:Boolean;

        public function OverlayConfig(_arg1:uint, _arg2:uint, _arg3:int=0xCCCCCC, _arg4:Number=0.8, _arg5:Boolean=false, _arg6:Boolean=false, _arg7:Boolean=true)
        {
            this.width = _arg1;
            this.height = _arg2;
            this.bgColor = _arg3;
            this.bgAlpha = _arg4;
            this.closeOnTouchOutside = _arg5;
            this.reuse = _arg6;
            this.hideOnRemove = _arg7;
        }

    }
}//package at.polypex.badplaner.view.layout
