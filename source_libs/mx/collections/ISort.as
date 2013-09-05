//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.collections
{
    public interface ISort 
    {

        function get compareFunction():Function;
        function set compareFunction(_arg1:Function):void;
        function get fields():Array;
        function set fields(_arg1:Array):void;
        function get unique():Boolean;
        function set unique(_arg1:Boolean):void;
        function findItem(_arg1:Array, _arg2:Object, _arg3:String, _arg4:Boolean=false, _arg5:Function=null):int;
        function propertyAffectsSort(_arg1:String):Boolean;
        function reverse():void;
        function sort(_arg1:Array):void;

    }
}//package mx.collections
