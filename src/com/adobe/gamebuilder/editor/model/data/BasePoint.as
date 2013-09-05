package com.adobe.gamebuilder.editor.model.data
{
    import com.adobe.gamebuilder.editor.core.RoomMeasure;

    public class BasePoint 
    {

        public var x:Number;
        public var y:Number;
        public var hAlign:String;
        public var vAlign:String;


        public static function createInstance(_arg1:Number, _arg2:Number, _arg3:String, _arg4:String):BasePoint
        {
            var _local5:BasePoint = new (BasePoint)();
            _local5.x = RoomMeasure.cm2px(_arg1);
            _local5.y = RoomMeasure.cm2px(_arg2);
            _local5.hAlign = _arg3;
            _local5.vAlign = _arg4;
            return (_local5);
        }


        public function clone():BasePoint
        {
            var _local1:BasePoint = new BasePoint();
            _local1.x = this.x;
            _local1.y = this.y;
            _local1.hAlign = this.hAlign;
            _local1.vAlign = this.vAlign;
            return (_local1);
        }


    }
}//package at.polypex.badplaner.model.data
