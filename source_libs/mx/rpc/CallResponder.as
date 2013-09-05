//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.rpc
{
    import flash.events.EventDispatcher;
    import mx.utils.ArrayUtil;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.events.FaultEvent;
    import mx.events.PropertyChangeEvent;

    public class CallResponder extends EventDispatcher implements IResponder 
    {

        private var _token:AsyncToken;
        private var _1897299539lastResult;


        private function set _110541305token(_arg1:AsyncToken):void
        {
            var _local2:Array;
            var _local3:int;
            if (this._token != null)
            {
                _local2 = this._token.responders;
                _local3 = ArrayUtil.getItemIndex(this, _local2);
                if (_local3 != -1)
                {
                    _local2.splice(_local3, 1);
                };
            };
            if (_arg1 != null)
            {
                _arg1.addResponder(this);
            };
            this._token = _arg1;
        }

        public function get token():AsyncToken
        {
            return (this._token);
        }

        public function result(_arg1:Object):void
        {
            var _local2:ResultEvent = ResultEvent(_arg1);
            this.lastResult = _local2.result;
            dispatchEvent(_local2);
        }

        public function fault(_arg1:Object):void
        {
            var _local2:FaultEvent = FaultEvent(_arg1);
            dispatchEvent(_local2);
        }

        [Bindable(event="propertyChange")]
        public function get lastResult()
        {
            return (this._1897299539lastResult);
        }

        public function set lastResult(_arg1):void
        {
            var _local3:Object = this._1897299539lastResult;
            if (_local3 !== _arg1)
            {
                this._1897299539lastResult = _arg1;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lastResult", _local3, _arg1));
                };
            };
        }

        [Bindable(event="propertyChange")]
        public function set token(_arg1:AsyncToken):void
        {
            var _local3:Object = this.token;
            if (_local3 !== _arg1)
            {
                this._110541305token = _arg1;
                if (this.hasEventListener("propertyChange"))
                {
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "token", _local3, _arg1));
                };
            };
        }


    }
}//package mx.rpc
