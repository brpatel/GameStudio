package com.adobe.gamebuilder.editor.storage
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class StoredRoom 
    {

        public var points:Vector.<StoredRoomPoint>;
        public var sites:Vector.<StoredRoomSite>;
        public var products:Vector.<StoredProduct>;
        public var version:int;
        public var name:String = "";
        public var baseRoomID:int;
        public var thumbnail:StoredThumbnail;

        public function StoredRoom()
        {
            this.points = new Vector.<StoredRoomPoint>();
            this.sites = new Vector.<StoredRoomSite>();
            this.products = new Vector.<StoredProduct>();
        }

    }
}//package at.polypex.badplaner.storage
