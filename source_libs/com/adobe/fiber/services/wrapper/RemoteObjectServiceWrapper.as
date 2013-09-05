//Created by Action Script Viewer - http://www.buraks.com/asv
package com.adobe.fiber.services.wrapper
{
    import mx.rpc.remoting.RemoteObject;
    import flash.events.IEventDispatcher;
    import mx.rpc.AbstractService;

    public class RemoteObjectServiceWrapper extends AbstractServiceWrapper 
    {

        protected var _serviceControl:RemoteObject;

        public function RemoteObjectServiceWrapper(_arg1:IEventDispatcher=null)
        {
            super(_arg1);
        }

        override public function get serviceControl():AbstractService
        {
            return (this._serviceControl);
        }

        public function get source():String
        {
            return (this.serviceControl.source);
        }

        public function set source(_arg1:String):void
        {
            this.serviceControl.source = _arg1;
        }

        public function get endpoint():String
        {
            return (this.serviceControl.endpoint);
        }

        public function set endpoint(_arg1:String):void
        {
            this.serviceControl.endpoint = _arg1;
        }


    }
}//package com.adobe.fiber.services.wrapper
