//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.core
{
    public class RSLData 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        private var _applicationDomainTarget:String;
        private var _digest:String;
        private var _hashType:String;
        private var _isSigned:Boolean;
        private var _moduleFactory:IFlexModuleFactory;
        private var _policyFileURL:String;
        private var _rslURL:String;
        private var _verifyDigest:Boolean;

        public function RSLData(_arg1:String=null, _arg2:String=null, _arg3:String=null, _arg4:String=null, _arg5:Boolean=false, _arg6:Boolean=false, _arg7:String="default")
        {
            this._rslURL = _arg1;
            this._policyFileURL = _arg2;
            this._digest = _arg3;
            this._hashType = _arg4;
            this._isSigned = _arg5;
            this._verifyDigest = _arg6;
            this._applicationDomainTarget = _arg7;
            this._moduleFactory = this.moduleFactory;
        }

        public function get applicationDomainTarget():String
        {
            return (this._applicationDomainTarget);
        }

        public function get digest():String
        {
            return (this._digest);
        }

        public function get hashType():String
        {
            return (this._hashType);
        }

        public function get isSigned():Boolean
        {
            return (this._isSigned);
        }

        public function get moduleFactory():IFlexModuleFactory
        {
            return (this._moduleFactory);
        }

        public function set moduleFactory(_arg1:IFlexModuleFactory):void
        {
            this._moduleFactory = _arg1;
        }

        public function get policyFileURL():String
        {
            return (this._policyFileURL);
        }

        public function get rslURL():String
        {
            return (this._rslURL);
        }

        public function get verifyDigest():Boolean
        {
            return (this._verifyDigest);
        }


    }
}//package mx.core
