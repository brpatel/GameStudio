//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.validators
{
    import mx.core.mx_internal;

    use namespace mx_internal;

    public class ValidationResult 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        public var errorCode:String;
        public var errorMessage:String;
        public var isError:Boolean;
        public var subField:String;

        public function ValidationResult(_arg1:Boolean, _arg2:String="", _arg3:String="", _arg4:String="")
        {
            this.isError = _arg1;
            this.subField = _arg2;
            this.errorMessage = _arg4;
            this.errorCode = _arg3;
        }

    }
}//package mx.validators
