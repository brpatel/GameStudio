//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.data
{
    import __AS3__.vec.Vector;

    public interface IHierarchicalCollectionDataDescriptor 
    {

        function isBranch(_arg1:Object):Boolean;
        function getLength(_arg1:Object, ... _args):int;
        function getItemAt(_arg1:Object, _arg2:int, ... _args):Object;
        function setItemAt(_arg1:Object, _arg2:Object, _arg3:int, ... _args):void;
        function addItemAt(_arg1:Object, _arg2:Object, _arg3:int, ... _args):void;
        function removeItemAt(_arg1:Object, _arg2:int, ... _args):Object;
        function getItemLocation(_arg1:Object, _arg2:Object, _arg3:Vector.<int>=null, ... _args):Vector.<int>;

    }
}//package org.josht.starling.foxhole.data
