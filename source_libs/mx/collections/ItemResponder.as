//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.collections
{
    import mx.core.mx_internal;
    import mx.rpc.*;

    use namespace mx_internal;

    public class ItemResponder implements IResponder 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        private var _resultHandler:Function;
        private var _faultHandler:Function;
        private var _token:Object;

        public function ItemResponder(_arg1:Function, _arg2:Function, _arg3:Object=null)
        {
            this._resultHandler = _arg1;
            this._faultHandler = _arg2;
            this._token = _arg3;
        }

        public function result(_arg1:Object):void
        {
            this._resultHandler(_arg1, this._token);
        }

        public function fault(_arg1:Object):void
        {
            this._faultHandler(_arg1, this._token);
        }


    }
}//package mx.collections
