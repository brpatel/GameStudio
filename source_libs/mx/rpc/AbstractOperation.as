//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.rpc
{
    import mx.resources.IResourceManager;
    import mx.core.mx_internal;
    import mx.resources.ResourceManager;
    import mx.rpc.events.AbstractEvent;

    use namespace mx_internal;

    public class AbstractOperation extends AbstractInvoker 
    {

        public var arguments:Object;
        public var properties:Object;
        private var resourceManager:IResourceManager;
        mx_internal var _service:AbstractService;
        private var _name:String;

        public function AbstractOperation(_arg1:AbstractService=null, _arg2:String=null)
        {
            this.resourceManager = ResourceManager.getInstance();
            super();
            this._service = _arg1;
            this._name = _arg2;
            this.arguments = {};
        }

        public function get name():String
        {
            return (this._name);
        }

        public function set name(_arg1:String):void
        {
            var _local2:String;
            if (!this._name)
            {
                this._name = _arg1;
            }
            else
            {
                _local2 = this.resourceManager.getString("rpc", "cannotResetOperationName");
                throw (new Error(_local2));
            };
        }

        public function get service():AbstractService
        {
            return (this._service);
        }

        mx_internal function setService(_arg1:AbstractService):void
        {
            var _local2:String;
            if (!this._service)
            {
                this._service = _arg1;
            }
            else
            {
                _local2 = this.resourceManager.getString("rpc", "cannotResetService");
                throw (new Error(_local2));
            };
        }

        public function send(... _args):AsyncToken
        {
            return (null);
        }

        override mx_internal function dispatchRpcEvent(_arg1:AbstractEvent):void
        {
            _arg1.callTokenResponders();
            if (!_arg1.isDefaultPrevented())
            {
                if (hasEventListener(_arg1.type))
                {
                    dispatchEvent(_arg1);
                }
                else
                {
                    if (this._service != null)
                    {
                        this._service.dispatchEvent(_arg1);
                    };
                };
            };
        }


    }
}//package mx.rpc
