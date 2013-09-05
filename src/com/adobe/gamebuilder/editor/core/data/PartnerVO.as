
package com.adobe.gamebuilder.editor.core.data
{
    public class PartnerVO 
    {

        public var id:int = 0;
        public var name:String;
        public var zip:String = "";
        public var street:String = "";
        public var city:String = "";
        public var country:String;
        public var web:String;
        public var phone:String;
        public var email:String;
        public var angebot:String;
        public var distance:Number = -1;


        public function get labelDisplay():String
        {
            return ((this.name + (((((((((this.zip == "")) && ((this.city == "")))) && ((this.street == "")))) || ((this.id == -1)))) ? "" : ((((((" (" + this.zip) + " ") + this.city) + ", ") + this.street) + ")"))));
        }


    }
}//package at.polypex.badplaner.core.data
