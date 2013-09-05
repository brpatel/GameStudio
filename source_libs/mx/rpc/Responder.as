//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.rpc
{
    public class Responder implements IResponder 
    {

        private var _resultHandler:Function;
        private var _faultHandler:Function;

        public function Responder(_arg1:Function, _arg2:Function)
        {
            this._resultHandler = _arg1;
            this._faultHandler = _arg2;
        }

        public function result(_arg1:Object):void
        {
            this._resultHandler(_arg1);
        }

        public function fault(_arg1:Object):void
        {
            this._faultHandler(_arg1);
        }


    }
}//package mx.rpc
