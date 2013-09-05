package com.adobe.gamebuilder.editor.storage
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class StoredRoomPoint 
    {

        public var x:Number;
        public var y:Number;
        public var index:int;
        public var initial:Boolean;
        public var hSnap:String;
        public var vSnap:String;
        public var blocks:Vector.<StoredBlock>;

        public function StoredRoomPoint()
        {
            this.blocks = new Vector.<StoredBlock>();
        }

    }
}//package at.polypex.badplaner.storage
