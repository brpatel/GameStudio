//Created by Action Script Viewer - http://www.buraks.com/asv
package com.adobe.fiber.services.wrapper
{
    import flash.events.EventDispatcher;
    import mx.core.mx_internal;
    import flash.events.IEventDispatcher;
    import com.adobe.fiber.core.model_internal;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.AbstractService;
    import mx.messaging.ChannelSet;
    import flash.events.Event;
    import mx.core.*;

    use namespace mx_internal;
    use namespace model_internal;

    public class AbstractServiceWrapper extends EventDispatcher implements IMXMLObject 
    {

        mx_internal var document:Object;
        mx_internal var id:String;

        public function AbstractServiceWrapper(_arg1:IEventDispatcher=null)
        {
            super(_arg1);
        }

        public function initialized(_arg1:Object, _arg2:String):void
        {
            this.mx_internal::document = _arg1;
            this.mx_internal::id = _arg2;
        }

        model_internal function initialize():void
        {
            this.serviceControl.addEventListener(ResultEvent.RESULT, model_internal::propagateEvents);
            this.serviceControl.addEventListener(FaultEvent.FAULT, model_internal::propagateEvents);
        }

        public function get serviceControl():AbstractService
        {
            return (null);
        }

        public function get destination():String
        {
            return (this.serviceControl.destination);
        }

        public function set destination(_arg1:String):void
        {
            this.serviceControl.destination = _arg1;
        }

        public function get channelSet():ChannelSet
        {
            return (this.serviceControl.channelSet);
        }

        public function set channelSet(_arg1:ChannelSet):void
        {
            this.serviceControl.channelSet = _arg1;
        }

        public function get operations():Object
        {
            return (this.serviceControl.operations);
        }

        public function set operations(_arg1:Object):void
        {
            this.serviceControl.operations = _arg1;
        }

        model_internal function propagateEvents(_arg1:Event):void
        {
            dispatchEvent(_arg1);
        }

        public function get showBusyCursor():Boolean
        {
            return (this.serviceControl.showBusyCursor);
        }

        public function set showBusyCursor(_arg1:Boolean):void
        {
            this.serviceControl.showBusyCursor = _arg1;
        }


    }
}//package com.adobe.fiber.services.wrapper
