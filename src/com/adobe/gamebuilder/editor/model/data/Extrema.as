package com.adobe.gamebuilder.editor.model.data
{
    public class Extrema 
    {

        public var horMin:Number;
        public var horMax:Number;
        public var verMin:Number;
        public var verMax:Number;

        public function Extrema()
        {
            this.horMin = Infinity;
            this.horMax = -(Infinity);
            this.verMin = Infinity;
            this.verMax = -(Infinity);
        }

        public function toString():String
        {
            return ((((((((("[Extrema (horMin:" + this.horMin) + ", horMax:") + this.horMax) + ", verMin:") + this.verMin) + ", verMax:") + this.verMax) + ")]"));
        }


    }
}//package at.polypex.badplaner.model.data
