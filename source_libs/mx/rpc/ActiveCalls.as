//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.rpc
{
    public class ActiveCalls 
    {

        private var calls:Object;
        private var callOrder:Array;

        public function ActiveCalls()
        {
            this.calls = {};
            this.callOrder = [];
        }

        public function addCall(_arg1:String, _arg2:AsyncToken):void
        {
            this.calls[_arg1] = _arg2;
            this.callOrder.push(_arg1);
        }

        public function getAllMessages():Array
        {
            var _local2:String;
            var _local1:Array = [];
            for (_local2 in this.calls)
            {
                _local1.push(this.calls[_local2]);
            };
            return (_local1);
        }

        public function cancelLast():AsyncToken
        {
            if (this.callOrder.length > 0)
            {
                return (this.removeCall((this.callOrder[(this.callOrder.length - 1)] as String)));
            };
            return (null);
        }

        public function hasActiveCalls():Boolean
        {
            return ((this.callOrder.length > 0));
        }

        public function removeCall(_arg1:String):AsyncToken
        {
            var _local2:AsyncToken = this.calls[_arg1];
            if (_local2 != null)
            {
                delete this.calls[_arg1];
                this.callOrder.splice(this.callOrder.lastIndexOf(_arg1), 1);
            };
            return (_local2);
        }

        public function wasLastCall(_arg1:String):Boolean
        {
            if (this.callOrder.length > 0)
            {
                return ((this.callOrder[(this.callOrder.length - 1)] == _arg1));
            };
            return (false);
        }


    }
}//package mx.rpc
