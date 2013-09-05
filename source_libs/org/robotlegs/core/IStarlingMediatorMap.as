//Created by Action Script Viewer - http://www.buraks.com/asv
package org.robotlegs.core
{
    import starling.display.DisplayObjectContainer;

    public interface IStarlingMediatorMap 
    {

        function mapView(_arg1, _arg2:Class, _arg3=null, _arg4:Boolean=true, _arg5:Boolean=true):void;
        function unmapView(_arg1):void;
        function createMediator(_arg1:Object):IMediator;
        function registerMediator(_arg1:Object, _arg2:IMediator):void;
        function removeMediator(_arg1:IMediator):IMediator;
        function removeMediatorByView(_arg1:Object):IMediator;
        function retrieveMediator(_arg1:Object):IMediator;
        function hasMapping(_arg1):Boolean;
        function hasMediator(_arg1:IMediator):Boolean;
        function hasMediatorForView(_arg1:Object):Boolean;
        function get contextView():DisplayObjectContainer;
        function set contextView(_arg1:DisplayObjectContainer):void;
        function get enabled():Boolean;
        function set enabled(_arg1:Boolean):void;

    }
}//package org.robotlegs.core
