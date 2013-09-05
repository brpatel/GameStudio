package com.adobe.gamebuilder.editor.model.data
{
    public class BaseRoom 
    {

        public var id:int;
        public var points:Array;
        public var sides:Array;


        public static function createInstance(_arg1:int, _arg2:Array, _arg3:Array):BaseRoom
        {
            var _local4:BaseRoom = new (BaseRoom)();
            _local4.id = _arg1;
            _local4.points = _arg2;
            _local4.sides = _arg3;
            return (_local4);
        }


    }
}//package at.polypex.badplaner.model.data
