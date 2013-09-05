//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.modules
{
    import mx.core.IFlexModuleFactory;
    import flash.system.ApplicationDomain;
    import flash.system.SecurityDomain;
    import flash.utils.ByteArray;
    import flash.events.*;

    public interface IModuleInfo extends IEventDispatcher 
    {

        function get data():Object;
        function set data(_arg1:Object):void;
        function get error():Boolean;
        function get factory():IFlexModuleFactory;
        function get loaded():Boolean;
        function get ready():Boolean;
        function get setup():Boolean;
        function get url():String;
        function load(_arg1:ApplicationDomain=null, _arg2:SecurityDomain=null, _arg3:ByteArray=null, _arg4:IFlexModuleFactory=null):void;
        function release():void;
        function unload():void;
        function publish(_arg1:IFlexModuleFactory):void;

    }
}//package mx.modules
