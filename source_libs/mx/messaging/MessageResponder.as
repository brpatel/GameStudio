//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging
{
    import flash.net.Responder;
    import flash.utils.Timer;
    import mx.resources.IResourceManager;
    import mx.messaging.messages.IMessage;
    import mx.resources.ResourceManager;
    import flash.events.TimerEvent;
    import mx.messaging.messages.ErrorMessage;

    public class MessageResponder extends Responder 
    {

        private var _requestTimedOut:Boolean;
        private var _requestTimer:Timer;
        private var resourceManager:IResourceManager;
        private var _agent:MessageAgent;
        private var _channel:Channel;
        private var _message:IMessage;

        public function MessageResponder(_arg1:MessageAgent, _arg2:IMessage, _arg3:Channel=null)
        {
            this.resourceManager = ResourceManager.getInstance();
            super(this.result, this.status);
            this._agent = _arg1;
            this._channel = _arg3;
            this._message = _arg2;
            this._requestTimedOut = false;
        }

        public function get agent():MessageAgent
        {
            return (this._agent);
        }

        public function get channel():Channel
        {
            return (this._channel);
        }

        public function get message():IMessage
        {
            return (this._message);
        }

        public function set message(_arg1:IMessage):void
        {
            this._message = _arg1;
        }

        final public function startRequestTimeout(_arg1:int):void
        {
            this._requestTimer = new Timer((_arg1 * 1000), 1);
            this._requestTimer.addEventListener(TimerEvent.TIMER, this.timeoutRequest);
            this._requestTimer.start();
        }

        final public function result(_arg1:IMessage):void
        {
            if (!this._requestTimedOut)
            {
                if (this._requestTimer != null)
                {
                    this.releaseTimer();
                };
                this.resultHandler(_arg1);
            };
        }

        final public function status(_arg1:IMessage):void
        {
            if (!this._requestTimedOut)
            {
                if (this._requestTimer != null)
                {
                    this.releaseTimer();
                };
                this.statusHandler(_arg1);
            };
        }

        protected function createRequestTimeoutErrorMessage():ErrorMessage
        {
            var _local1:ErrorMessage = new ErrorMessage();
            _local1.correlationId = this.message.messageId;
            _local1.faultCode = "Client.Error.RequestTimeout";
            _local1.faultString = this.resourceManager.getString("messaging", "requestTimedOut");
            _local1.faultDetail = this.resourceManager.getString("messaging", "requestTimedOut.details");
            return (_local1);
        }

        protected function resultHandler(_arg1:IMessage):void
        {
        }

        protected function requestTimedOut():void
        {
        }

        protected function statusHandler(_arg1:IMessage):void
        {
        }

        private function timeoutRequest(_arg1:TimerEvent):void
        {
            this._requestTimedOut = true;
            this.releaseTimer();
            this.requestTimedOut();
        }

        private function releaseTimer():void
        {
            this._requestTimer.stop();
            this._requestTimer.removeEventListener(TimerEvent.TIMER, this.timeoutRequest);
            this._requestTimer = null;
        }


    }
}//package mx.messaging
