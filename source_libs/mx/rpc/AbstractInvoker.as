//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.rpc
{
    import flash.events.EventDispatcher;
    import mx.core.mx_internal;
    import mx.resources.IResourceManager;
    import mx.logging.ILogger;
    import mx.resources.ResourceManager;
    import mx.logging.Log;
    import flash.events.Event;
    import mx.rpc.events.AbstractEvent;
    import mx.netmon.NetworkMonitor;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.events.FaultEvent;
    import mx.messaging.events.MessageEvent;
    import mx.messaging.messages.AsyncMessage;
    import mx.messaging.events.MessageFaultEvent;
    import mx.messaging.messages.IMessage;
    import mx.rpc.events.InvokeEvent;
    import mx.messaging.errors.MessagingError;
    import flash.utils.getQualifiedClassName;
    import mx.utils.ObjectProxy;

    use namespace mx_internal;

    public class AbstractInvoker extends EventDispatcher 
    {

        mx_internal static const BINDING_RESULT:String = "resultForBinding";

        private var resourceManager:IResourceManager;
        public var operationManager:Function;
        public var resultType:Class;
        public var resultElementType:Class;
        mx_internal var activeCalls:ActiveCalls;
        mx_internal var _responseHeaders:Array;
        mx_internal var _result:Object;
        mx_internal var _makeObjectsBindable:Boolean;
        private var _asyncRequest:AsyncRequest;
        private var _log:ILogger;

        public function AbstractInvoker()
        {
            this.resourceManager = ResourceManager.getInstance();
            super();
            this._log = Log.getLogger("mx.rpc.AbstractInvoker");
            this.activeCalls = new ActiveCalls();
        }

        [Bindable("resultForBinding")]
        public function get lastResult():Object
        {
            return (this._result);
        }

        public function get makeObjectsBindable():Boolean
        {
            return (this._makeObjectsBindable);
        }

        public function set makeObjectsBindable(_arg1:Boolean):void
        {
            this._makeObjectsBindable = _arg1;
        }

        public function cancel(_arg1:String=null):AsyncToken
        {
            if (_arg1 != null)
            {
                return (this.activeCalls.removeCall(_arg1));
            };
            return (this.activeCalls.cancelLast());
        }

        public function clearResult(_arg1:Boolean=true):void
        {
            if (_arg1)
            {
                this.setResult(null);
            }
            else
            {
                this._result = null;
            };
        }

        public function setResult(_arg1:Object):void
        {
            this._result = _arg1;
            dispatchEvent(new Event(BINDING_RESULT));
        }

        mx_internal function dispatchRpcEvent(_arg1:AbstractEvent):void
        {
            _arg1.callTokenResponders();
            if (!_arg1.isDefaultPrevented())
            {
                dispatchEvent(_arg1);
            };
        }

        mx_internal function monitorRpcEvent(_arg1:AbstractEvent):void
        {
            if (NetworkMonitor.isMonitoring())
            {
                if ((_arg1 is ResultEvent))
                {
                    NetworkMonitor.monitorResult(_arg1.message, ResultEvent(_arg1).result);
                }
                else
                {
                    if ((_arg1 is FaultEvent))
                    {
                        NetworkMonitor.monitorFault(_arg1.message, FaultEvent(_arg1).fault);
                    };
                };
            };
        }

        mx_internal function resultHandler(_arg1:MessageEvent):void
        {
            var _local3:ResultEvent;
            var _local2:AsyncToken = this.preHandle(_arg1);
            if (_local2 == null)
            {
                return;
            };
            if (this.processResult(_arg1.message, _local2))
            {
                dispatchEvent(new Event(BINDING_RESULT));
                _local3 = ResultEvent.createEvent(this._result, _local2, _arg1.message);
                _local3.headers = this._responseHeaders;
                this.dispatchRpcEvent(_local3);
            };
        }

        mx_internal function faultHandler(_arg1:MessageFaultEvent):void
        {
            var _local4:Fault;
            var _local5:FaultEvent;
            var _local2:MessageEvent = MessageEvent.createEvent(MessageEvent.MESSAGE, _arg1.message);
            var _local3:AsyncToken = this.preHandle(_local2);
            if ((((((((_local3 == null)) && (!((AsyncMessage(_arg1.message).correlationId == null))))) && (!((AsyncMessage(_arg1.message).correlationId == ""))))) && (!((_arg1.faultCode == "Client.Authentication")))))
            {
                return;
            };
            if (this.processFault(_arg1.message, _local3))
            {
                _local4 = new Fault(_arg1.faultCode, _arg1.faultString, _arg1.faultDetail);
                _local4.content = _arg1.message.body;
                _local4.rootCause = _arg1.rootCause;
                _local5 = FaultEvent.createEvent(_local4, _local3, _arg1.message);
                _local5.headers = this._responseHeaders;
                this.dispatchRpcEvent(_local5);
            };
        }

        mx_internal function getNetmonId():String
        {
            return (null);
        }

        mx_internal function invoke(_arg1:IMessage, _arg2:AsyncToken=null):AsyncToken
        {
            var fault:Fault;
            var errorText:String;
            var message:IMessage = _arg1;
            var token = _arg2;
            if (token == null)
            {
                token = new AsyncToken(message);
            }
            else
            {
                token.setMessage(message);
            };
            this.activeCalls.addCall(message.messageId, token);
            try
            {
                this.asyncRequest.invoke(message, new Responder(this.resultHandler, this.faultHandler));
                this.dispatchRpcEvent(InvokeEvent.createEvent(token, message));
            }
            catch(e:MessagingError)
            {
                _log.warn(e.toString());
                errorText = resourceManager.getString("rpc", "cannotConnectToDestination", [asyncRequest.destination]);
                fault = new Fault("InvokeFailed", e.toString(), errorText);
                new AsyncDispatcher(dispatchRpcEvent, [FaultEvent.createEvent(fault, token, message)], 10);
            }
            catch(e2:Error)
            {
                _log.warn(e2.toString());
                fault = new Fault("InvokeFailed", e2.message);
                new AsyncDispatcher(dispatchRpcEvent, [FaultEvent.createEvent(fault, token, message)], 10);
            };
            return (token);
        }

        mx_internal function preHandle(_arg1:MessageEvent):AsyncToken
        {
            return (this.activeCalls.removeCall(AsyncMessage(_arg1.message).correlationId));
        }

        mx_internal function processFault(_arg1:IMessage, _arg2:AsyncToken):Boolean
        {
            return (true);
        }

        mx_internal function processResult(_arg1:IMessage, _arg2:AsyncToken):Boolean
        {
            var _local3:Object = _arg1.body;
            if (((((this.makeObjectsBindable) && (!((_local3 == null))))) && ((getQualifiedClassName(_local3) == "Object"))))
            {
                this._result = new ObjectProxy(_local3);
            }
            else
            {
                this._result = _local3;
            };
            return (true);
        }

        mx_internal function get asyncRequest():AsyncRequest
        {
            if (this._asyncRequest == null)
            {
                this._asyncRequest = new AsyncRequest();
            };
            return (this._asyncRequest);
        }

        mx_internal function set asyncRequest(_arg1:AsyncRequest):void
        {
            this._asyncRequest = _arg1;
        }


    }
}//package mx.rpc
