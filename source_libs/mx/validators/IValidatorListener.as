//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.validators
{
    import mx.events.ValidationResultEvent;

    public interface IValidatorListener 
    {

        function get errorString():String;
        function set errorString(_arg1:String):void;
        function get validationSubField():String;
        function set validationSubField(_arg1:String):void;
        function validationResultHandler(_arg1:ValidationResultEvent):void;

    }
}//package mx.validators
