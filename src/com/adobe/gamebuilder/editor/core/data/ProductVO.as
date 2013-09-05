
package com.adobe.gamebuilder.editor.core.data
{
    public class ProductVO 
    {

        public var id:int;
        public var name:String;
        public var category:int;
        public var subcat:int;
        public var subids:String;
        public var scaleable:Boolean = false;
        public var notes:String;
        public var notes2:String;
        public var filepath:String;
        public var articlenr:int;
        public var sort_index:int;
        public var infourl:String;
        private var _originalWidth:int;
        private var _originalHeight:int;


        public function storeOriginalSize(_arg1:int, _arg2:int):void
        {
            this._originalWidth = _arg1;
            this._originalHeight = _arg2;
        }

        public function getOriginalWidth():int
        {
            return (this._originalWidth);
        }

        public function getOriginalHeight():int
        {
            return (this._originalHeight);
        }


    }
}//package at.polypex.badplaner.core.data
