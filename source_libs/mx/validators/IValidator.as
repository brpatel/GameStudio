//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.validators
{
    import mx.events.ValidationResultEvent;

    public interface IValidator 
    {

        function get enabled():Boolean;
        function set enabled(_arg1:Boolean):void;
        function validate(_arg1:Object=null, _arg2:Boolean=false):ValidationResultEvent;

    }
}//package mx.validators
