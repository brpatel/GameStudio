//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.styles
{
    public interface IAdvancedStyleClient extends IStyleClient 
    {

        function get id():String;
        function get styleParent():IAdvancedStyleClient;
        function set styleParent(_arg1:IAdvancedStyleClient):void;
        function stylesInitialized():void;
        function matchesCSSState(_arg1:String):Boolean;
        function matchesCSSType(_arg1:String):Boolean;
        function hasCSSState():Boolean;

    }
}//package mx.styles
