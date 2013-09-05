package com.adobe.gamebuilder.editor.model.data
{
    public class BaseSide 
    {

        public var id:String;
        public var startIndex:int;
        public var endIndex:int;


        public static function createInstance(_arg1:String, _arg2:int, _arg3:int):BaseSide
        {
            var _local4:BaseSide = new (BaseSide)();
            _local4.id = _arg1;
            _local4.startIndex = _arg2;
            _local4.endIndex = _arg3;
            return (_local4);
        }


    }
}//package at.polypex.badplaner.model.data
