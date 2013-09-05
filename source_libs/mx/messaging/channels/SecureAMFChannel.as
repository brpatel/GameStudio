//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging.channels
{
    public class SecureAMFChannel extends AMFChannel 
    {

        public function SecureAMFChannel(_arg1:String=null, _arg2:String=null)
        {
            super(_arg1, _arg2);
        }

        override public function get protocol():String
        {
            return ("https");
        }


    }
}//package mx.messaging.channels
