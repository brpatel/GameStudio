package com.adobe.gamebuilder.editor.model.data
{
    public class Plan 
    {

        public var isNew:Boolean = true;
        public var name:String = "";
        public var baseRoom:int = 1;


        public function toString():String
        {
            return ((((((("Plan [name=" + this.name) + ", baseRoom=") + this.baseRoom) + ", isNew=") + this.isNew) + "]"));
        }


    }
}//package at.polypex.badplaner.model.data
