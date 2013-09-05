//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.text
{
    import starling.text.BitmapFont;

    public class BitmapFontTextFormat 
    {

        public var font:BitmapFont;
        public var color:uint;
        public var size:Number;
        public var letterSpacing:Number = 0;
        public var isKerningEnabled:Boolean = true;

        public function BitmapFontTextFormat(_arg1:BitmapFont, _arg2:Number=NaN, _arg3:uint=0xFFFFFF)
        {
            this.font = _arg1;
            this.size = _arg2;
            this.color = _arg3;
        }

    }
}//package org.josht.starling.foxhole.text
