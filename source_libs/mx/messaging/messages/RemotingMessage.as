//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging.messages
{
    public class RemotingMessage extends AbstractMessage 
    {

        public var operation:String;
        public var source:String;

        public function RemotingMessage()
        {
            this.operation = "";
        }

    }
}//package mx.messaging.messages
