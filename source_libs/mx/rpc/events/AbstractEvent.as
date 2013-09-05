//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.rpc.events
{
    import mx.messaging.events.MessageEvent;
    import mx.rpc.AsyncToken;
    import mx.messaging.messages.IMessage;
    import mx.core.mx_internal;

    use namespace mx_internal;

    public class AbstractEvent extends MessageEvent 
    {

        private var _token:AsyncToken;

        public function AbstractEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=true, _arg4:AsyncToken=null, _arg5:IMessage=null)
        {
            super(_arg1, _arg2, _arg3, _arg5);
            this._token = _arg4;
        }

        public function get token():AsyncToken
        {
            return (this._token);
        }

        mx_internal function setToken(_arg1:AsyncToken):void
        {
            this._token = _arg1;
        }

        mx_internal function callTokenResponders():void
        {
        }


    }
}//package mx.rpc.events
