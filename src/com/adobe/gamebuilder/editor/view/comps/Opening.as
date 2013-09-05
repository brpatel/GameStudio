package com.adobe.gamebuilder.editor.view.comps
{
    import com.adobe.gamebuilder.editor.view.parts.RoomPoint;
    
    import starling.display.DisplayObjectContainer;

    public class Opening extends DisplayObjectContainer 
    {

        public static const DOOR:String = "door";
        public static const WINDOW:String = "window";
        public static const DEFAULT_SIZE:int = 80;
        public static const MIN_SIZE:int = 30;
        public static const MAX_SIZE:int = 220;

        protected var _verticalReflectionState:int = 1;
        protected var _horizontalReflectionState:int = 1;
        protected var _point:RoomPoint;

        public function Opening(_arg1:RoomPoint)
        {
            this._point = _arg1;
        }

        public function get horizontalReflectionState():int
        {
            return (this._horizontalReflectionState);
        }

        public function set horizontalReflectionState(_arg1:int):void
        {
            this._horizontalReflectionState = _arg1;
        }

        public function get verticalReflectionState():int
        {
            return (this._verticalReflectionState);
        }

        public function set verticalReflectionState(_arg1:int):void
        {
            this._verticalReflectionState = _arg1;
        }

        public function setSize(_arg1:Number, _arg2:Number):void
        {
        }

        public function reflect(_arg1:String):void
        {
        }

        public function get point():RoomPoint
        {
            return (this._point);
        }


    }
}//package at.polypex.badplaner.view.comps
