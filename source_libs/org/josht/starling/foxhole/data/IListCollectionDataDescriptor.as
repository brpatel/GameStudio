//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.data
{
    public interface IListCollectionDataDescriptor 
    {

        function getLength(_arg1:Object):int;
        function getItemAt(_arg1:Object, _arg2:int):Object;
        function setItemAt(_arg1:Object, _arg2:Object, _arg3:int):void;
        function addItemAt(_arg1:Object, _arg2:Object, _arg3:int):void;
        function removeItemAt(_arg1:Object, _arg2:int):Object;
        function getItemIndex(_arg1:Object, _arg2:Object):int;

    }
}//package org.josht.starling.foxhole.data
